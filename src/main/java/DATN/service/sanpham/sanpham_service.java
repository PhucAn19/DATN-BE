package DATN.service.sanpham;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import DATN.dto.sanpham.SANPHAM_CREATE;
import DATN.dto.sanpham.SANPHAM_DETAILS;
import DATN.repository.sanpham.sanpham_custom;

import org.springframework.http.*;
import java.util.Map;

@Service 
public class sanpham_service {
    @Autowired
    private sanpham_custom sanpham_custom;

    public void DATN_CRE_SP_DB00001_0(SANPHAM_CREATE dto) {
        sanpham_custom.DATN_CRE_SP_DB00001_0(dto);
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_1(int id_sp) {
        return sanpham_custom.DATN_SEL_SP_DB00001_1(id_sp);
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_2() {
        return sanpham_custom.DATN_SEL_SP_DB00001_2();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_3() {
        return sanpham_custom.DATN_SEL_SP_DB00001_3();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_4() {
        return sanpham_custom.DATN_SEL_SP_DB00001_4();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_5() {
        return sanpham_custom.DATN_SEL_SP_DB00001_5();
    }

    private final String url = "http://localhost:8080/api/san-pham/tao";
    private final RestTemplate restTemplate = new RestTemplate();

    public void generateProducts() {
        for (int i = 1; i <= 1000000; i++) {
            Map<String, Object> payload = new HashMap<>();
            payload.put("tensanpham", "iPhone 14 Pro " + i);
            payload.put("dongia", 25990000 + i * 100);
            payload.put("loai", 1);
            payload.put("thuonghieu", 1);
            payload.put("anhgoc", "default.png");
            payload.put("cpuBrand", "Apple");
            payload.put("cpuModel", "A16 Bionic");
            payload.put("cpuType", "High-end");
            payload.put("cpuMinSpeed", "3.46 GHz");
            payload.put("cpuMaxSpeed", "3.46 GHz");
            payload.put("cpuCores", "6");
            payload.put("cpuThreads", "6");
            payload.put("cpuCache", "16MB");
            payload.put("gpuBrand", "Apple");
            payload.put("gpuModel", "Apple GPU");
            payload.put("gpuFullName", "Apple GPU 5-core");
            payload.put("gpuMemory", "6GB");
            payload.put("ram", "6GB");
            payload.put("rom", "128GB");
            payload.put("screen", "6.1\"");
            payload.put("mausac", "Tím");
            payload.put("soluong", 10);
            payload.put("diachianh", "detail_iphone14.png");
            

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(payload, headers);

            try {
                ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
                System.out.println("✅ Tạo thành công SP" + i);
            } catch (Exception e) {
                System.err.println("❌ Lỗi tạo SP" + i + ": " + e.getMessage());
            }
        }
    }
}
