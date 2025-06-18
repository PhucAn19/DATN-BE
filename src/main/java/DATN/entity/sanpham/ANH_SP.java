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
@Table(name = "ANH_SP")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ANH_SP {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "sanpham", nullable = false)
    private Integer sanPham;

    @Column(name = "diachianh", nullable = false)
    private String diaChiAnh;
}

