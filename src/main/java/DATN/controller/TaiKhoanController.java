package DATN.controller;

import DATN.dao.TaiKhoanDao;
import DATN.dto.DoiMatKhauDTO;
import DATN.dto.TaiKhoanResponseDTO;
import DATN.dto.TaiKhoanUpdateDTO;
import DATN.entity.TaiKhoan;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/taikhoan")
@CrossOrigin(origins = "http://localhost:5173")
@RequiredArgsConstructor
public class TaiKhoanController {

    private final TaiKhoanDao taiKhoanDao;

    @GetMapping("/thongtin")
    public ResponseEntity<?> layThongTinTaiKhoan(HttpSession session) {
        Object username = session.getAttribute("username");

        if (username == null) {
            return ResponseEntity.status(401).body("{\"message\": \"Chưa đăng nhập\"}");
        }

        Optional<TaiKhoan> tkOpt = taiKhoanDao.findByTenDangNhap(username.toString());
        if (tkOpt.isEmpty()) {
            return ResponseEntity.status(404).body("{\"message\": \"Không tìm thấy tài khoản\"}");
        }

        TaiKhoan tk = tkOpt.get();

        // Chuyển sang DTO
        TaiKhoanResponseDTO dto = new TaiKhoanResponseDTO();
        dto.setTenDangNhap(tk.getTenDangNhap());
        dto.setHoVaTen(tk.getHoVaTen());
        dto.setEmail(tk.getEmail());
        dto.setSoDienThoai(tk.getSoDienThoai());
        dto.setVaiTro(tk.getVaiTro());

        return ResponseEntity.ok(dto);
    }
    @PutMapping("/capnhat")
    public ResponseEntity<?> capNhatThongTin(@RequestBody TaiKhoanUpdateDTO dto, HttpSession session) {
        Object usernameObj = session.getAttribute("username");
        if (usernameObj == null) {
            return ResponseEntity.status(401).body("{\"message\": \"Chưa đăng nhập\"}");
        }

        String username = usernameObj.toString();
        Optional<TaiKhoan> taiKhoanOpt = taiKhoanDao.findByTenDangNhap(username);

        if (taiKhoanOpt.isEmpty()) {
            return ResponseEntity.status(404).body("{\"message\": \"Không tìm thấy tài khoản\"}");
        }

        TaiKhoan tk = taiKhoanOpt.get();

        // Kiểm tra email nếu thay đổi
        if (!tk.getEmail().equals(dto.getEmail()) &&
            taiKhoanDao.findByEmail(dto.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body("{\"message\": \"Email đã tồn tại\"}");
        }

        // Kiểm tra số điện thoại nếu thay đổi
        if (!tk.getSoDienThoai().equals(dto.getSoDienThoai()) &&
            taiKhoanDao.findBySoDienThoai(dto.getSoDienThoai()).isPresent()) {
            return ResponseEntity.badRequest().body("{\"message\": \"Số điện thoại đã tồn tại\"}");
        }

        // Cập nhật thông tin
        tk.setHoVaTen(dto.getHoVaTen());
        tk.setEmail(dto.getEmail());
        tk.setSoDienThoai(dto.getSoDienThoai());

        taiKhoanDao.save(tk);

        return ResponseEntity.ok("{\"message\": \"Cập nhật thành công\"}");
    }

    @PutMapping("/doi-mat-khau")
    public ResponseEntity<?> doiMatKhau(@RequestBody DoiMatKhauDTO dto, HttpSession session) {
        Object usernameObj = session.getAttribute("username");
        if (usernameObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        String username = usernameObj.toString();
        Optional<TaiKhoan> taiKhoanOpt = taiKhoanDao.findByTenDangNhap(username);

        if (taiKhoanOpt.isEmpty()) {
            return ResponseEntity.status(404).body(Map.of("message", "Không tìm thấy tài khoản"));
        }

        TaiKhoan taiKhoan = taiKhoanOpt.get();

        // Kiểm tra mật khẩu cũ
        if (!taiKhoan.getMatKhau().equals(dto.getMatKhauCu())) {
            return ResponseEntity.badRequest().body(Map.of("message", "Mật khẩu cũ không đúng"));
        }

        // Kiểm tra xác nhận mật khẩu mới
        if (!dto.getMatKhauMoi().equals(dto.getXacNhanMatKhauMoi())) {
            return ResponseEntity.badRequest().body(Map.of("message", "Xác nhận mật khẩu không khớp"));
        }

        // Cập nhật mật khẩu mới
        taiKhoan.setMatKhau(dto.getMatKhauMoi());
        taiKhoanDao.save(taiKhoan);

        return ResponseEntity.ok(Map.of("message", "Đổi mật khẩu thành công"));
    }

}
