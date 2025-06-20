package DATN.controller;

import DATN.entity.TaiKhoan;
import DATN.service.TaiKhoanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class LoginController {

    private final TaiKhoanService taiKhoanService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request, HttpSession session) {
        String tenDangNhap = request.get("tenDangNhap");
        String matKhau = request.get("matKhau");

        Map<String, Object> response = taiKhoanService.login(tenDangNhap, matKhau);
        if ("Đăng nhập thành công".equals(response.get("message"))) {
            // Lưu session
            session.setAttribute("username", tenDangNhap);
            session.setAttribute("role", response.get("vaiTro"));
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(401).body(response);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody TaiKhoan taiKhoan) {
        Map<String, Object> response = taiKhoanService.register(taiKhoan);
        if ("Đăng ký thành công".equals(response.get("message"))) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpSession session) {
        session.invalidate(); // Xoá toàn bộ session
        return ResponseEntity.ok(Map.of("message", "Đăng xuất thành công"));
    }

    @GetMapping("/check-session")
    public ResponseEntity<?> checkSession(HttpSession session) {
        Object username = session.getAttribute("username");
        Object role = session.getAttribute("role");

        if (username != null) {
            return ResponseEntity.ok(Map.of(
                    "message", "Đã đăng nhập",
                    "username", username,
                    "vaiTro", role));
        } else {
            return ResponseEntity.status(401).body(Map.of(
                    "message", "Chưa đăng nhập"));
        }
    }

    @GetMapping
    public ResponseEntity<?> defaultAuth() {
        return ResponseEntity.ok(Map.of("message", "Auth API is running"));
    }
}
