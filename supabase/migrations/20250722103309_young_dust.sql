-- =====================================================
-- DỮ LIỆU MẪU ĐỂ TEST CÁC STORED PROCEDURES
-- =====================================================

USE DATN_WebBHDT;
GO

-- Thêm dữ liệu mẫu cho SP_LOAI (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM SP_LOAI WHERE id_l = 1)
BEGIN
    INSERT INTO SP_LOAI (loaiTen) VALUES 
    (N'Điện thoại di động'),
    (N'Laptop'),
    (N'Máy tính bảng'),
    (N'Phụ kiện');
END

-- Thêm dữ liệu mẫu cho SP_THUONG_HIEU (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM SP_THUONG_HIEU WHERE id_th = 1)
BEGIN
    INSERT INTO SP_THUONG_HIEU (thuonghieuTen) VALUES 
    (N'Apple'),
    (N'Samsung'),
    (N'Xiaomi'),
    (N'ASUS');
END

-- Thêm sản phẩm mẫu
IF NOT EXISTS (SELECT 1 FROM SAN_PHAM WHERE id_sp = 1)
BEGIN
    -- Sản phẩm 1: iPhone 14 Pro
    INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc)
    VALUES (N'iPhone 14 Pro 128GB', 25990000, 1, 1, 'iphone14pro.jpg');
    
    DECLARE @SP1_ID INT = SCOPE_IDENTITY();
    
    INSERT INTO SP_THONG_SO (sanpham, cpuBrand, cpuModel, cpuType, cpuMinSpeed, cpuMaxSpeed, cpuCores, cpuThreads, cpuCache, gpuBrand, gpuModel, gpuFullName, gpuMemory, ram, storage, screen, mausac, soluong)
    VALUES (@SP1_ID, 'Apple', 'A16 Bionic', 'High-end', '3.46 GHz', '3.46 GHz', '6', '6', '16MB', 'Apple', 'Apple GPU', 'Apple GPU 5-core', '6GB', '6GB', '128GB', '6.1 inch', N'Tím', 50);
    
    INSERT INTO ANH_SP (sanpham, diachianh)
    VALUES (@SP1_ID, 'iphone14pro_detail.jpg');
    
    -- Sản phẩm 2: Samsung Galaxy S23
    INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc)
    VALUES (N'Samsung Galaxy S23 256GB', 18990000, 1, 2, 'galaxys23.jpg');
    
    DECLARE @SP2_ID INT = SCOPE_IDENTITY();
    
    INSERT INTO SP_THONG_SO (sanpham, cpuBrand, cpuModel, cpuType, cpuMinSpeed, cpuMaxSpeed, cpuCores, cpuThreads, cpuCache, gpuBrand, gpuModel, gpuFullName, gpuMemory, ram, storage, screen, mausac, soluong)
    VALUES (@SP2_ID, 'Qualcomm', 'Snapdragon 8 Gen 2', 'High-end', '3.2 GHz', '3.2 GHz', '8', '8', '12MB', 'Adreno', 'Adreno 740', 'Adreno 740', '8GB', '8GB', '256GB', '6.1 inch', N'Đen', 30);
    
    INSERT INTO ANH_SP (sanpham, diachianh)
    VALUES (@SP2_ID, 'galaxys23_detail.jpg');
    
    -- Sản phẩm 3: MacBook Air M2
    INSERT INTO SAN_PHAM (tensanpham, dongia, loai, thuonghieu, anhgoc)
    VALUES (N'MacBook Air M2 13 inch 256GB', 28990000, 2, 1, 'macbookair_m2.jpg');
    
    DECLARE @SP3_ID INT = SCOPE_IDENTITY();
    
    INSERT INTO SP_THONG_SO (sanpham, cpuBrand, cpuModel, cpuType, cpuMinSpeed, cpuMaxSpeed, cpuCores, cpuThreads, cpuCache, gpuBrand, gpuModel, gpuFullName, gpuMemory, ram, storage, screen, mausac, soluong)
    VALUES (@SP3_ID, 'Apple', 'M2', 'High-end', '3.49 GHz', '3.49 GHz', '8', '8', '16MB', 'Apple', 'M2 GPU', 'Apple M2 8-core GPU', '8GB', '8GB', '256GB SSD', '13.6 inch', N'Bạc', 25);
    
    INSERT INTO ANH_SP (sanpham, diachianh)
    VALUES (@SP3_ID, 'macbookair_m2_detail.jpg');
END

-- Thêm tài khoản test (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM TAI_KHOAN WHERE tendangnhap = 'testuser')
BEGIN
    INSERT INTO TAI_KHOAN (tendangnhap, matkhau, vaitro, hoveten, sodienthoai, email, trangthai)
    VALUES 
    ('testuser', '123456', 0, N'Nguyễn Test User', '0901111111', 'testuser@test.com', 1),
    ('customer1', '123456', 0, N'Trần Văn A', '0902222222', 'customer1@test.com', 1),
    ('customer2', '123456', 0, N'Lê Thị B', '0903333333', 'customer2@test.com', 1);
