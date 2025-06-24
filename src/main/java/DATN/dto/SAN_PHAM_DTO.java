package DATN.dto;

import lombok.Data;

@Data
public class SAN_PHAM_DTO {
    private String tensanpham;
    private Long dongia;
    private Integer loai;
    private Integer thuonghieu;
    private String anhgoc;

    // CPU fields
    private String cpuBrand;
    private String cpuModel;
    private String cpuType;
    private String cpuMinSpeed;
    private String cpuMaxSpeed;
    private String cpuCores;
    private String cpuThreads;
    private String cpuCache;

    // GPU fields
    private String gpuBrand;
    private String gpuModel;
    private String gpuFullName;
    private String gpuMemory;

    // Other specs
    private String ram;
    private String storage;
    private String screen;
    private String mausac;
    private Integer soluong;
    private String anhphu;
}
