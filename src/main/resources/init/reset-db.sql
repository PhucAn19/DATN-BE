-- PHẦN 1: Gỡ kết nối và xóa database nếu tồn tại
USE master;


SET IMPLICIT_TRANSACTIONS OFF;


SELECT @@TRANCOUNT;

WHILE @@TRANCOUNT > 0
BEGIN
    ROLLBACK;
END

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DATN_WebBHDT')
BEGIN
    ALTER DATABASE DATN_WebBHDT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DATN_WebBHDT;
END


-- PHẦN 2: Tạo lại database
CREATE DATABASE DATN_WebBHDT;


-- PHẦN 3: Tạo login cấp server nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'DEV_BACKEND')
BEGIN
    CREATE LOGIN DEV_BACKEND 
    WITH PASSWORD = 'DEV', 
         CHECK_POLICY = OFF, 
         CHECK_EXPIRATION = OFF;
END


-- PHẦN 4: Tạo user gắn với login trong database mới
USE DATN_WebBHDT;


IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DEV_BACKEND')
BEGIN
    CREATE USER DEV_BACKEND FOR LOGIN DEV_BACKEND;
END


-- PHẦN 5: Gán quyền db_owner cho user
EXEC sp_addrolemember 'db_owner', 'DEV_BACKEND';


/*===== TABLE =====*/
-- TAI_KHOAN
CREATE TABLE TAI_KHOAN(
	id_tk INT IDENTITY(1,1) PRIMARY KEY,
	tendangnhap NVARCHAR(255)  UNIQUE,
	matkhau NVARCHAR(255) ,
	vaitro BIT DEFAULT 0 ,
	hoveten NVARCHAR(255) ,
	sodienthoai VARCHAR(15)  UNIQUE,
	email NVARCHAR(255)  UNIQUE,
	trangthai BIT DEFAULT 0 ,
	ngaytao DATETIME  DEFAULT GETDATE(),
	ngaycapnhat DATETIME 
);

-- DIA_CHI
CREATE TABLE DIA_CHI(
	id_dc INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	diachi NVARCHAR(255) ,
);

-- SAN_PHAM
CREATE TABLE SAN_PHAM(
	id_sp INT IDENTITY(1,1)  PRIMARY KEY,
	tensanpham NVARCHAR(255) ,
	dongia BIGINT DEFAULT 0 CHECK (dongia >= 0) ,
	loai INT ,
	thuonghieu INT ,
	anhgoc NVARCHAR(255) ,
	ngaytao DATETIME DEFAULT GETDATE() ,
    --Giảm giá
	loaigiam INT ,
	giamgia INT DEFAULT 0 ,
	hangiamgia DATETIME 
); 

-- GIAM_GIA
CREATE TABLE GIAM_GIA (
    id_gg INT IDENTITY(1,1) PRIMARY KEY,
    loaigiamTen INT 
);

-- SP_LOAI
CREATE TABLE SP_LOAI(
	id_l INT IDENTITY(1,1)  PRIMARY KEY,
	loaiTen NVARCHAR(255) ,
);

-- SP_THUONG_HIEU
CREATE TABLE SP_THUONG_HIEU(
	id_th INT IDENTITY(1,1)  PRIMARY KEY,
	thuonghieuTen NVARCHAR(255) ,
);

-- SP_THONG_SO
CREATE TABLE SP_THONG_SO(
	id_ts INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	cpuBrand NVARCHAR(255) ,
	cpuModel NVARCHAR(255) ,
	cpuType NVARCHAR(255) ,
	cpuMinSpeed NVARCHAR(255) ,
	cpuMaxSpeed NVARCHAR(255) ,
	cpuCores NVARCHAR(255) ,
	cpuThreads NVARCHAR(255) ,
	cpuCache NVARCHAR(255) ,
	gpuBrand NVARCHAR(255) ,
	gpuModel NVARCHAR(255) ,
	gpuFullName NVARCHAR(255) ,
	gpuMemory NVARCHAR(255) ,
	ram NVARCHAR(255) ,
	rom NVARCHAR(255) ,
	screen NVARCHAR(255) ,
	mausac NVARCHAR(255) ,
	soluong INT DEFAULT 0 CHECK (soluong>= 0) ,
);

