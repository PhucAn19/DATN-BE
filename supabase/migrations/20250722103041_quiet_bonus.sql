-- =====================================================
-- STORED PROCEDURES CHO HỆ THỐNG DATN
-- Tạo các procedure độc lập không phụ thuộc API
-- =====================================================

USE DATN_WebBHDT;
GO

-- =====================================================
-- 1. QUẢN LÝ TÀI KHOẢN
-- =====================================================

-- Đăng nhập
CREATE OR ALTER PROCEDURE sp_DangNhap
    @TenDangNhap NVARCHAR(255),
    @MatKhau NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id_tk,
        tendangnhap,
        vaitro,
        hoveten,
        email,
        sodienthoai,
        trangthai,
        CASE 
            WHEN tendangnhap = @TenDangNhap AND matkhau = @MatKhau AND trangthai = 1 
            THEN N'Đăng nhập thành công'
            WHEN tendangnhap = @TenDangNhap AND matkhau != @MatKhau 
            THEN N'Mật khẩu không đúng'
            WHEN tendangnhap = @TenDangNhap AND trangthai = 0 
            THEN N'Tài khoản đã bị khóa'
            ELSE N'Tài khoản không tồn tại'
        END AS KetQua
    FROM TAI_KHOAN 
    WHERE (tendangnhap = @TenDangNhap OR email = @TenDangNhap OR sodienthoai = @TenDangNhap)
        AND matkhau = @MatKhau 
        AND trangthai = 1;
END;
GO

-- Đăng ký tài khoản
CREATE OR ALTER PROCEDURE sp_DangKy
    @TenDangNhap NVARCHAR(255),
    @MatKhau NVARCHAR(255),
    @HoVaTen NVARCHAR(255),
    @Email NVARCHAR(255),
    @SoDienThoai VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra trùng lặp
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE tendangnhap = @TenDangNhap)
    BEGIN
        SELECT N'Tên đăng nhập đã tồn tại' AS KetQua;
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = @Email)
    BEGIN
        SELECT N'Email đã tồn tại' AS KetQua;
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE sodienthoai = @SoDienThoai)
    BEGIN
        SELECT N'Số điện thoại đã tồn tại' AS KetQua;
        RETURN;
    END
    
    -- Thêm tài khoản mới
    INSERT INTO TAI_KHOAN (tendangnhap, matkhau, hoveten, email, sodienthoai, vaitro, trangthai)
    VALUES (@TenDangNhap, @MatKhau, @HoVaTen, @Email, @SoDienThoai, 0, 1);
    
    SELECT N'Đăng ký thành công' AS KetQua, SCOPE_IDENTITY() AS id_tk;
END;
GO

-- Cập nhật thông tin tài khoản
CREATE OR ALTER PROCEDURE sp_CapNhatTaiKhoan
    @IdTK INT,
    @HoVaTen NVARCHAR(255),
    @Email NVARCHAR(255),
    @SoDienThoai VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra email trùng (trừ chính nó)
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE email = @Email AND id_tk != @IdTK)
    BEGIN
        SELECT N'Email đã tồn tại' AS KetQua;
        RETURN;
    END
    
    -- Kiểm tra SĐT trùng (trừ chính nó)
    IF EXISTS (SELECT 1 FROM TAI_KHOAN WHERE sodienthoai = @SoDienThoai AND id_tk != @IdTK)
    BEGIN
        SELECT N'Số điện thoại đã tồn tại' AS KetQua;
        RETURN;
    END
    
    UPDATE TAI_KHOAN 
    SET hoveten = @HoVaTen,
        email = @Email,
        sodienthoai = @SoDienThoai
    WHERE id_tk = @IdTK;
    
    SELECT N'Cập nhật thành công' AS KetQua;
END;
GO

-- Đổi mật khẩu
CREATE OR ALTER PROCEDURE sp_DoiMatKhau
    @IdTK INT,
    @MatKhauCu NVARCHAR(255),
    @MatKhauMoi NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra mật khẩu cũ
    IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE id_tk = @IdTK AND matkhau = @MatKhauCu)
    BEGIN
        SELECT N'Mật khẩu cũ không đúng' AS KetQua;
        RETURN;
    END
    
    UPDATE TAI_KHOAN 
    SET matkhau = @MatKhauMoi
    WHERE id_tk = @IdTK;
    
    SELECT N'Đổi mật khẩu thành công' AS KetQua;
