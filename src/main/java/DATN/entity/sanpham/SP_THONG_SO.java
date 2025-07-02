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
@Table(name = "SP_THONG_SO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SP_THONG_SO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "sanpham", nullable = false)
    private Integer sanPham;

    @Column(name = "cpu_brand", nullable = false, length = 255)
    private String cpuBrand;

    @Column(name = "cpu_model", nullable = false, length = 255)
    private String cpuModel;

    @Column(name = "cpu_type", nullable = false, length = 255)
    private String cpuType;

    @Column(name = "cpu_min_speed", nullable = false, length = 255)
    private String cpuMinSpeed;

    @Column(name = "cpu_max_speed", nullable = false, length = 255)
    private String cpuMaxSpeed;

    @Column(name = "cpu_cores", nullable = false, length = 255)
    private String cpuCores;

    @Column(name = "cpu_threads", nullable = false, length = 255)
    private String cpuThreads;

    @Column(name = "cpu_cache", nullable = false, length = 255)
    private String cpuCache;

    @Column(name = "gpu_brand", nullable = false, length = 255)
    private String gpuBrand;

    @Column(name = "gpu_model", nullable = false, length = 255)
    private String gpuModel;

    @Column(name = "gpu_full_name", nullable = false, length = 255)
    private String gpuFullName;

    @Column(name = "gpu_memory", nullable = false, length = 255)
    private String gpuMemory;

    @Column(name = "ram", nullable = false, length = 255)
    private String ram;

    @Column(name = "storage", nullable = false, length = 255)
    private String storage;

    @Column(name = "screen", nullable = false, length = 255)
    private String screen;

    @Column(name = "mausac", nullable = false, length = 255)
    private String mauSac;

    @Column(name = "soluong", nullable = false)
    private Integer soLuong;
}