-- ANH_SP
CREATE TABLE ANH_SP(
	id_a INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	diachianh NVARCHAR(255) ,
);

-- HOA_DON
CREATE TABLE HOA_DON(
	id_hd INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	ngaytao DATETIME DEFAULT GETDATE() ,
	giahoadon BIGINT DEFAULT 0 CHECK (giahoadon >= 0) ,
	trangthai NVARCHAR(255) ,
	noidung NVARCHAR(255) ,
);

-- HD_CHI__TIET
CREATE TABLE HD_CHI_TIET(
	id_hdct INT IDENTITY(1,1)  PRIMARY KEY,
	hoadon INT ,
	sanpham INT ,
	dongia BIGINT DEFAULT 0 CHECK (dongia >= 0) ,
	soluong INT DEFAULT 0 CHECK (soluong>= 0) ,
);

-- THANH_TOAN
CREATE TABLE THANH_TOAN(
	id_tt INT IDENTITY(1,1)  PRIMARY KEY,
	hoadon INT ,
	phuongthuc NVARCHAR(255) ,
	sotien BIGINT DEFAULT 0 CHECK (sotien >= 0) ,
	ngaythanhtoan DATETIME ,
	magiaodich NVARCHAR(255) ,
	taikhoan INT ,
	ngaytao DATETIME DEFAULT GETDATE() ,
);

-- GIO_HANG
CREATE TABLE GIO_HANG(
	id_gh INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	taikhoan INT ,
);

-- GOP_Y
CREATE TABLE GOP_Y(
	id_gy INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	noidung NVARCHAR(255) ,
	ngaytao DATETIME DEFAULT GETDATE(),
    ngaycapnhat DATETIME
);

-- DANH_GIA
CREATE TABLE DANH_GIA(
	id_dg INT IDENTITY(1,1)  PRIMARY KEY,
	taikhoan INT ,
	sanpham INT ,
	noidung NVARCHAR(255) ,
	diemso INT DEFAULT 0 CHECK (diemso>=0 AND diemso<=5) ,
);

-- YEU_THICH
CREATE TABLE YEU_THICH(
	id_yt INT IDENTITY(1,1)  PRIMARY KEY,
	sanpham INT ,
	taikhoan INT ,
    trangthai NVARCHAR(5)
);


/*===== FOREIGN KEY =====*/
-- fk_TAIKHOAN_DIACHI
ALTER TABLE DIA_CHI
ADD CONSTRAINT fk_TAIKHOAN_DIACHI
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_TAIKHOAN_HOADON
ALTER TABLE HOA_DON
ADD CONSTRAINT fk_TAIKHOAN_HOADON
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_TAIKHOAN_GIOHANG
ALTER TABLE GIO_HANG
ADD CONSTRAINT fk_TAIKHOAN_GIOHANG
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_TAIKHOAN_GOPY
ALTER TABLE GOP_Y
ADD CONSTRAINT fk_TAIKHOAN_GOPY
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_TAIKHOAN_DANHGIA
ALTER TABLE DANH_GIA
ADD CONSTRAINT fk_TAIKHOAN_DANHGIA
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_TAIKHOAN_YEU_THICH
ALTER TABLE YEU_THICH
ADD CONSTRAINT fk_TAIKHOAN_YEU_THICH
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

-- fk_SANPHAM_LOAI
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_SANPHAM_LOAI
FOREIGN KEY (loai) REFERENCES SP_LOAI(id_l);

-- fk_SANPHAM
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_SANPHAM_GIAMGIA
FOREIGN KEY (loaigiam) REFERENCES GIAM_GIA(id_gg);

-- fk_SANPHAM_THUONGHIEU
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_SANPHAM_THUONGHIEU
FOREIGN KEY (thuonghieu) REFERENCES SP_THUONG_HIEU(id_th);

