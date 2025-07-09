package DATN.dto.dtodata;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.service.dtoservice.dto_service;

@RestController
@RequestMapping("/api/test")
public class TestController {

    private final dto_service productGenerator;

    public TestController(dto_service productGenerator) {
        this.productGenerator = productGenerator;
    }

    @GetMapping("/generate")
    public ResponseEntity<String> testGenerate() {
        productGenerator.generateProducts();
        return ResponseEntity.ok("Đã bắt đầu tạo sản phẩm");
    }
}
