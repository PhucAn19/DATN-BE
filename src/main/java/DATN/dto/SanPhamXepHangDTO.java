package DATN.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SanPhamXepHangDTO {
    private Integer id;
    private String tenSanPham;
    private Long donGia;
    private String anhGoc;
    private Integer soLuotYeuThich;
    private Double diemDanhGiaTB;
}