-- fk_SANPHAM_THONGSO
ALTER TABLE SP_THONG_SO
ADD CONSTRAINT fk_SANPHAM_THONGSO
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id_sp);

-- fk_SANPHAM_ANH
ALTER TABLE ANH_SP
ADD CONSTRAINT fk_SANPHAM_ANH
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id_sp);

-- fk_SANPHAM_HOADONCT
ALTER TABLE HD_CHI_TIET
ADD CONSTRAINT fk_SANPHAM_HOADONCT
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id_sp);

-- fk_SANPHAM_GIOHANG
ALTER TABLE GIO_HANG
ADD CONSTRAINT fk_SANPHAM_GIOHANG
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id_sp);

-- fk_SANPHAM_YEUTHICH
ALTER TABLE YEU_THICH
ADD CONSTRAINT fk_SANPHAM_YEUTHICH
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id_sp);

-- fk_HOADON_HDCHITIET
ALTER TABLE HD_CHI_TIET
ADD CONSTRAINT fk_HOADON_HDCHITIET
FOREIGN KEY (hoadon) REFERENCES HOA_DON(id_hd);

-- fk_THANHTOAN_HOADON
ALTER TABLE THANH_TOAN
ADD CONSTRAINT fk_THANHTOAN_HOADON
FOREIGN KEY (hoadon) REFERENCES HOA_DON(id_hd);

-- fk_THANHTOAN_TAIKHOAN
ALTER TABLE THANH_TOAN
ADD CONSTRAINT fk_THANHTOAN_TAIKHOAN
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id_tk);

/*===== VIEW =====*/
CREATE VIEW vw_SanPham_ChiTiet
AS
SELECT 
    -- Thông tin sản phẩm chính
    SP.id_sp,
    SP.tensanpham,
    SP.dongia,
    SP.loai,
    L.loaiTen,
    SP.thuonghieu,
    TH.thuonghieuTen,
    SP.anhgoc,
    SP.hangiamgia,
    SP.ngaytao,
    SP.loaigiam,
    GG.loaigiamTen,

    -- Thông số kỹ thuật
    TS.id_ts,
    TS.cpuBrand,
    TS.cpuModel,
    TS.cpuType,
    TS.cpuMinSpeed,
    TS.cpuMaxSpeed,
    TS.cpuCores,
    TS.cpuThreads,
    TS.cpuCache,
    TS.gpuBrand,
    TS.gpuModel,
    TS.gpuFullName,
    TS.gpuMemory,
    TS.ram,
    TS.rom,
    TS.screen,
    TS.mausac,
    TS.soluong,

    -- Ảnh phụ
    A.id_a,
    A.diachianh,

    -- Đánh giá
    DG.id_dg,
	DG.taikhoan as dg_taikhoan,
	DG.sanpham as dg_sanpham,
	DG.noidung,
	DG.diemso,

    -- Yêu thích
    YT.id_yt,
	YT.sanpham as yt_sanpham,
	YT.taikhoan as yt_taikhoan,
    YT.trangthai
FROM 
    SAN_PHAM SP
LEFT JOIN SP_LOAI L ON SP.loai = L.id_l
LEFT JOIN SP_THUONG_HIEU TH ON SP.thuonghieu = TH.id_th
LEFT JOIN GIAM_GIA GG ON SP.loaigiam = GG.id_gg
LEFT JOIN SP_THONG_SO TS ON SP.id_sp = TS.sanpham
LEFT JOIN ANH_SP A ON SP.id_sp = A.sanpham
LEFT JOIN DANH_GIA DG ON SP.id_sp = DG.sanpham
LEFT JOIN YEU_THICH YT ON SP.id_sp = YT.sanpham;

/*===== TRIGGER =====*/
--trg_auto_dayedit_taikhoan
CREATE TRIGGER trg_auto_dayedit_taikhoan
ON TAI_KHOAN
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    UPDATE TAI_KHOAN
    SET ngaycapnhat = GETDATE()
    FROM TAI_KHOAN
    INNER JOIN inserted i ON TAI_KHOAN.id_tk = i.id_tk;
