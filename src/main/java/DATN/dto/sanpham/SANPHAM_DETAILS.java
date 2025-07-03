package DATN.dto.sanpham;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SANPHAM_DETAILS {
    // SAN_PHAM
    private int id;
    private String tensanpham;
    private long dongia;
    private int loai;
    private int thuonghieu;
    private String anhgoc;
    private LocalDateTime ngaytao;
    private int loaigiam;
    private Long giamgia;
    private LocalDateTime hangiamgia;
    // LOAI and THUONG_HIEU
    private String loaiTen;
    private String thuonghieuTen;
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
    private int soluong;
    // ANH_SP
    private String diachianh;
    // GIAM_GIA
    private int loaigiamTen;
}
