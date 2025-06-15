package DATN.entity.sanpham;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "SAN_PHAM")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SAN_PHAM {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "tensanpham", nullable = false)
    private String tenSanPham;

    @Column(name = "dongia", nullable = false)
    private Long donGia;

    @Column(name = "loai", nullable = false)
    private Integer loai;

    @Column(name = "thuonghieu", nullable = false)
    private Integer thuongHieu;

    @Column(name = "anhgoc", nullable = false)
    private String anhGoc;
}