END;

--trg_auto_giagiam_sanpham
CREATE TRIGGER trg_auto_giagiam_sanpham
ON SAN_PHAM
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(dongia) OR UPDATE(loaigiam)
    BEGIN
        UPDATE sp
        SET sp.giamgia = sp.dongia * (1 - (i.loaigiam) / 100.0)
        FROM SAN_PHAM sp
        INNER JOIN inserted i ON sp.id_sp = i.id_sp;
    END
END;

/*===== PROC =====*/
-- DATN_CRE_SP_DB00001_0
CREATE PROCEDURE WBH_AD_CRT_THEMSP
    @tensanpham NVARCHAR(255),
    @dongia BIGINT,
    @loai INT,
    @thuonghieu INT,
    @anhgoc NVARCHAR(255),
    @cpuBrand NVARCHAR(255),
    @cpuModel NVARCHAR(255),
    @cpuType NVARCHAR(255),
    @cpuMinSpeed NVARCHAR(255),
    @cpuMaxSpeed NVARCHAR(255),
    @cpuCores NVARCHAR(255),
    @cpuThreads NVARCHAR(255),
    @cpuCache NVARCHAR(255),
    @gpuBrand NVARCHAR(255),
    @gpuModel NVARCHAR(255),
    @gpuFullName NVARCHAR(255),
    @gpuMemory NVARCHAR(255),
    @ram NVARCHAR(255),
    @rom NVARCHAR(255),
    @screen NVARCHAR(255),
    @mausac NVARCHAR(255),
    @soluong INT,
    @anhphu NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc)
        VALUES (@tensanpham, @dongia, @loai, @thuonghieu, @anhgoc);
        DECLARE @NewProductID INT = SCOPE_IDENTITY();
        INSERT INTO SP_THONG_SO (
            sanpham, cpuBrand, cpuModel, cpuType, cpuMinSpeed, cpuMaxSpeed, cpuCores, cpuThreads, cpuCache,
            gpuBrand, gpuModel, gpuFullName, gpuMemory, ram, rom, screen, mausac, soluong
        )
        VALUES (
            @NewProductID, @cpuBrand, @cpuModel, @cpuType, @cpuMinSpeed, @cpuMaxSpeed, @cpuCores, @cpuThreads, @cpuCache,
            @gpuBrand, @gpuModel, @gpuFullName, @gpuMemory, @ram, @rom, @screen, @mausac, @soluong
        );
        INSERT INTO ANH_SP (sanpham, diachianh)
        VALUES (@NewProductID, @anhphu);
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;

-- DATN_CRE_SP_DB00001_1
CREATE PROCEDURE WBH_US_SEL_DETAIL_SP
    @p_id_sp INT 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        vw_SanPham_ChiTiet
    WHERE 
        id_sp = @p_id_sp;
END;

-- DATN_CRE_SP_DB00001_2
CREATE PROCEDURE WBH_US_SEL_XEMSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        vw_SanPham_ChiTiet
END;

-- DATN_CRE_SP_DB00001_3
CREATE PROCEDURE WBH_US_SEL_NGAYTAOSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM vw_SanPham_ChiTiet
    ORDER BY ngaytao DESC;
END;

-- DATN_CRE_SP_DB00001_4
CREATE PROCEDURE WBH_US_SEL_RANKYTSP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SPCT.*, 
        ISNULL(YT.SoYeuThich, 0) AS SoYeuThich
    FROM 
        vw_SanPham_ChiTiet SPCT
    LEFT JOIN (
        SELECT sanpham, COUNT(*) AS SoYeuThich
        FROM YEU_THICH
        GROUP BY sanpham
    ) YT ON SPCT.id_sp = YT.sanpham
    ORDER BY 
        YT.SoYeuThich DESC;
END;

