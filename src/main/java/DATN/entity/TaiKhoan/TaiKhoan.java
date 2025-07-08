package DATN.entity.TaiKhoan;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "TAI_KHOAN")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class TaiKhoan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_tk;

    @Column(name = "tendangnhap", nullable = false, unique = true)
    private String tenDangNhap;

    @Column(name = "matkhau", nullable = false)
    private String matKhau;

    @Column(name = "vaitro", nullable = false)
    private Boolean vaiTro = false;

    @Column(name = "hoveten", nullable = false)
    private String hoVaTen;

    @Column(name = "sodienthoai", nullable = false, unique = true)
    private String soDienThoai;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "trangthai", nullable = false)
    private Boolean trangThai = true;

    @CreationTimestamp
    @Column(name = "ngaytao", nullable = false, updatable = false)
    private LocalDateTime ngayTao;

}
