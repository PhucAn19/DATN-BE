package DATN.dto.sanpham;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.service.sanpham.sanpham_service;

@RestController
@RequestMapping("/api/test")
public class TestController {

    private final sanpham_service productGenerator;

    public TestController(sanpham_service productGenerator) {
        this.productGenerator = productGenerator;
    }

    @GetMapping("/generate")
    public ResponseEntity<String> testGenerate() {
        productGenerator.generateProducts();
        return ResponseEntity.ok("Đã bắt đầu tạo sản phẩm");
    }
}