-- DATN_CRE_SP_DB00001_5 
CREATE PROCEDURE WBH_US_SEL_SALESP
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vw_SanPham_ChiTiet
    WHERE hangiamgia >= GETDATE();
END;

-- DATN_CRE_SP_DB00001_6
CREATE PROCEDURE WBH_AD_UPD_SUASP
    @sanphamID INT,
    @tensanpham NVARCHAR(255),
    @dongia BIGINT,
    @loai INT,
    @thuonghieu INT,
    @anhgoc NVARCHAR(255),
    @cpuBrand NVARCHAR(255),
    @cpuModel NVARCHAR(255),
    @cpuType NVARCHAR(255),
    @cpuMinSpeed NVARCHAR(255),
    @cpuMaxSpeed NVARCHAR(255),
    @cpuCores NVARCHAR(255),
    @cpuThreads NVARCHAR(255),
    @cpuCache NVARCHAR(255),
    @gpuBrand NVARCHAR(255),
    @gpuModel NVARCHAR(255),
    @gpuFullName NVARCHAR(255),
    @gpuMemory NVARCHAR(255),
    @ram NVARCHAR(255),
    @rom NVARCHAR(255),
    @screen NVARCHAR(255),
    @mausac NVARCHAR(255),
    @soluong INT,
    @anhphu NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Cập nhật bảng SAN_PHAM
        UPDATE SAN_PHAM
        SET tensanpham = @tensanpham,
            dongia = @dongia,
            loai = @loai,
            thuonghieu = @thuonghieu,
            anhgoc = @anhgoc
        WHERE id_sp = @sanphamID;

        -- Cập nhật bảng SP_THONG_SO
        UPDATE SP_THONG_SO
        SET cpuBrand = @cpuBrand,
            cpuModel = @cpuModel,
            cpuType = @cpuType,
            cpuMinSpeed = @cpuMinSpeed,
            cpuMaxSpeed = @cpuMaxSpeed,
            cpuCores = @cpuCores,
            cpuThreads = @cpuThreads,
            cpuCache = @cpuCache,
            gpuBrand = @gpuBrand,
            gpuModel = @gpuModel,
            gpuFullName = @gpuFullName,
            gpuMemory = @gpuMemory,
            ram = @ram,
            rom = @rom,
            screen = @screen,
            mausac = @mausac,
            soluong = @soluong
        WHERE sanpham = @sanphamID;

        -- Cập nhật bảng ANH_SP
        UPDATE ANH_SP
        SET diachianh = @anhphu
        WHERE sanpham = @sanphamID;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;

-- DATN_CRE_GY_DB00002_0
CREATE PROCEDURE WBH_US_CRT_GY
    @id_tk INT,
    @noidung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO GOP_Y(taikhoan, noidung)
    VALUES (@id_tk, @noidung);
END;

-- DATN_CRE_GY_DB00002_1
CREATE PROCEDURE WBH_AD_SEL_GY_PHAN_TRANG
    @p_pageNo INT,
    @p_pageSize INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *
    FROM 
        GOP_Y
    ORDER BY 
        ngaytao DESC
    OFFSET (@p_pageNo - 1) * @p_pageSize ROWS
    FETCH NEXT @p_pageSize ROWS ONLY;
END;

-- DATN_CRE_GY_DB00003_0
CREATE PROCEDURE WBH_US_UPD_CAPNHAT_YT_SP
    @sanpham INT,
    @taikhoan INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM YEU_THICH 
        WHERE sanpham = @sanpham AND taikhoan = @taikhoan
    )
    BEGIN
        UPDATE YEU_THICH
        SET trangthai = CASE WHEN trangthai = 'Y' THEN 'N' ELSE 'Y' END
        WHERE sanpham = @sanpham AND taikhoan = @taikhoan;
    END
    ELSE
    BEGIN
        -- Nếu chưa có, thêm mới với trạng thái 1 (yêu thích)
        INSERT INTO YEU_THICH(sanpham, taikhoan, trangthai)
        VALUES (@sanpham, @taikhoan, 'Y');
    END