END;
GO

-- =====================================================
-- 2. QUẢN LỸ SẢN PHẨM
-- =====================================================

-- Lấy danh sách sản phẩm có phân trang
CREATE OR ALTER PROCEDURE sp_LayDanhSachSanPham
    @PageNo INT = 1,
    @PageSize INT = 10,
    @TimKiem NVARCHAR(255) = NULL,
    @LoaiSP INT = NULL,
    @ThuongHieu INT = NULL,
    @GiaMin BIGINT = NULL,
    @GiaMax BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;
    
    SELECT 
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        sp.ngaytao,
        l.loaiTen,
        th.thuonghieuTen,
        ts.ram,
        ts.storage,
        ts.mausac,
        ts.soluong,
        -- Tính điểm đánh giá trung bình
        ISNULL(AVG(CAST(dg.diemso AS FLOAT)), 0) AS DiemTB,
        COUNT(dg.id_dg) AS SoLuotDanhGia,
        -- Đếm lượt yêu thích
        (SELECT COUNT(*) FROM YEU_THICH WHERE sanpham = sp.id_sp AND trangthai = 'Y') AS SoLuotYeuThich
    FROM SAN_PHAM sp
    LEFT JOIN SP_LOAI l ON sp.loai = l.id_l
    LEFT JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id_th
    LEFT JOIN SP_THONG_SO ts ON sp.id_sp = ts.sanpham
    LEFT JOIN DANH_GIA dg ON sp.id_sp = dg.sanpham
    WHERE 
        (@TimKiem IS NULL OR sp.tensanpham LIKE '%' + @TimKiem + '%')
        AND (@LoaiSP IS NULL OR sp.loai = @LoaiSP)
        AND (@ThuongHieu IS NULL OR sp.thuonghieu = @ThuongHieu)
        AND (@GiaMin IS NULL OR sp.dongia >= @GiaMin)
        AND (@GiaMax IS NULL OR sp.dongia <= @GiaMax)
    GROUP BY 
        sp.id_sp, sp.tensanpham, sp.dongia, sp.anhgoc, sp.ngaytao,
        l.loaiTen, th.thuonghieuTen, ts.ram, ts.storage, ts.mausac, ts.soluong
    ORDER BY sp.ngaytao DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Trả về tổng số bản ghi
    SELECT COUNT(*) AS TongSoBanGhi
    FROM SAN_PHAM sp
    WHERE 
        (@TimKiem IS NULL OR sp.tensanpham LIKE '%' + @TimKiem + '%')
        AND (@LoaiSP IS NULL OR sp.loai = @LoaiSP)
        AND (@ThuongHieu IS NULL OR sp.thuonghieu = @ThuongHieu)
        AND (@GiaMin IS NULL OR sp.dongia >= @GiaMin)
        AND (@GiaMax IS NULL OR sp.dongia <= @GiaMax);
END;
GO

-- Lấy chi tiết sản phẩm
CREATE OR ALTER PROCEDURE sp_LayChiTietSanPham
    @IdSP INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin sản phẩm chính
    SELECT 
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        sp.ngaytao,
        l.loaiTen,
        th.thuonghieuTen,
        ts.*,
        -- Điểm đánh giá trung bình
        ISNULL(AVG(CAST(dg.diemso AS FLOAT)), 0) AS DiemTB,
        COUNT(dg.id_dg) AS SoLuotDanhGia,
        -- Lượt yêu thích
        (SELECT COUNT(*) FROM YEU_THICH WHERE sanpham = sp.id_sp AND trangthai = 'Y') AS SoLuotYeuThich
    FROM SAN_PHAM sp
    LEFT JOIN SP_LOAI l ON sp.loai = l.id_l
    LEFT JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id_th
    LEFT JOIN SP_THONG_SO ts ON sp.id_sp = ts.sanpham
    LEFT JOIN DANH_GIA dg ON sp.id_sp = dg.sanpham
    WHERE sp.id_sp = @IdSP
    GROUP BY 
        sp.id_sp, sp.tensanpham, sp.dongia, sp.anhgoc, sp.ngaytao,
        l.loaiTen, th.thuonghieuTen, ts.id_ts, ts.sanpham, ts.cpuBrand, ts.cpuModel, 
        ts.cpuType, ts.cpuMinSpeed, ts.cpuMaxSpeed, ts.cpuCores, ts.cpuThreads, 
        ts.cpuCache, ts.gpuBrand, ts.gpuModel, ts.gpuFullName, ts.gpuMemory, 
        ts.ram, ts.storage, ts.screen, ts.mausac, ts.soluong;
    
    -- Ảnh phụ
    SELECT * FROM ANH_SP WHERE sanpham = @IdSP;
    
    -- Đánh giá
    SELECT 
        dg.id_dg,
        dg.noidung,
        dg.diemso,
        tk.hoveten,
        dg.taikhoan
    FROM DANH_GIA dg
    LEFT JOIN TAI_KHOAN tk ON dg.taikhoan = tk.id_tk
    WHERE dg.sanpham = @IdSP
    ORDER BY dg.id_dg DESC;
