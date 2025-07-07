package DATN.dto.sanpham;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class DTO_DETAILS {
    private Integer id_sp;
    private Integer id_l;
    private Integer id_th;
    private Integer id_ts;
    private Integer id_gg;
    private String tensanpham;
    private Integer dongia;
    private Integer loai;
    private Integer thuonghieu;
    private String anhgoc;
    private LocalDateTime ngaytao;
    private Integer loaigiam;
    private Integer giamgia;
    private LocalDateTime hangiamgia;
    private String loaiTen;
    private String thuonghieuTen;
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
    private String diachianh;
    private Integer loaigiamTen;
}
