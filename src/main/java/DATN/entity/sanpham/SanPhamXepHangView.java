package DATN.entity.sanpham;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "VIEW_SAN_PHAM_XEP_HANG")
public class SanPhamXepHangView {

    @Id
    private Integer id;

    @Column(name = "tensanpham")
    private String tenSanPham;

    @Column(name = "dongia")
    private Long donGia;

    @Column(name = "anhgoc")
    private String anhGoc;

    @Column(name = "so_luot_yeu_thich")
    private Integer soLuotYeuThich;

    @Column(name = "diem_danh_gia_tb")
    private Double diemDanhGiaTB;
}