END;
GO

-- Sản phẩm nổi bật (bán chạy)
CREATE OR ALTER PROCEDURE sp_SanPhamNoiBat
    @Top INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Top)
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        ISNULL(SUM(hdct.soluong), 0) AS TongSoLuongBan,
        ISNULL(SUM(hdct.soluong * hdct.dongia), 0) AS TongDoanhThu
    FROM SAN_PHAM sp
    LEFT JOIN HD_CHI_TIET hdct ON sp.id_sp = hdct.sanpham
    LEFT JOIN HOA_DON hd ON hdct.hoadon = hd.id_hd
    WHERE hd.trangthai IN ('PAID', 'DELIVERED') OR hd.trangthai IS NULL
    GROUP BY sp.id_sp, sp.tensanpham, sp.dongia, sp.anhgoc
    ORDER BY TongSoLuongBan DESC, TongDoanhThu DESC;
END;
GO

-- Sản phẩm mới nhất
CREATE OR ALTER PROCEDURE sp_SanPhamMoiNhat
    @Top INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Top)
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        sp.ngaytao,
        l.loaiTen,
        th.thuonghieuTen
    FROM SAN_PHAM sp
    LEFT JOIN SP_LOAI l ON sp.loai = l.id_l
    LEFT JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id_th
    ORDER BY sp.ngaytao DESC;
END;
GO

-- =====================================================
-- 3. QUẢN LÝ GIỎ HÀNG
-- =====================================================

-- Thêm vào giỏ hàng
CREATE OR ALTER PROCEDURE sp_ThemVaoGioHang
    @IdTK INT,
    @IdSP INT,
    @SoLuong INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra sản phẩm có tồn tại và còn hàng không
    DECLARE @SoLuongTon INT;
    SELECT @SoLuongTon = ts.soluong 
    FROM SP_THONG_SO ts 
    WHERE ts.sanpham = @IdSP;
    
    IF @SoLuongTon IS NULL
    BEGIN
        SELECT N'Sản phẩm không tồn tại' AS KetQua;
        RETURN;
    END
    
    IF @SoLuongTon < @SoLuong
    BEGIN
        SELECT N'Số lượng không đủ' AS KetQua, @SoLuongTon AS SoLuongTon;
        RETURN;
    END
    
    -- Kiểm tra đã có trong giỏ hàng chưa
    IF EXISTS (SELECT 1 FROM GIO_HANG WHERE taikhoan = @IdTK AND sanpham = @IdSP)
    BEGIN
        SELECT N'Sản phẩm đã có trong giỏ hàng' AS KetQua;
        RETURN;
    END
    
    -- Thêm vào giỏ hàng
    INSERT INTO GIO_HANG (taikhoan, sanpham)
    VALUES (@IdTK, @IdSP);
    
    SELECT N'Thêm vào giỏ hàng thành công' AS KetQua;
END;
GO

-- Xem giỏ hàng
CREATE OR ALTER PROCEDURE sp_XemGioHang
    @IdTK INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        gh.id_gh,
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        ts.mausac,
        ts.soluong AS SoLuongTon,
        l.loaiTen,
        th.thuonghieuTen
    FROM GIO_HANG gh
    INNER JOIN SAN_PHAM sp ON gh.sanpham = sp.id_sp
    LEFT JOIN SP_THONG_SO ts ON sp.id_sp = ts.sanpham
    LEFT JOIN SP_LOAI l ON sp.loai = l.id_l
    LEFT JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id_th
    WHERE gh.taikhoan = @IdTK
    ORDER BY gh.id_gh DESC;
