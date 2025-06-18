USE master;
GO

-- TẠO DATABASE NẾU CHƯA CÓ
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DATN_WebBHDT')
BEGIN
    CREATE DATABASE DATN_WebBHDT;
END
GO

-- TẠO LOGIN Ở CẤP SERVER NẾU CHƯA CÓ
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = 'DEV_BACKEND')
BEGIN
    CREATE LOGIN DEV_BACKEND 
    WITH PASSWORD = 'DEV', 
         CHECK_POLICY = OFF, 
         CHECK_EXPIRATION = OFF;
END
GO

USE DATN_WebBHDT;
GO

-- TẠO USER TỪ LOGIN CHỈ KHI CHƯA TỒN TẠI ÁNH XẠ
IF NOT EXISTS (
    SELECT * 
    FROM sys.database_principals
    WHERE sid = SUSER_SID('DEV_BACKEND')
)
BEGIN
    CREATE USER DEV_BACKEND FOR LOGIN DEV_BACKEND;
END
GO

-- GÁN ROLE db_owner CHỈ KHI USER 'DEV_BACKEND' TỒN TẠI
IF EXISTS (
    SELECT * FROM sys.database_principals WHERE name = 'DEV_BACKEND'
)
BEGIN
    IF NOT EXISTS (
        SELECT * 
        FROM sys.database_role_members drm
        JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
        JOIN sys.database_principals u ON drm.member_principal_id = u.principal_id
        WHERE r.name = 'db_owner' AND u.name = 'DEV_BACKEND'
    )
    BEGIN
        EXEC sp_addrolemember 'db_owner', 'DEV_BACKEND';
    END
END



/*===== TABLES =====*/

-- TAI_KHOAN
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TAI_KHOAN' AND xtype='U')
CREATE TABLE TAI_KHOAN(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	tendangnhap NVARCHAR(255) NOT NULL UNIQUE,
	matkhau NVARCHAR(255) NOT NULL,
	vaitro BIT DEFAULT 0 NOT NULL,
	hoveten NVARCHAR(255) NOT NULL,
	sodienthoai VARCHAR(15) NOT NULL UNIQUE,
	email NVARCHAR(255) NOT NULL UNIQUE,
	trangthai BIT DEFAULT 0 NOT NULL,
	ngaytao DATETIME NOT NULL
);
GO

-- DIA_CHI
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DIA_CHI' AND xtype='U')
CREATE TABLE DIA_CHI(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	taikhoan INT NOT NULL,
	diachi NVARCHAR(255) NOT NULL
);
GO

-- SAN_PHAM
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SAN_PHAM' AND xtype='U')
CREATE TABLE SAN_PHAM(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	tensanpham NVARCHAR(255) NOT NULL,
	dongia BIGINT DEFAULT 0 CHECK (dongia >= 0) NOT NULL,
	loai INT NOT NULL,
	thuonghieu INT NOT NULL,
	anhgoc NVARCHAR(255) NOT NULL
);
GO

-- SP_LOAI
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SP_LOAI' AND xtype='U')
CREATE TABLE SP_LOAI(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	loai NVARCHAR(255) NOT NULL
);
GO

-- SP_THUONG_HIEU
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SP_THUONG_HIEU' AND xtype='U')
CREATE TABLE SP_THUONG_HIEU(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	thuonghieu NVARCHAR(255) NOT NULL
);
GO

-- SP_THONG_SO
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SP_THONG_SO' AND xtype='U')
CREATE TABLE SP_THONG_SO(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	sanpham INT NOT NULL,
	thongso NVARCHAR(255) NOT NULL,
	mausac NVARCHAR(255) NOT NULL,
	soluong INT DEFAULT 0 CHECK (soluong >= 0) NOT NULL
);
GO

-- ANH_SP
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ANH_SP' AND xtype='U')
CREATE TABLE ANH_SP(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	sanpham INT NOT NULL,
	diachianh NVARCHAR(255) NOT NULL
);
GO

