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
    private String ten_loai;
    private String ten_thuonghieu;
    private String anh_goc;
    private String cpu_brand;
    private String cpu_model;
    private String cpu_type;
    private String cpu_min_speed;
    private String cpu_max_speed;
    private String cpu_cores;
    private String cpu_threads;
    private String cpu_cache;
    private String gpu_brand;
    private String gpu_model;
    private String gpu_full_name;
    private String gpu_memory;
    private String ram;
    private String storage;
    private String screen;
    private String mausac;
    private Integer soluong;
}