END;
GO

-- Xóa khỏi giỏ hàng
CREATE OR ALTER PROCEDURE sp_XoaKhoiGioHang
    @IdTK INT,
    @IdSP INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM GIO_HANG 
    WHERE taikhoan = @IdTK AND sanpham = @IdSP;
    
    IF @@ROWCOUNT > 0
        SELECT N'Xóa thành công' AS KetQua;
    ELSE
        SELECT N'Không tìm thấy sản phẩm trong giỏ hàng' AS KetQua;
END;
GO

-- Xóa tất cả giỏ hàng
CREATE OR ALTER PROCEDURE sp_XoaTatCaGioHang
    @IdTK INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM GIO_HANG WHERE taikhoan = @IdTK;
    
    SELECT N'Xóa tất cả thành công' AS KetQua, @@ROWCOUNT AS SoLuongXoa;
END;
GO

-- =====================================================
-- 4. QUẢN LÝ THANH TOÁN & HÓA ĐƠN
-- =====================================================

-- Tạo hóa đơn
CREATE OR ALTER PROCEDURE sp_TaoHoaDon
    @IdTK INT,
    @DiaChiGiaoHang NVARCHAR(255),
    @GhiChu NVARCHAR(255) = NULL,
    @PhuongThucThanhToan NVARCHAR(50) = 'COD',
    @DanhSachSanPham NVARCHAR(MAX) -- JSON: [{"sanPhamId":1,"soLuong":2,"donGia":1000000}]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @TongTien BIGINT = 0;
        DECLARE @IdHD INT;
        
        -- Tạo hóa đơn
        INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung, diachi_giaohang)
        VALUES (@IdTK, 0, 'PENDING', @GhiChu, @DiaChiGiaoHang);
        
        SET @IdHD = SCOPE_IDENTITY();
        
        -- Parse JSON và thêm chi tiết hóa đơn
        DECLARE @SanPhamId INT, @SoLuong INT, @DonGia BIGINT;
        DECLARE @JSON NVARCHAR(MAX) = @DanhSachSanPham;
        
        -- Tạm thời sử dụng bảng tạm để parse JSON (cần SQL Server 2016+)
        IF OBJECT_ID('tempdb..#TempSanPham') IS NOT NULL DROP TABLE #TempSanPham;
        
        CREATE TABLE #TempSanPham (
            sanPhamId INT,
            soLuong INT,
            donGia BIGINT
        );
        
        -- Insert dữ liệu từ JSON (cần customize theo format JSON thực tế)
        INSERT INTO #TempSanPham (sanPhamId, soLuong, donGia)
        SELECT 
            JSON_VALUE(value, '$.sanPhamId'),
            JSON_VALUE(value, '$.soLuong'),
            JSON_VALUE(value, '$.donGia')
        FROM OPENJSON(@JSON);
        
        -- Thêm chi tiết hóa đơn và tính tổng tiền
        INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
        SELECT @IdHD, sanPhamId, donGia, soLuong
        FROM #TempSanPham;
        
        SELECT @TongTien = SUM(donGia * soLuong) FROM #TempSanPham;
        
        -- Cập nhật tổng tiền hóa đơn
        UPDATE HOA_DON SET giahoadon = @TongTien WHERE id_hd = @IdHD;
        
        -- Tạo bản ghi thanh toán
        INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, taikhoan, trangthai, magiaodich)
        VALUES (@IdHD, @PhuongThucThanhToan, @TongTien, @IdTK, 'PENDING', 
                CASE WHEN @PhuongThucThanhToan = 'COD' 
                     THEN 'COD_' + CAST(@IdHD AS VARCHAR(10)) + '_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
                     ELSE 'ORDER_' + CAST(@IdHD AS VARCHAR(10)) + '_' + CAST(DATEDIFF(SECOND, '1970-01-01', GETDATE()) AS VARCHAR(20))
                END);
        
        -- Xóa giỏ hàng sau khi đặt hàng thành công
        DELETE FROM GIO_HANG WHERE taikhoan = @IdTK;
        
        COMMIT TRANSACTION;
        
        SELECT 
            N'Tạo hóa đơn thành công' AS KetQua,
            @IdHD AS HoaDonId,
            @TongTien AS TongTien,
            @PhuongThucThanhToan AS PhuongThucThanhToan;
            
        DROP TABLE #TempSanPham;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SELECT 
            N'Lỗi tạo hóa đơn: ' + ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Lịch sử đơn hàng
