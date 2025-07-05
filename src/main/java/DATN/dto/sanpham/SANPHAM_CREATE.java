package DATN.dto.sanpham;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SANPHAM_CREATE {
    // SAN_PHAM
    private String tensanpham;
    private long dongia;
    private Integer loai;
    private Integer thuonghieu;
    private String anhgoc;
    // THONG_SO
    private String cpuBrand;
    private String cpuModel;
    private String cpuType;
    private String cpuMinSpeed;
    private String cpuMaxSpeed;
    private String cpuCores;
    private String cpuThreads;
    private String cpuCache;
    private String gpuBrand;
    private String gpuModel;
    private String gpuFullName;
    private String gpuMemory;
    private String ram;
    private String rom;
    private String screen;
    private String mausac;
    private Integer soluong;
    // ANH_SP
    private String diachianh;
}
