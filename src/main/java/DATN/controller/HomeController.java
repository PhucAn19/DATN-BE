package DATN.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.dto.SanPhamXepHangDTO;
import DATN.entity.sanpham.SanPham;
import DATN.service.SanPhamService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/Home")
@RequiredArgsConstructor
public class HomeController {

	private final SanPhamService SPService;
	
	@GetMapping
    public List<SanPham> getAllSanPhams() {
        return SPService.getAllSanPhams();
    }

    @GetMapping("/{id}")
    public SanPham getSanPhamById(@PathVariable Integer id) {
        return  SPService.getSanPhamById(id);
    }
	
    @GetMapping("/moi")
    public List<SanPham> getTop10SanPhams() {
        return SPService.getTop10SanPhams();
    }

    @GetMapping("/noibat")
    public List<SanPhamXepHangDTO> getTopXepHang() {
        return SPService.getTop10SanPhamXepHang();
    }
}