-- HOA_DON
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HOA_DON' AND xtype='U')
CREATE TABLE HOA_DON(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	taikhoan INT NOT NULL,
	ngaytao DATETIME NOT NULL,
	giahoadon BIGINT DEFAULT 0 CHECK (giahoadon >= 0) NOT NULL,
	trangthai NVARCHAR(255) NOT NULL,
	noidung NVARCHAR(255) NOT NULL
);
GO

-- HD_CHI_TIET
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HD_CHI_TIET' AND xtype='U')
CREATE TABLE HD_CHI_TIET(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	hoadon INT NOT NULL,
	sanpham INT NOT NULL,
	dongia BIGINT DEFAULT 0 CHECK (dongia >= 0) NOT NULL,
	soluong INT DEFAULT 0 CHECK (soluong >= 0) NOT NULL
);
GO

-- THANH_TOAN
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='THANH_TOAN' AND xtype='U')
CREATE TABLE THANH_TOAN(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	hoadon INT NOT NULL,
	phuongthuc NVARCHAR(255) NOT NULL,
	sotien BIGINT DEFAULT 0 CHECK (sotien >= 0) NOT NULL,
	ngaythanhtoan DATETIME NOT NULL,
	magiaodich NVARCHAR(255) NOT NULL,
	taikhoan INT NOT NULL,
	ngaytao DATETIME NOT NULL,
	ngaycapnhat DATETIME NOT NULL
);
GO

-- GIO_HANG
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GIO_HANG' AND xtype='U')
CREATE TABLE GIO_HANG(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	sanpham INT NOT NULL,
	taikhoan INT NOT NULL
);
GO

-- GOP_Y
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GOP_Y' AND xtype='U')
CREATE TABLE GOP_Y(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	taikhoan INT NOT NULL,
	noidung NVARCHAR(255) NOT NULL,
	ngaytao DATETIME NOT NULL
);
GO

-- DANH_GIA
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DANH_GIA' AND xtype='U')
CREATE TABLE DANH_GIA(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	taikhoan INT NOT NULL,
	sanpham INT NOT NULL,
	noidung NVARCHAR(255) NOT NULL,
	diemso INT DEFAULT 0 CHECK (diemso >= 0 AND diemso <= 5) NOT NULL
);
GO

-- YEU_THICH
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='YEU_THICH' AND xtype='U')
CREATE TABLE YEU_THICH(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	sanpham INT NOT NULL,
	taikhoan INT NOT NULL
);
GO


/*===== FOREIGN KEY =====*/

-- fk_TAIKHOAN_DIACHI
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_DIACHI'
)
ALTER TABLE DIA_CHI
ADD CONSTRAINT fk_TAIKHOAN_DIACHI
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_TAIKHOAN_HOADON
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_HOADON'
)
ALTER TABLE HOA_DON
ADD CONSTRAINT fk_TAIKHOAN_HOADON
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_TAIKHOAN_GIOHANG
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_GIOHANG'
)
ALTER TABLE GIO_HANG
ADD CONSTRAINT fk_TAIKHOAN_GIOHANG
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_TAIKHOAN_GOPY
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_GOPY'
)
ALTER TABLE GOP_Y
ADD CONSTRAINT fk_TAIKHOAN_GOPY
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_TAIKHOAN_DANHGIA
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_DANHGIA'
)
ALTER TABLE DANH_GIA
ADD CONSTRAINT fk_TAIKHOAN_DANHGIA
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_TAIKHOAN_YEU_THICH
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_TAIKHOAN_YEU_THICH'
)
ALTER TABLE YEU_THICH
ADD CONSTRAINT fk_TAIKHOAN_YEU_THICH
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

-- fk_SANPHAM_LOAI
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_LOAI'
)
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_SANPHAM_LOAI
FOREIGN KEY (loai) REFERENCES SP_LOAI(id);
GO

-- fk_SANPHAM_THUONGHIEU
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_THUONGHIEU'
)
ALTER TABLE SAN_PHAM
ADD CONSTRAINT fk_SANPHAM_THUONGHIEU
FOREIGN KEY (thuonghieu) REFERENCES SP_THUONG_HIEU(id);
GO

-- fk_SANPHAM_THONGSO
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_THONGSO'
)
ALTER TABLE SP_THONG_SO
ADD CONSTRAINT fk_SANPHAM_THONGSO
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id);
GO

