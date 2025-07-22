# 📋 HƯỚNG DẪN SỬ DỤNG STORED PROCEDURES

## 🎯 Tổng quan
Hệ thống đã được tạo ra các stored procedures độc lập, không phụ thuộc vào API. Bạn có thể gọi trực tiếp từ SQL Server Management Studio hoặc từ ứng dụng.

## 📁 Cấu trúc files
```
src/main/resources/sql/
├── procedures.sql      # Tất cả stored procedures
├── examples.sql        # Ví dụ sử dụng
├── test-data.sql       # Dữ liệu mẫu để test
└── README_PROCEDURES.md # File hướng dẫn này
```

## 🚀 Cách sử dụng

### 1. Cài đặt procedures
```sql
-- Chạy file procedures.sql để tạo tất cả stored procedures
USE DATN_WebBHDT;
GO
-- Copy và chạy nội dung file procedures.sql
```

### 2. Thêm dữ liệu mẫu (tùy chọn)
```sql
-- Chạy file test-data.sql để có dữ liệu test
-- Copy và chạy nội dung file test-data.sql
```

### 3. Test các procedures
```sql
-- Chạy các ví dụ trong file examples.sql
-- Copy và chạy từng ví dụ trong file examples.sql
```

## 📚 Danh sách Stored Procedures

### 🔐 1. Quản lý Tài khoản
- `sp_DangNhap` - Đăng nhập
- `sp_DangKy` - Đăng ký tài khoản mới  
- `sp_CapNhatTaiKhoan` - Cập nhật thông tin
- `sp_DoiMatKhau` - Đổi mật khẩu

### 🛍️ 2. Quản lý Sản phẩm
- `sp_LayDanhSachSanPham` - Danh sách sản phẩm có phân trang & filter
- `sp_LayChiTietSanPham` - Chi tiết sản phẩm
- `sp_SanPhamNoiBat` - Sản phẩm bán chạy
- `sp_SanPhamMoiNhat` - Sản phẩm mới nhất

### 🛒 3. Quản lý Giỏ hàng
- `sp_ThemVaoGioHang` - Thêm sản phẩm vào giỏ
- `sp_XemGioHang` - Xem giỏ hàng
- `sp_XoaKhoiGioHang` - Xóa sản phẩm khỏi giỏ
- `sp_XoaTatCaGioHang` - Xóa tất cả giỏ hàng

### 💳 4. Quản lý Thanh toán & Hóa đơn
- `sp_TaoHoaDon` - Tạo hóa đơn mới
- `sp_LichSuDonHang` - Lịch sử đơn hàng
- `sp_ChiTietHoaDon` - Chi tiết hóa đơn

### ⭐ 5. Quản lý Đánh giá
- `sp_ThemDanhGia` - Thêm đánh giá sản phẩm
- `sp_LayDanhGiaTheoSanPham` - Lấy đánh giá theo sản phẩm

### ❤️ 6. Quản lý Yêu thích
- `sp_ToggleYeuThich` - Bật/tắt yêu thích
- `sp_DanhSachYeuThich` - Danh sách yêu thích

### 💬 7. Quản lý Góp ý
- `sp_ThemGopY` - Gửi góp ý
- `sp_LayDanhSachGopY` - Danh sách góp ý (Admin)

### 📊 8. Báo cáo Thống kê
- `sp_ThongKeTongQuan` - Thống kê tổng quan
- `sp_ThongKeDoanhThuTheoThang` - Doanh thu theo tháng
- `sp_TopSanPhamBanChay` - Top sản phẩm bán chạy

## 💡 Ví dụ sử dụng nhanh

### Đăng nhập
```sql
EXEC sp_DangNhap 
    @TenDangNhap = N'testuser',
    @MatKhau = N'123456';
```

### Lấy danh sách sản phẩm
```sql
EXEC sp_LayDanhSachSanPham 
    @PageNo = 1,
    @PageSize = 10,
    @TimKiem = N'iPhone';
```

### Thêm vào giỏ hàng
```sql
EXEC sp_ThemVaoGioHang 
    @IdTK = 2,
    @IdSP = 1,
    @SoLuong = 1;
```

### Tạo hóa đơn
```sql
EXEC sp_TaoHoaDon 
    @IdTK = 2,
    @DiaChiGiaoHang = N'123 ABC, Q1, TP.HCM',
    @PhuongThucThanhToan = 'COD',
    @DanhSachSanPham = '[{"sanPhamId":1,"soLuong":1,"donGia":25990000}]';
```

## ⚠️ Lưu ý quan trọng

### 1. Tham số JSON cho sp_TaoHoaDon
```json
[
  {
    "sanPhamId": 1,
    "soLuong": 2, 
    "donGia": 25990000
  },
  {
    "sanPhamId": 2,
    "soLuong": 1,
    "donGia": 18990000
  }
]
```

### 2. Phân trang
- `@PageNo`: Trang hiện tại (bắt đầu từ 1)
- `@PageSize`: Số bản ghi mỗi trang
- Kết quả trả về có thông tin tổng số bản ghi

### 3. Xử lý lỗi
- Tất cả procedures đều trả về thông báo kết quả
- Kiểm tra field `KetQua` để biết thành công hay thất bại
- Sử dụng TRY-CATCH trong procedures quan trọng

### 4. Bảo mật
- Kiểm tra quyền truy cập trong các procedures nhạy cảm
- Validate dữ liệu đầu vào
- Sử dụng parameterized queries để tránh SQL Injection

## 🔧 Tích hợp với ứng dụng

### Spring Boot JdbcTemplate
```java
@Repository
public class ProductRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public List<Map<String, Object>> getProducts(int pageNo, int pageSize) {
        return jdbcTemplate.queryForList(
            "EXEC sp_LayDanhSachSanPham ?, ?", 
            pageNo, pageSize
        );
    }
}
```

### .NET Core
```csharp
public async Task<List<Product>> GetProductsAsync(int pageNo, int pageSize)
{
    using var connection = new SqlConnection(connectionString);
    var products = await connection.QueryAsync<Product>(
        "sp_LayDanhSachSanPham", 
        new { PageNo = pageNo, PageSize = pageSize },
        commandType: CommandType.StoredProcedure
    );
    return products.ToList();
}
```

## 🎯 Kết luận

Với hệ thống stored procedures này, bạn có thể:
- ✅ Gọi trực tiếp từ database mà không cần API
- ✅ Tích hợp dễ dàng với bất kỳ ngôn ngữ lập trình nào
- ✅ Có hiệu suất cao và bảo mật tốt
- ✅ Dễ dàng bảo trì và mở rộng

Hãy tham khảo file `examples.sql` để xem các ví dụ chi tiết hơn!