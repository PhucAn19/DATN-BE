package DATN.callapi.sanpham;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.dao.sanpham.SAN_PHAM_DAO;
import DATN.dto.SAN_PHAM_DTO;
import DATN.entity.sanpham.SAN_PHAM;
import DATN.entity.sanpham.VIEW_CHI_TIET_SAN_PHAM;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/sanpham")
@RequiredArgsConstructor
public class SAN_PHAM_API {

    private final SAN_PHAM_DAO dao;
    private final DATN.service.SAN_PHAM_SER SAN_PHAM_SER;
    private final DATN.dao.view.VIEW_CHI_TIET_SAN_PHAM_DAO VIEW_CHI_TIET_SAN_PHAM_DAO;

    @GetMapping("/dssp")
    public List<SAN_PHAM> getAllTaiKhoan() {
        return dao.findAll();
    }

    @GetMapping("/{id}")
    public SAN_PHAM getTaiKhoanById(@PathVariable Integer id) {
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
        return ResponseEntity.ok("Tạo sản phẩm thành công.");
    }
}