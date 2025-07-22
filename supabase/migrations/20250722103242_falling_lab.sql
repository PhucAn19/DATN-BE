-- =====================================================
-- VÍ DỤ SỬ DỤNG CÁC STORED PROCEDURES
-- =====================================================

USE DATN_WebBHDT;
GO

-- =====================================================
-- 1. VÍ DỤ QUẢN LÝ TÀI KHOẢN
-- =====================================================

-- Đăng ký tài khoản mới
EXEC sp_DangKy 
    @TenDangNhap = N'testuser123',
    @MatKhau = N'123456',
    @HoVaTen = N'Nguyễn Văn Test',
    @Email = N'testuser123@email.com',
    @SoDienThoai = '0901234567';

-- Đăng nhập
EXEC sp_DangNhap 
    @TenDangNhap = N'testuser123',
    @MatKhau = N'123456';

-- Cập nhật thông tin tài khoản (giả sử ID = 3)
EXEC sp_CapNhatTaiKhoan 
    @IdTK = 3,
    @HoVaTen = N'Nguyễn Văn Test Updated',
    @Email = N'testuser123_new@email.com',
    @SoDienThoai = '0901234568';

-- Đổi mật khẩu
EXEC sp_DoiMatKhau 
    @IdTK = 3,
    @MatKhauCu = N'123456',
    @MatKhauMoi = N'newpassword123';

-- =====================================================
-- 2. VÍ DỤ QUẢN LÝ SẢN PHẨM
-- =====================================================

-- Lấy danh sách sản phẩm có phân trang
EXEC sp_LayDanhSachSanPham 
    @PageNo = 1,
    @PageSize = 10,
    @TimKiem = N'iPhone',
    @LoaiSP = 1,
    @GiaMin = 1000000,
    @GiaMax = 50000000;

-- Lấy chi tiết sản phẩm
EXEC sp_LayChiTietSanPham @IdSP = 1;

-- Lấy sản phẩm nổi bật
EXEC sp_SanPhamNoiBat @Top = 5;

-- Lấy sản phẩm mới nhất
EXEC sp_SanPhamMoiNhat @Top = 10;

-- =====================================================
-- 3. VÍ DỤ QUẢN LÝ GIỎ HÀNG
-- =====================================================

-- Thêm sản phẩm vào giỏ hàng
EXEC sp_ThemVaoGioHang 
    @IdTK = 2,
    @IdSP = 1,
    @SoLuong = 1;

-- Xem giỏ hàng
EXEC sp_XemGioHang @IdTK = 2;

-- Xóa sản phẩm khỏi giỏ hàng
EXEC sp_XoaKhoiGioHang 
    @IdTK = 2,
    @IdSP = 1;

-- Xóa tất cả giỏ hàng
EXEC sp_XoaTatCaGioHang @IdTK = 2;

-- =====================================================
-- 4. VÍ DỤ QUẢN LÝ THANH TOÁN & HÓA ĐƠN
-- =====================================================

-- Tạo hóa đơn (cần format JSON cho danh sách sản phẩm)
EXEC sp_TaoHoaDon 
    @IdTK = 2,
    @DiaChiGiaoHang = N'123 Đường ABC, Quận 1, TP.HCM',
    @GhiChu = N'Giao hàng giờ hành chính',
    @PhuongThucThanhToan = 'COD',
    @DanhSachSanPham = '[{"sanPhamId":1,"soLuong":2,"donGia":25990000}]';

-- Xem lịch sử đơn hàng
EXEC sp_LichSuDonHang 
    @IdTK = 2,
    @PageNo = 1,
    @PageSize = 10;

-- Xem chi tiết hóa đơn
EXEC sp_ChiTietHoaDon 
    @IdHD = 1,
    @IdTK = 2;

-- =====================================================
-- 5. VÍ DỤ QUẢN LÝ ĐÁNH GIÁ
-- =====================================================

-- Thêm đánh giá sản phẩm
EXEC sp_ThemDanhGia 
    @IdTK = 2,
    @IdSP = 1,
    @NoiDung = N'Sản phẩm rất tốt, giao hàng nhanh!',
    @DiemSo = 5;

-- Lấy đánh giá theo sản phẩm
EXEC sp_LayDanhGiaTheoSanPham 
    @IdSP = 1,
    @PageNo = 1,
    @PageSize = 10;

-- =====================================================
-- 6. VÍ DỤ QUẢN LÝ YÊU THÍCH
-- =====================================================

-- Toggle yêu thích sản phẩm
EXEC sp_ToggleYeuThich 
    @IdTK = 2,
    @IdSP = 1;

-- Xem danh sách yêu thích
EXEC sp_DanhSachYeuThich 
    @IdTK = 2,
    @PageNo = 1,
    @PageSize = 10;

-- =====================================================
-- 7. VÍ DỤ QUẢN LÝ GÓP Ý
-- =====================================================

-- Gửi góp ý
EXEC sp_ThemGopY 
    @IdTK = 2,
    @NoiDung = N'Website rất tốt, mong có thêm nhiều sản phẩm mới!';

-- Xem danh sách góp ý (Admin)
EXEC sp_LayDanhSachGopY 
    @PageNo = 1,
    @PageSize = 10;

-- =====================================================
-- 8. VÍ DỤ BÁO CÁO THỐNG KÊ
-- =====================================================

-- Thống kê tổng quan
EXEC sp_ThongKeTongQuan;

-- Thống kê doanh thu theo tháng
EXEC sp_ThongKeDoanhThuTheoThang @Nam = 2024;

-- Top sản phẩm bán chạy
EXEC sp_TopSanPhamBanChay 
    @Top = 10,
    @TuNgay = '2024-01-01',
    @DenNgay = '2024-12-31';

-- =====================================================
-- VÍ DỤ KIỂM TRA KẾT QUA
-- =====================================================

-- Kiểm tra danh sách procedures đã tạo
SELECT 
    name AS ProcedureName,
    create_date AS NgayTao,
    modify_date AS NgayCapNhat
FROM sys.procedures 
WHERE name LIKE 'sp_%'
ORDER BY create_date DESC;

-- Kiểm tra số lượng bản ghi trong các bảng chính
SELECT 
    'TAI_KHOAN' AS BangTen, COUNT(*) AS SoBanGhi FROM TAI_KHOAN
UNION ALL
SELECT 'SAN_PHAM', COUNT(*) FROM SAN_PHAM
UNION ALL
SELECT 'HOA_DON', COUNT(*) FROM HOA_DON
UNION ALL
SELECT 'DANH_GIA', COUNT(*) FROM DANH_GIA
UNION ALL
SELECT 'YEU_THICH', COUNT(*) FROM YEU_THICH
UNION ALL
SELECT 'GOP_Y', COUNT(*) FROM GOP_Y;

PRINT N'✅ Các ví dụ sử dụng stored procedures đã sẵn sàng!';
PRINT N'💡 Lưu ý: Một số procedures cần dữ liệu mẫu để test đầy đủ.';
PRINT N'📝 Hãy thay đổi các tham số phù hợp với dữ liệu thực tế của bạn.';