-- fk_SANPHAM_ANH
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_ANH'
)
ALTER TABLE ANH_SP
ADD CONSTRAINT fk_SANPHAM_ANH
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id);
GO

-- fk_SANPHAM_HOADONCT
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_HOADONCT'
)
ALTER TABLE HD_CHI_TIET
ADD CONSTRAINT fk_SANPHAM_HOADONCT
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id);
GO

-- fk_SANPHAM_GIOHANG
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_GIOHANG'
)
ALTER TABLE GIO_HANG
ADD CONSTRAINT fk_SANPHAM_GIOHANG
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id);
GO

-- fk_SANPHAM_YEUTHICH
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_SANPHAM_YEUTHICH'
)
ALTER TABLE YEU_THICH
ADD CONSTRAINT fk_SANPHAM_YEUTHICH
FOREIGN KEY (sanpham) REFERENCES SAN_PHAM(id);
GO

-- fk_HOADON_HDCHITIET
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_HOADON_HDCHITIET'
)
ALTER TABLE HD_CHI_TIET
ADD CONSTRAINT fk_HOADON_HDCHITIET
FOREIGN KEY (hoadon) REFERENCES HOA_DON(id);
GO

-- fk_THANHTOAN_HOADON
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_THANHTOAN_HOADON'
)
ALTER TABLE THANH_TOAN
ADD CONSTRAINT fk_THANHTOAN_HOADON
FOREIGN KEY (hoadon) REFERENCES HOA_DON(id);
GO

-- fk_THANHTOAN_TAIKHOAN
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE name = 'fk_THANHTOAN_TAIKHOAN'
)
ALTER TABLE THANH_TOAN
ADD CONSTRAINT fk_THANHTOAN_TAIKHOAN
FOREIGN KEY (taikhoan) REFERENCES TAI_KHOAN(id);
GO

IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'DATN_CRE_SP_DB00001_0') 
    AND type IN (N'P', N'PC') -- P = SQL Stored Procedure, PC = SQL CLR Procedure
)
BEGIN
    EXEC(N'
    CREATE PROCEDURE DATN_CRE_SP_DB00001_0
        @tensanpham NVARCHAR(255),
        @dongia BIGINT,
        @loai INT,
        @thuonghieu INT,
        @anhgoc NVARCHAR(255),
        @thongso NVARCHAR(255),
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

            INSERT INTO SP_THONG_SO (sanpham, thongso, mausac, soluong)
            VALUES (@NewProductID, @thongso, @mausac, @soluong);

            INSERT INTO ANH_SP (sanpham, diachianh)
            VALUES (@NewProductID, @anhphu);

            COMMIT;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            THROW;
        END CATCH
    END
    ');
END;
GO

-- Chèn tài khoản nếu chưa tồn tại (dựa trên email duy nhất)
IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = N'admin@shop.com')
BEGIN
    INSERT INTO TAI_KHOAN (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai, ngaytao)
    VALUES (N'admin', N'admin123', 1, N'Quản trị viên', '0909999999', N'admin@shop.com', 0, GETDATE());
END;

IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = N'testuser@email.com')
BEGIN
    INSERT INTO TAI_KHOAN (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai, ngaytao)
    VALUES (N'user', N'123456', 0, N'Nguyễn Văn A', '0908888888', N'testuser@email.com', 0, GETDATE());
END;
GO

-- Chèn địa chỉ nếu chưa tồn tại (dựa trên tài khoản và địa chỉ)
IF NOT EXISTS (
    SELECT 1 FROM DIA_CHI 
    WHERE taikhoan = 2 AND diachi = N'123 Lê Lợi, Quận 1, TP.HCM'
)
BEGIN
    INSERT INTO DIA_CHI (taikhoan, diachi)
    VALUES (2, N'123 Lê Lợi, Quận 1, TP.HCM');
END;
GO

