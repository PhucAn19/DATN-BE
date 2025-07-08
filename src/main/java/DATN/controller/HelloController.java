package DATN.controller;

import java.util.List;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.dto.SanPhamNoiBatDTO;
import DATN.entity.sanpham.SanPham;
import DATN.service.SanPhamService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/SanPham")
@RequiredArgsConstructor
public class HelloController {

    private final SanPhamService SPService; // KHÔNG gán = null

    @GetMapping
    public List<SanPham> getAllSanPhams() {
        return SPService.getAllSanPhams();
    }

    @GetMapping("/{id}")
    public SanPham getSanPhamById(@PathVariable Integer id) {
        return  SPService.getSanPhamById(id);
    }
    
    @GetMapping("/noibat")
    public List<SanPhamNoiBatDTO> getSanPhamNoiBat() {
        return SPService.getSanPhamNoiBat();
    }

}