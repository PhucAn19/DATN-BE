package DATN.dto;

import lombok.Data;

@Data
public class RegisterRequestDTO {
    private String tenDangNhap;
    private String matKhau;
    private String hoVaTen;
    private String soDienThoai;
    private String email;
}