-- Chèn dữ liệu vào SP_LOAI nếu chưa có
IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Điện thoại di động')
    INSERT INTO SP_LOAI (loai) VALUES (N'Điện thoại di động');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Máy tính bảng')
    INSERT INTO SP_LOAI (loai) VALUES (N'Máy tính bảng');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Laptop')
    INSERT INTO SP_LOAI (loai) VALUES (N'Laptop');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Máy tính để bàn')
    INSERT INTO SP_LOAI (loai) VALUES (N'Máy tính để bàn');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Thiết bị đeo thông minh')
    INSERT INTO SP_LOAI (loai) VALUES (N'Thiết bị đeo thông minh');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Phụ kiện điện thoại')
    INSERT INTO SP_LOAI (loai) VALUES (N'Phụ kiện điện thoại');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Phụ kiện máy tính')
    INSERT INTO SP_LOAI (loai) VALUES (N'Phụ kiện máy tính');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Thiết bị mạng')
    INSERT INTO SP_LOAI (loai) VALUES (N'Thiết bị mạng');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Thiết bị lưu trữ')
    INSERT INTO SP_LOAI (loai) VALUES (N'Thiết bị lưu trữ');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Tivi')
    INSERT INTO SP_LOAI (loai) VALUES (N'Tivi');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Loa và tai nghe')
    INSERT INTO SP_LOAI (loai) VALUES (N'Loa và tai nghe');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Đồng hồ thông minh')
    INSERT INTO SP_LOAI (loai) VALUES (N'Đồng hồ thông minh');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Máy ảnh và máy quay')
    INSERT INTO SP_LOAI (loai) VALUES (N'Máy ảnh và máy quay');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Máy in và mực in')
    INSERT INTO SP_LOAI (loai) VALUES (N'Máy in và mực in');

IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE loai = N'Đồ gia dụng thông minh')
    INSERT INTO SP_LOAI (loai) VALUES (N'Đồ gia dụng thông minh');
GO

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Apple')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Apple');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Samsung')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Samsung');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Xiaomi')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Xiaomi');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Oppo')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Oppo');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Vivo')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Vivo');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Realme')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Realme');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Nokia')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Nokia');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'ASUS')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'ASUS');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Dell')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Dell');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'HP')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'HP');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Lenovo')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Lenovo');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Acer')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Acer');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Sony')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Sony');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'LG')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'LG');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Panasonic')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Panasonic');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Canon')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Canon');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Epson')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Epson');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'JBL')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'JBL');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Anker')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Anker');

IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE thuonghieu = N'Huawei')
    INSERT INTO SP_THUONG_HIEU (thuonghieu) VALUES (N'Huawei');
GO