CREATE OR ALTER PROCEDURE sp_LichSuDonHang
    @IdTK INT,
    @PageNo INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;
    
    SELECT 
        hd.id_hd,
        hd.ngaytao,
        hd.giahoadon,
        hd.trangthai,
        hd.noidung,
        hd.diachi_giaohang,
        tt.phuongthuc,
        tt.trangthai AS TrangThaiThanhToan,
        COUNT(hdct.id_hdct) AS SoLuongSanPham
    FROM HOA_DON hd
    LEFT JOIN THANH_TOAN tt ON hd.id_hd = tt.hoadon
    LEFT JOIN HD_CHI_TIET hdct ON hd.id_hd = hdct.hoadon
    WHERE hd.taikhoan = @IdTK
    GROUP BY hd.id_hd, hd.ngaytao, hd.giahoadon, hd.trangthai, hd.noidung, 
             hd.diachi_giaohang, tt.phuongthuc, tt.trangthai
    ORDER BY hd.ngaytao DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- Chi tiết hóa đơn
CREATE OR ALTER PROCEDURE sp_ChiTietHoaDon
    @IdHD INT,
    @IdTK INT = NULL -- Để kiểm tra quyền truy cập
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra quyền truy cập
    IF @IdTK IS NOT NULL AND NOT EXISTS (SELECT 1 FROM HOA_DON WHERE id_hd = @IdHD AND taikhoan = @IdTK)
    BEGIN
        SELECT N'Không có quyền truy cập' AS KetQua;
        RETURN;
    END
    
    -- Thông tin hóa đơn
    SELECT 
        hd.*,
        tk.hovaten,
        tk.sodienthoai,
        tk.email,
        tt.phuongthuc,
        tt.trangthai AS TrangThaiThanhToan,
        tt.ngaythanhtoan,
        tt.magiaodich
    FROM HOA_DON hd
    LEFT JOIN TAI_KHOAN tk ON hd.taikhoan = tk.id_tk
    LEFT JOIN THANH_TOAN tt ON hd.id_hd = tt.hoadon
    WHERE hd.id_hd = @IdHD;
    
    -- Chi tiết sản phẩm
    SELECT 
        hdct.*,
        sp.tensanpham,
        sp.anhgoc,
        ts.mausac
    FROM HD_CHI_TIET hdct
    INNER JOIN SAN_PHAM sp ON hdct.sanpham = sp.id_sp
    LEFT JOIN SP_THONG_SO ts ON sp.id_sp = ts.sanpham
    WHERE hdct.hoadon = @IdHD;
END;
GO

-- =====================================================
-- 5. QUẢN LÝ ĐÁNH GIÁ
-- =====================================================

-- Thêm đánh giá
CREATE OR ALTER PROCEDURE sp_ThemDanhGia
    @IdTK INT,
    @IdSP INT,
    @NoiDung NVARCHAR(255),
    @DiemSo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra đã mua sản phẩm chưa
    IF NOT EXISTS (
        SELECT 1 FROM HD_CHI_TIET hdct
        INNER JOIN HOA_DON hd ON hdct.hoadon = hd.id_hd
        WHERE hd.taikhoan = @IdTK AND hdct.sanpham = @IdSP AND hd.trangthai = 'DELIVERED'
    )
    BEGIN
        SELECT N'Bạn chỉ có thể đánh giá sản phẩm đã mua' AS KetQua;
        RETURN;
    END
    
    -- Kiểm tra đã đánh giá chưa
    IF EXISTS (SELECT 1 FROM DANH_GIA WHERE taikhoan = @IdTK AND sanpham = @IdSP)
    BEGIN
        SELECT N'Bạn đã đánh giá sản phẩm này rồi' AS KetQua;
        RETURN;
    END
    
    INSERT INTO DANH_GIA (taikhoan, sanpham, noidung, diemso)
    VALUES (@IdTK, @IdSP, @NoiDung, @DiemSo);
    
    SELECT N'Thêm đánh giá thành công' AS KetQua, SCOPE_IDENTITY() AS id_dg;
END;
GO

