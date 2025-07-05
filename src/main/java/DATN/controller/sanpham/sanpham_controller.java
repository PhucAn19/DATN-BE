package DATN.controller.sanpham;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.dto.sanpham.SANPHAM_CREATE;
import DATN.dto.sanpham.SANPHAM_DETAILS;
import DATN.service.sanpham.sanpham_service;

@RestController
@RequestMapping("/api/san-pham")
public class sanpham_controller {
    @Autowired
    private sanpham_service sanpham_service;

    // Tạo sản phẩm mới
    @PostMapping("/tao")
    public ResponseEntity<String> DATN_CRE_SP_DB00001_0(@RequestBody SANPHAM_CREATE dto) {
        try {
            sanpham_service.DATN_CRE_SP_DB00001_0(dto);
            return ResponseEntity.ok("Thêm sản phẩm thành công!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Thêm sản phẩm thất bại: " + e.getMessage());
        }
    }

    // Lấy toàn bộ dữ liệu sản phẩm theo id
    @GetMapping("/{id}")
    public ResponseEntity<List<SANPHAM_DETAILS>> DATN_SEL_SP_DB00001_1(@PathVariable("id") int id_sp) {
        return ResponseEntity.ok(sanpham_service.DATN_SEL_SP_DB00001_1(id_sp));
    }

    // Lấy toàn bộ dữ liệu tất cả sản phẩm
    @GetMapping
    public ResponseEntity<List<SANPHAM_DETAILS>> DATN_SEL_SP_DB00001_2() {
        return ResponseEntity.ok(sanpham_service.DATN_SEL_SP_DB00001_2());
    }

    // Sắp xếp sản phẩm theo ngày tạo
    @GetMapping("/ngay-tao")
    public ResponseEntity<List<SANPHAM_DETAILS>> DATN_SEL_SP_DB00001_3() {
        return ResponseEntity.ok(sanpham_service.DATN_SEL_SP_DB00001_3());
    }

    // Sắp xếp sản phẩm theo lượt yêu thich
    @GetMapping("/yeu-thich")
    public ResponseEntity<List<SANPHAM_DETAILS>> DATN_SEL_SP_DB00001_4() {
        return ResponseEntity.ok(sanpham_service.DATN_SEL_SP_DB00001_4());
    }

    // Lấy toàn bộ sản phẩm còn hạn giảm giá
    @GetMapping("/giam-gia")
    public ResponseEntity<List<SANPHAM_DETAILS>> DATN_SEL_SP_DB00001_5() {
        return ResponseEntity.ok(sanpham_service.DATN_SEL_SP_DB00001_5());
    }
}
/*
    {
        "tensanpham": "Laptop X",
        "dongia": 20000000,
        "loai": 1,
        "thuonghieu": 2,
        "anhgoc": "image.jpg",
        "cpuBrand": "Intel",
        "cpuModel": "i5-1135G7",
        "cpuType": "U",
        "cpuMinSpeed": "2.4GHz",
        "cpuMaxSpeed": "4.2GHz",
        "cpuCores": "4",
        "cpuThreads": "8",
        "cpuCache": "8MB",
        "gpuBrand": "NVIDIA",
        "gpuModel": "MX450",
        "gpuFullName": "NVIDIA GeForce MX450",
        "gpuMemory": "2GB",
        "ram": "16GB",
        "rom": "512GB SSD",
        "screen": "15.6 inch FHD",
        "mausac": "Đen",
        "soluong": 10
    }
*/