-- DATN_CRE_SP_DB00001_0
EXEC DATN_CRE_SP_DB00001_0 N'iPhone 14 Pro', 25990000, 1, 1, N'default.png', N'RAM 6GB, ROM 128GB, A16 Bionic', N'Tím', 10, N'detail_iphone14.png';
EXEC DATN_CRE_SP_DB00001_0 N'Samsung Galaxy A25', 6290000, 1, 2, N'default.png', N'RAM 6GB, ROM 128GB, Exynos 1280', N'Xanh dương', 15, N'detail_a25.png';
EXEC DATN_CRE_SP_DB00001_0 N'Xiaomi 13T Pro', 13990000, 1, 3, N'default.png', N'RAM 12GB, ROM 256GB, Dimensity 9200+', N'Đen', 20, N'detail_13tpro.png';
EXEC DATN_CRE_SP_DB00001_0 N'Oppo A78', 5990000, 1, 4, N'default.png', N'RAM 8GB, ROM 128GB, Snapdragon 680', N'Xanh', 18, N'detail_a78.png';
EXEC DATN_CRE_SP_DB00001_0 N'Vivo V25e', 7490000, 1, 5, N'default.png', N'RAM 8GB, ROM 128GB, Helio G99', N'Vàng', 12, N'detail_v25e.png';
EXEC DATN_CRE_SP_DB00001_0 N'Realme Narzo 50A', 3290000, 1, 6, N'default.png', N'RAM 4GB, ROM 64GB, Helio G85', N'Xám', 30, N'detail_narzo.png';
EXEC DATN_CRE_SP_DB00001_0 N'Nokia C31', 2390000, 1, 7, N'default.png', N'RAM 3GB, ROM 32GB, Unisoc 9863A1', N'Xanh lá', 25, N'detail_c31.png';
EXEC DATN_CRE_SP_DB00001_0 N'ASUS ROG Phone 6', 18990000, 1, 8, N'default.png', N'RAM 12GB, ROM 256GB, Snapdragon 8+ Gen 1', N'Đen cam', 8, N'detail_rog6.png';
EXEC DATN_CRE_SP_DB00001_0 N'Dell XPS 13', 31990000, 3, 9, N'default.png', N'RAM 16GB, SSD 512GB, Intel i7 Gen12', N'Bạc', 5, N'detail_xps13.png';
EXEC DATN_CRE_SP_DB00001_0 N'HP Envy x360', 21990000, 3, 10, N'default.png', N'RAM 16GB, SSD 512GB, AMD Ryzen 5 7530U', N'Xám', 7, N'detail_envy.png';
EXEC DATN_CRE_SP_DB00001_0 N'Lenovo Yoga Slim 7', 18990000, 3, 11, N'default.png', N'RAM 16GB, SSD 512GB, Ryzen 7 6800U', N'Tím', 6, N'detail_yoga.png';
EXEC DATN_CRE_SP_DB00001_0 N'Acer Aspire 5', 13990000, 3, 12, N'default.png', N'RAM 8GB, SSD 512GB, Intel i5 Gen11', N'Xám bạc', 10, N'detail_aspire.png';
EXEC DATN_CRE_SP_DB00001_0 N'Sony Xperia 5 V', 24990000, 1, 13, N'default.png', N'RAM 8GB, ROM 128GB, Snapdragon 8 Gen 2', N'Trắng', 9, N'detail_xperia5v.png';
EXEC DATN_CRE_SP_DB00001_0 N'LG Wing 5G', 15990000, 1, 14, N'default.png', N'RAM 8GB, ROM 128GB, Snapdragon 765G', N'Bạc', 4, N'detail_wing.png';
EXEC DATN_CRE_SP_DB00001_0 N'Panasonic Toughpad', 18990000, 2, 15, N'default.png', N'RAM 4GB, ROM 128GB, Intel Atom Z8550', N'Đen', 2, N'detail_toughpad.png';
EXEC DATN_CRE_SP_DB00001_0 N'Canon EOS M50', 15990000, 13, 16, N'default.png', N'Cảm biến CMOS APS-C, 24.1MP', N'Đen', 3, N'detail_m50.png';
EXEC DATN_CRE_SP_DB00001_0 N'Epson L3250', 3990000, 14, 17, N'default.png', N'In màu, Wifi, tốc độ 10ppm', N'Trắng', 6, N'detail_l3250.png';
EXEC DATN_CRE_SP_DB00001_0 N'JBL Flip 6', 2290000, 11, 18, N'default.png', N'Công suất 30W, Bluetooth 5.1', N'Xanh Navy', 13, N'detail_flip6.png';
EXEC DATN_CRE_SP_DB00001_0 N'Anker Soundcore 2', 1490000, 11, 19, N'default.png', N'Bluetooth, chống nước IPX7, 24h chơi nhạc', N'Đen', 11, N'detail_soundcore2.png';
EXEC DATN_CRE_SP_DB00001_0 N'Huawei Watch GT 3', 4990000, 12, 20, N'default.png', N'Màn AMOLED 1.43", pin 14 ngày', N'Vàng hồng', 7, N'detail_gt3.png';
GO


IF NOT EXISTS (
    SELECT * FROM sys.views WHERE name = 'VIEW_CHI_TIET_SAN_PHAM'
)
BEGIN
    EXEC('
    CREATE VIEW VIEW_CHI_TIET_SAN_PHAM AS
    SELECT 
        sp.id AS id,
        sp.tensanpham AS tensanpham,
        sp.dongia AS dongia,
        l.loai AS loai,
        th.thuonghieu AS thuonghieu,
        sp.anhgoc AS anhgoc,
        ts.thongso AS thongso,
        ts.mausac AS mausac,
        ts.soluong AS soluong
    FROM SAN_PHAM sp
    JOIN SP_LOAI l ON sp.loai = l.id
    JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id
    LEFT JOIN SP_THONG_SO ts ON sp.id = ts.sanpham;
    ')
END
GO