-- Lấy đánh giá theo sản phẩm
CREATE OR ALTER PROCEDURE sp_LayDanhGiaTheoSanPham
    @IdSP INT,
    @PageNo INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;
    
    SELECT 
        dg.id_dg,
        dg.noidung,
        dg.diemso,
        tk.hovaten,
        dg.taikhoan
    FROM DANH_GIA dg
    LEFT JOIN TAI_KHOAN tk ON dg.taikhoan = tk.id_tk
    WHERE dg.sanpham = @IdSP
    ORDER BY dg.id_dg DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Thống kê đánh giá
    SELECT 
        COUNT(*) AS TongSoDanhGia,
        AVG(CAST(diemso AS FLOAT)) AS DiemTrungBinh,
        SUM(CASE WHEN diemso = 5 THEN 1 ELSE 0 END) AS Diem5Sao,
        SUM(CASE WHEN diemso = 4 THEN 1 ELSE 0 END) AS Diem4Sao,
        SUM(CASE WHEN diemso = 3 THEN 1 ELSE 0 END) AS Diem3Sao,
        SUM(CASE WHEN diemso = 2 THEN 1 ELSE 0 END) AS Diem2Sao,
        SUM(CASE WHEN diemso = 1 THEN 1 ELSE 0 END) AS Diem1Sao
    FROM DANH_GIA 
    WHERE sanpham = @IdSP;
END;
GO

-- =====================================================
-- 6. QUẢN LÝ YÊU THÍCH
-- =====================================================

-- Toggle yêu thích
CREATE OR ALTER PROCEDURE sp_ToggleYeuThich
    @IdTK INT,
    @IdSP INT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM YEU_THICH WHERE taikhoan = @IdTK AND sanpham = @IdSP)
    BEGIN
        -- Đã có thì toggle trạng thái
        UPDATE YEU_THICH 
        SET trangthai = CASE WHEN trangthai = 'Y' THEN 'N' ELSE 'Y' END
        WHERE taikhoan = @IdTK AND sanpham = @IdSP;
        
        SELECT 
            CASE WHEN trangthai = 'Y' THEN N'Đã thêm vào yêu thích' ELSE N'Đã bỏ yêu thích' END AS KetQua,
            trangthai
        FROM YEU_THICH 
        WHERE taikhoan = @IdTK AND sanpham = @IdSP;
    END
    ELSE
    BEGIN
        -- Chưa có thì thêm mới
        INSERT INTO YEU_THICH (taikhoan, sanpham, trangthai)
        VALUES (@IdTK, @IdSP, 'Y');
        
        SELECT N'Đã thêm vào yêu thích' AS KetQua, 'Y' AS trangthai;
    END
END;
GO

-- Danh sách yêu thích
CREATE OR ALTER PROCEDURE sp_DanhSachYeuThich
    @IdTK INT,
    @PageNo INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;
    
    SELECT 
        yt.id_yt,
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        l.loaiTen,
        th.thuonghieuTen,
        ts.mausac,
        yt.trangthai
    FROM YEU_THICH yt
    INNER JOIN SAN_PHAM sp ON yt.sanpham = sp.id_sp
    LEFT JOIN SP_LOAI l ON sp.loai = l.id_l
    LEFT JOIN SP_THUONG_HIEU th ON sp.thuonghieu = th.id_th
    LEFT JOIN SP_THONG_SO ts ON sp.id_sp = ts.sanpham
    WHERE yt.taikhoan = @IdTK AND yt.trangthai = 'Y'
    ORDER BY yt.id_yt DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- =====================================================
-- 7. QUẢN LÝ GÓP Ý
-- =====================================================

-- Thêm góp ý
CREATE OR ALTER PROCEDURE sp_ThemGopY
    @IdTK INT,
    @NoiDung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO GOP_Y (taikhoan, noidung)
    VALUES (@IdTK, @NoiDung);
    
    SELECT N'Gửi góp ý thành công' AS KetQua, SCOPE_IDENTITY() AS id_gy;
END;
GO

-- Lấy danh sách góp ý (Admin)
CREATE OR ALTER PROCEDURE sp_LayDanhSachGopY
    @PageNo INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNo - 1) * @PageSize;
    
    SELECT 
        gy.id_gy,
        gy.noidung,
        gy.ngaytao,
        tk.hovaten,
        tk.email,
        tk.sodienthoai
    FROM GOP_Y gy
    LEFT JOIN TAI_KHOAN tk ON gy.taikhoan = tk.id_tk
    ORDER BY gy.ngaytao DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Tổng số góp ý
    SELECT COUNT(*) AS TongSoGopY FROM GOP_Y;
