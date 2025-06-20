package DATN.controller;

import DATN.service.TaiKhoanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@CrossOrigin(origins = "http://localhost:5173") // Sửa đúng port frontend Vue
@RestController
@RequestMapping("/api/xacthuc")
@RequiredArgsConstructor
public class LoginController {

    private final TaiKhoanService taiKhoanService;
    private static final long SESSION_TIMEOUT = 60; // phút

    @PostMapping("/dangnhap")
    public ResponseEntity<?> dangNhap(@RequestBody Map<String, String> request, HttpSession session) {
        String tenDangNhap = request.get("tenDangNhap");
        String matKhau = request.get("matKhau");

        Map<String, Object> response = taiKhoanService.login(tenDangNhap, matKhau);
        if ("Đăng nhập thành công".equals(response.get("message"))) {
            session.setAttribute("username", tenDangNhap);
            session.setAttribute("role", response.get("vaiTro")); // 1: admin, 0: user
            session.setAttribute("sessionStartTime", LocalDateTime.now());
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(401).body(response);
        }
    }

    @PostMapping("/dangxuat")
    public ResponseEntity<?> dangXuat(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok(Map.of("message", "Đăng xuất thành công"));
    }

    @GetMapping("/kiem-tra-phien")
    public ResponseEntity<?> kiemTraPhien(HttpSession session) {
        Object username = session.getAttribute("username");
        Object role = session.getAttribute("role");
        LocalDateTime startTime = (LocalDateTime) session.getAttribute("sessionStartTime");

        if (username != null && startTime != null) {
            long minutesElapsed = ChronoUnit.MINUTES.between(startTime, LocalDateTime.now());
            if (minutesElapsed >= SESSION_TIMEOUT) {
                session.invalidate();
                return ResponseEntity.status(401).body(Map.of("message", "Phiên đăng nhập đã hết hạn"));
            }
            return ResponseEntity.ok(Map.of(
                    "message", "Đã đăng nhập",
                    "username", username,
                    "vaiTro", role));
        } else {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }
    }
}