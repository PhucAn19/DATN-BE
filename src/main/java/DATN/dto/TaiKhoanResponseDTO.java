package DATN.dto;

import lombok.Data;

@Data
public class TaiKhoanResponseDTO {
    private String tenDangNhap;
    private String hoVaTen;
    private String soDienThoai;
    private String email;
    private Boolean vaiTro;
}
