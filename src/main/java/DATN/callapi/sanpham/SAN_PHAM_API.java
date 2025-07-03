package DATN.callapi.sanpham;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.dao.sanpham.SanPhamDao;
import DATN.dto.SAN_PHAM_DTO;
import DATN.entity.sanpham.SanPham;
import DATN.entity.sanpham.VIEW_CHI_TIET_SAN_PHAM;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/sanpham")
@RequiredArgsConstructor
public class SAN_PHAM_API {

    private final SanPhamDao dao;
    private final DATN.service.SanPhamService SAN_PHAM_SER;
    private final DATN.dao.view.VIEW_CHI_TIET_SAN_PHAM_DAO VIEW_CHI_TIET_SAN_PHAM_DAO;

    @GetMapping("/dssp")
    public List<SanPham> getAllSanPham() {
        return dao.findAll();
    }

    @GetMapping("/{id}")
    public SanPham getSanPham(@PathVariable Integer id) {
        return  dao.findById(id).orElse(null);
    }
    
    @GetMapping("/VIEW_CHI_TIET_SAN_PHAM")
    public ResponseEntity<List<VIEW_CHI_TIET_SAN_PHAM>> getAllChiTiet() {
        List<VIEW_CHI_TIET_SAN_PHAM> result = VIEW_CHI_TIET_SAN_PHAM_DAO.findAll();
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/tao")
    public ResponseEntity<String> taoSanPham(@RequestBody SAN_PHAM_DTO request) {
    	SAN_PHAM_SER.createSanPham(request); 
        System.out.println("CPU Brand: " + request.getCpuBrand()); // Phải là "Intel"
        return ResponseEntity.ok("Tạo sản phẩm thành công.");
    }

    // 
    // JSON representation of the provided SQL parameters:
    /*
    {
        "tensanpham": "iPhone 14 Pro",
        "dongia": 25990000,
        "loai": 1,
        "thuonghieu": 1,
        "anhgoc": "default.png",
        "cpuBrand": "Apple",
        "cpuModel": "A16 Bionic",
        "cpuType": "High-end",
        "cpuMinSpeed": "3.46 GHz",
        "cpuMaxSpeed": "3.46 GHz",
        "cpuCores": "6",
        "cpuThreads": "6",
        "cpuCache": "16MB",
        "gpuBrand": "Apple",
        "gpuModel": "Apple GPU",
        "gpuFullName": "Apple GPU 5-core",
        "gpuMemory": "6GB",
        "ram": "6GB",
        "storage": "128GB",
        "screen": "6.1\"",
        "mausac": "Tím",
        "soluong": 10,
        "anhphu": "detail_iphone14.png"
    }
    */
}
