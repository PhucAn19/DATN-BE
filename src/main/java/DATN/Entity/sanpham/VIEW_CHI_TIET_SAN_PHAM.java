package DATN.entity.sanpham;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "VIEW_CHI_TIET_SAN_PHAM")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VIEW_CHI_TIET_SAN_PHAM {
    @Id
    private Integer id;
    private String tensanpham;
    private Long dongia;
    private String thongso;
    private String mausac;
    private Integer soluong;
    private String thuonghieu;
    private String anhgoc;
}
