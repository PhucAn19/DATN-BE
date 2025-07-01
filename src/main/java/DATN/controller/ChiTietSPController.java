package DATN.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import DATN.dao.view.VIEW_CHI_TIET_SAN_PHAM_DAO;
import DATN.entity.sanpham.VIEW_CHI_TIET_SAN_PHAM;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/chitietSP")
@RequiredArgsConstructor
public class ChiTietSPController {

    private final VIEW_CHI_TIET_SAN_PHAM_DAO chiTietDao;

    @GetMapping("/{id}")
    public ResponseEntity<VIEW_CHI_TIET_SAN_PHAM> getChiTietSanPham(@PathVariable("id") Integer id) {
        return chiTietDao.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
}