END

-- Thêm một số đánh giá mẫu
IF NOT EXISTS (SELECT 1 FROM DANH_GIA WHERE id_dg = 1)
BEGIN
    INSERT INTO DANH_GIA (taikhoan, sanpham, noidung, diemso)
    VALUES 
    (2, 1, N'Sản phẩm rất tốt, chất lượng cao!', 5),
    (3, 1, N'Giao hàng nhanh, đóng gói cẩn thận', 4),
    (4, 2, N'Màn hình đẹp, pin trâu', 5),
    (2, 3, N'MacBook chạy mượt, thiết kế đẹp', 5);
END

-- Thêm một số yêu thích mẫu
IF NOT EXISTS (SELECT 1 FROM YEU_THICH WHERE id_yt = 1)
BEGIN
    INSERT INTO YEU_THICH (sanpham, taikhoan, trangthai)
    VALUES 
    (1, 2, 'Y'),
    (2, 2, 'Y'),
    (3, 3, 'Y'),
    (1, 4, 'Y');
END

-- Thêm một số góp ý mẫu
IF NOT EXISTS (SELECT 1 FROM GOP_Y WHERE id_gy = 1)
BEGIN
    INSERT INTO GOP_Y (taikhoan, noidung)
    VALUES 
    (2, N'Website rất tốt, mong có thêm nhiều sản phẩm mới!'),
    (3, N'Giao diện đẹp, dễ sử dụng'),
    (4, N'Nên có thêm chương trình khuyến mãi');
END

-- Thêm một số hóa đơn mẫu để test
IF NOT EXISTS (SELECT 1 FROM HOA_DON WHERE id_hd = 1)
BEGIN
    -- Hóa đơn 1
    INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung, diachi_giaohang)
    VALUES (2, 25990000, 'PAID', N'Đơn hàng test', N'123 Nguyễn Văn Linh, Q7, TP.HCM');
    
    DECLARE @HD1_ID INT = SCOPE_IDENTITY();
    
    INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
    VALUES (@HD1_ID, 1, 25990000, 1);
    
    INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, taikhoan, trangthai, magiaodich)
    VALUES (@HD1_ID, 'COD', 25990000, 2, 'SUCCESS', 'COD_' + CAST(@HD1_ID AS VARCHAR(10)));
    
    -- Hóa đơn 2
    INSERT INTO HOA_DON (taikhoan, giahoadon, trangthai, noidung, diachi_giaohang)
    VALUES (3, 47980000, 'DELIVERED', N'Đơn hàng combo', N'456 Lê Văn Việt, Q9, TP.HCM');
    
    DECLARE @HD2_ID INT = SCOPE_IDENTITY();
    
    INSERT INTO HD_CHI_TIET (hoadon, sanpham, dongia, soluong)
    VALUES 
    (@HD2_ID, 2, 18990000, 1),
    (@HD2_ID, 3, 28990000, 1);
    
    INSERT INTO THANH_TOAN (hoadon, phuongthuc, sotien, taikhoan, trangthai, magiaodich)
    VALUES (@HD2_ID, 'MOMO', 47980000, 3, 'SUCCESS', 'MOMO_' + CAST(@HD2_ID AS VARCHAR(10)));
END

PRINT N'✅ Đã thêm dữ liệu mẫu thành công!';
PRINT N'📊 Dữ liệu đã thêm:';
PRINT N'   - 3 sản phẩm mẫu (iPhone, Samsung, MacBook)';
PRINT N'   - 3 tài khoản test';
PRINT N'   - 4 đánh giá mẫu';
PRINT N'   - 4 yêu thích mẫu';
PRINT N'   - 3 góp ý mẫu';
PRINT N'   - 2 hóa đơn mẫu với chi tiết';
PRINT N'';
PRINT N'🔧 Bây giờ bạn có thể test các stored procedures với dữ liệu mẫu này!';

-- Kiểm tra dữ liệu đã thêm
SELECT 'SAN_PHAM' AS Bang, COUNT(*) AS SoLuong FROM SAN_PHAM
UNION ALL
SELECT 'TAI_KHOAN', COUNT(*) FROM TAI_KHOAN WHERE vaitro = 0
UNION ALL
SELECT 'DANH_GIA', COUNT(*) FROM DANH_GIA
UNION ALL
SELECT 'YEU_THICH', COUNT(*) FROM YEU_THICH
UNION ALL
SELECT 'GOP_Y', COUNT(*) FROM GOP_Y
UNION ALL
SELECT 'HOA_DON', COUNT(*) FROM HOA_DON;