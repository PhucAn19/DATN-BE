package DATN.controller;

import DATN.dto.LoginRequestDTO;
import DATN.dto.RegisterRequestDTO;
import DATN.entity.TaiKhoan;
import DATN.service.TaiKhoanService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;

@CrossOrigin(origins = "http://localhost:5173")
@RestController
@RequestMapping("/api/xacthuc")
@RequiredArgsConstructor
public class LoginController {

    private final TaiKhoanService taiKhoanService;
    private static final long SESSION_TIMEOUT = 60; // phút
    private final ObjectMapper objectMapper = new ObjectMapper();

    @PostMapping("/dangnhap")
    public ResponseEntity<?> dangNhap(@RequestBody LoginRequestDTO loginDTO, HttpSession session) {
        String tenDangNhap = loginDTO.getTenDangNhap();
        String matKhau = loginDTO.getMatKhau();

        Map<String, Object> result = taiKhoanService.login(tenDangNhap, matKhau);
        String message = (String) result.get("message");

        if ("Đăng nhập thành công".equals(message)) {
            session.setAttribute("username", tenDangNhap);
            session.setAttribute("role", result.get("vaiTro"));
            session.setAttribute("sessionStartTime", LocalDateTime.now());
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(401).body(result);
        }
    }


    @PostMapping("/dangxuat")
    public ResponseEntity<String> dangXuat(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok("{\"message\": \"Đăng xuất thành công\"}");
    }

    @PostMapping("/dangky")
    public ResponseEntity<?> register(@RequestBody RegisterRequestDTO dto) {
        // Tạo đối tượng TaiKhoan từ DTO
        TaiKhoan taiKhoan = new TaiKhoan();
        taiKhoan.setTenDangNhap(dto.getTenDangNhap());
        taiKhoan.setMatKhau(dto.getMatKhau());
        taiKhoan.setHoVaTen(dto.getHoVaTen());
        taiKhoan.setSoDienThoai(dto.getSoDienThoai());
        taiKhoan.setEmail(dto.getEmail());

        Map<String, Object> response = taiKhoanService.register(taiKhoan);
        String message = (String) response.get("message");

        if ("Đăng ký thành công".equals(message)) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }


    @GetMapping("/kiem-tra-phien")
    public ResponseEntity<String> kiemTraPhien(HttpSession session) {
        try {
            Object username = session.getAttribute("username");
            Object role = session.getAttribute("role");
            LocalDateTime startTime = (LocalDateTime) session.getAttribute("sessionStartTime");

            if (username != null && startTime != null) {
                long minutesElapsed = ChronoUnit.MINUTES.between(startTime, LocalDateTime.now());

                if (minutesElapsed >= SESSION_TIMEOUT) {
                    session.invalidate();
                    return ResponseEntity.status(401).body("{\"message\": \"Phiên đăng nhập đã hết hạn\"}");
                }

                String responseJson = objectMapper.writeValueAsString(Map.of(
                        "message", "Đã đăng nhập",
                        "username", username,
                        "vaiTro", role
                ));

                return ResponseEntity.ok(responseJson);
            } else {
                return ResponseEntity.status(401).body("{\"message\": \"Chưa đăng nhập\"}");
            }

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("{\"message\": \"Lỗi kiểm tra phiên\"}");
        }
    }
}
