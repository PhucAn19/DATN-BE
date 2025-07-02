package DATN.dto;

import lombok.Data;

@Data
public class SanPhamNoiBatDTO {
    private Integer id;
    private String tenSanPham;
    private String anhGoc;
    private Integer tongSoLuongBan;
    private Double tongDoanhThu;
}