END;

/*===== CHECK FOREIGN KEY =====*/
SELECT 
    fk.name AS foreign_key_name,
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.tables AS tp ON fkc.parent_object_id = tp.object_id
INNER JOIN 
    sys.columns AS cp ON fkc.parent_object_id = cp.object_id 
                    AND fkc.parent_column_id = cp.column_id
INNER JOIN 
    sys.tables AS tr ON fkc.referenced_object_id = tr.object_id
INNER JOIN 
    sys.columns AS cr ON fkc.referenced_object_id = cr.object_id 
                    AND fkc.referenced_column_id = cr.column_id
ORDER BY 
    tp.name, fk.name;

/*===== CHECK TRIGGER =====*/
SELECT
    t.name AS TriggerName, 
    o.name AS TableName,
    t.is_disabled AS IsDisabled, 
    t.create_date AS CreateDate,
    t.modify_date AS ModifyDate
FROM 
    sys.triggers t
JOIN 
    sys.objects o ON t.parent_id = o.object_id
WHERE 
    t.is_ms_shipped = 0
ORDER BY 
    t.create_date DESC;

/*===== CHECK PROCEDURE =====*/
SELECT name 
FROM sys.procedures;

--SP_LOAI
INSERT INTO SP_LOAI (loaiTen) VALUES 
(N'Điện thoại di động'),
(N'Máy tính bảng'),
(N'Laptop'),
(N'Máy tính để bàn'),
(N'Thiết bị đeo thông minh'),
(N'Phụ kiện điện thoại'),
(N'Phụ kiện máy tính'),
(N'Thiết bị mạng'),
(N'Thiết bị lưu trữ'),
(N'Tivi'),
(N'Loa và tai nghe'),
(N'Đồng hồ thông minh'),
(N'Máy ảnh và máy quay'),
(N'Máy in và mực in'),
(N'Đồ gia dụng thông minh');

-- SP_THUONG_HIEU
INSERT INTO SP_THUONG_HIEU (thuonghieuTen) VALUES 
(N'Apple'),
(N'Samsung'),
(N'Xiaomi'),
(N'Oppo'),
(N'Vivo'),
(N'Realme'),
(N'Nokia'),
(N'ASUS'),
(N'Dell'),
(N'HP'),
(N'Lenovo'),
(N'Acer'),
(N'Sony'),
(N'LG'),
(N'Panasonic'),
(N'Canon'),
(N'Epson'),
(N'JBL'),
(N'Anker'),
(N'Huawei');

-- TAI_KHOAN
INSERT INTO TAI_KHOAN (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai)
VALUES 
(N'admin', N'admin123', 1, N'Quản trị viên', '0909999999', N'admin@shop.com', 1),
(N'user', N'123456', 0, N'Nguyễn Văn A', '0908888888', N'testuser@email.com', 1),
(N'user3', N'123456', 0, N'Nguyễn Văn C', '0900000003', N'user3@example.com', 0),
(N'user4', N'123456', 0, N'Trần Thị D', '0900000004', N'user4@example.com', 0),
(N'user5', N'123456', 0, N'Lê Văn E', '0900000005', N'user5@example.com', 1),
(N'user6', N'123456', 0, N'Phạm Thị F', '0900000006', N'user6@example.com', 1),
(N'user7', N'123456', 0, N'Hồ Văn G', '0900000007', N'user7@example.com', 1),
(N'user8', N'123456', 0, N'Đặng Thị H', '0900000008', N'user8@example.com', 1),
(N'user9', N'123456', 0, N'Bùi Văn I', '0900000009', N'user9@example.com', 1),
(N'user10', N'123456', 0, N'Vũ Thị J', '0900000010', N'user10@example.com', 1);

-- DATN_CRE_SP_DB00001_3
CREATE PROCEDURE WBH_AD_SEL_getTAIKHOAN
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM TAI_KHOAN
    ORDER BY ngaytao DESC;
END;
