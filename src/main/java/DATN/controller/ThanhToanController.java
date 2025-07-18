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

    @PostMapping("/momo/notify")
    public ResponseEntity<?> momoNotify(@RequestBody Map<String, Object> payload) {
        try {
            String orderId = (String) payload.get("orderId");
            Integer resultCode = (Integer) payload.get("resultCode");
            
            String trangThai = (resultCode == 0) ? "SUCCESS" : "FAILED";
            Map<String, Object> result = thanhToanService.xacNhanThanhToan(orderId, trangThai);

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Lỗi xử lý callback MoMo"));
        }
    }

    @GetMapping("/momo/return")
    public ResponseEntity<?> momoReturn(@RequestParam Map<String, String> params) {
        try {
            String orderId = params.get("orderId");
            String resultCode = params.get("resultCode");
            
            String trangThai = "0".equals(resultCode) ? "SUCCESS" : "FAILED";
            Map<String, Object> result = thanhToanService.xacNhanThanhToan(orderId, trangThai);

            if ("SUCCESS".equals(trangThai)) {
                return ResponseEntity.ok(Map.of(
                    "message", "Thanh toán thành công",
                    "orderId", orderId
                ));
            } else {
                return ResponseEntity.badRequest().body(Map.of(
                    "message", "Thanh toán thất bại",
                    "orderId", orderId
                ));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Lỗi xử lý kết quả thanh toán"));
        }
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