package DATN.controller;

import DATN.dao.thanhtoan.HoaDonDAO;
import DATN.dto.ThanhToanDTO;
import DATN.entity.thanhtoan.HoaDon;
import DATN.service.ThanhToanService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/thanhtoan")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class ThanhToanController {

    private final ThanhToanService thanhToanService;
    private final HoaDonDAO hoaDonDAO;

    @PostMapping("/tao-hoa-don")
    public ResponseEntity<?> taoHoaDon(@RequestBody ThanhToanDTO thanhToanDTO, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        thanhToanDTO.setTaiKhoanId((Integer) userIdObj);
        Map<String, Object> result = thanhToanService.taoHoaDon(thanhToanDTO);

        if ((Boolean) result.get("success")) {
            // Xóa giỏ hàng sau khi tạo hóa đơn thành công
            session.removeAttribute("gioHang");
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.badRequest().body(result);
        }
    }

    @GetMapping("/lich-su")
    public ResponseEntity<?> lichSuDonHang(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        List<HoaDon> danhSachHoaDon = hoaDonDAO.findByTaiKhoanOrderByNgayTaoDesc((Integer) userIdObj);
        return ResponseEntity.ok(danhSachHoaDon);
    }


    @GetMapping("/chi-tiet/{hoaDonId}")
    public ResponseEntity<?> chiTietHoaDon(@PathVariable Integer hoaDonId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        return hoaDonDAO.findById(hoaDonId)
                .map(hoaDon -> {
                    if (!hoaDon.getTaiKhoan().equals(userIdObj)) {
                        return ResponseEntity.status(403).body(Map.of("message", "Không có quyền truy cập"));
                    }
                    return ResponseEntity.ok(hoaDon);
                })
                .orElse(ResponseEntity.notFound().build());
    }
}