END;
GO

-- =====================================================
-- 8. BÁO CÁO THỐNG KÊ
-- =====================================================

-- Thống kê tổng quan
CREATE OR ALTER PROCEDURE sp_ThongKeTongQuan
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        (SELECT COUNT(*) FROM TAI_KHOAN WHERE vaitro = 0) AS TongKhachHang,
        (SELECT COUNT(*) FROM SAN_PHAM) AS TongSanPham,
        (SELECT COUNT(*) FROM HOA_DON WHERE trangthai = 'PAID') AS TongDonHang,
        (SELECT ISNULL(SUM(giahoadon), 0) FROM HOA_DON WHERE trangthai = 'PAID') AS TongDoanhThu,
        (SELECT COUNT(*) FROM DANH_GIA) AS TongDanhGia,
        (SELECT COUNT(*) FROM GOP_Y) AS TongGopY;
END;
GO

-- Thống kê doanh thu theo tháng
CREATE OR ALTER PROCEDURE sp_ThongKeDoanhThuTheoThang
    @Nam INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Nam IS NULL SET @Nam = YEAR(GETDATE());
    
    SELECT 
        MONTH(ngaytao) AS Thang,
        COUNT(*) AS SoDonHang,
        SUM(giahoadon) AS DoanhThu
    FROM HOA_DON 
    WHERE YEAR(ngaytao) = @Nam AND trangthai = 'PAID'
    GROUP BY MONTH(ngaytao)
    ORDER BY Thang;
END;
GO

-- Top sản phẩm bán chạy
CREATE OR ALTER PROCEDURE sp_TopSanPhamBanChay
    @Top INT = 10,
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @TuNgay IS NULL SET @TuNgay = DATEADD(MONTH, -1, GETDATE());
    IF @DenNgay IS NULL SET @DenNgay = GETDATE();
    
    SELECT TOP (@Top)
        sp.id_sp,
        sp.tensanpham,
        sp.dongia,
        sp.anhgoc,
        SUM(hdct.soluong) AS TongSoLuongBan,
        SUM(hdct.soluong * hdct.dongia) AS TongDoanhThu,
        COUNT(DISTINCT hdct.hoadon) AS SoDonHang
    FROM SAN_PHAM sp
    INNER JOIN HD_CHI_TIET hdct ON sp.id_sp = hdct.sanpham
    INNER JOIN HOA_DON hd ON hdct.hoadon = hd.id_hd
    WHERE hd.ngaytao BETWEEN @TuNgay AND @DenNgay 
        AND hd.trangthai = 'PAID'
    GROUP BY sp.id_sp, sp.tensanpham, sp.dongia, sp.anhgoc
    ORDER BY TongSoLuongBan DESC;
END;
GO

PRINT N'✅ Đã tạo thành công tất cả stored procedures!';
PRINT N'📋 Danh sách procedures đã tạo:';
PRINT N'   1. Quản lý tài khoản: sp_DangNhap, sp_DangKy, sp_CapNhatTaiKhoan, sp_DoiMatKhau';
PRINT N'   2. Quản lý sản phẩm: sp_LayDanhSachSanPham, sp_LayChiTietSanPham, sp_SanPhamNoiBat, sp_SanPhamMoiNhat';
PRINT N'   3. Quản lý giỏ hàng: sp_ThemVaoGioHang, sp_XemGioHang, sp_XoaKhoiGioHang, sp_XoaTatCaGioHang';
PRINT N'   4. Quản lý thanh toán: sp_TaoHoaDon, sp_LichSuDonHang, sp_ChiTietHoaDon';
PRINT N'   5. Quản lý đánh giá: sp_ThemDanhGia, sp_LayDanhGiaTheoSanPham';
PRINT N'   6. Quản lý yêu thích: sp_ToggleYeuThich, sp_DanhSachYeuThich';
PRINT N'   7. Quản lý góp ý: sp_ThemGopY, sp_LayDanhSachGopY';
PRINT N'   8. Báo cáo thống kê: sp_ThongKeTongQuan, sp_ThongKeDoanhThuTheoThang, sp_TopSanPhamBanChay';