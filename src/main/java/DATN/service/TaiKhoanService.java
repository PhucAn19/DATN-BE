package DATN.service;

import DATN.dao.TaiKhoanDao;
import DATN.entity.TaiKhoan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class TaiKhoanService {

    private final TaiKhoanDao taiKhoanDao;

    // === LOGIN ===
    public Map<String, Object> login(String tenDangNhap, String matKhau) {
        Map<String, Object> response = new HashMap<>();

        // Cho phép đăng nhập bằng tên đăng nhập, email hoặc số điện thoại
        Optional<TaiKhoan> taiKhoanOpt = timTaiKhoanTheoThongTinDangNhap(tenDangNhap);

        if (taiKhoanOpt.isEmpty()) {
            response.put("message", "Tài khoản không tồn tại");
            return response;
        }

        TaiKhoan taiKhoan = taiKhoanOpt.get();

        // Kiểm tra mật khẩu và trạng thái tài khoản
        if (!taiKhoan.getMatKhau().equals(matKhau)) {
            response.put("message", "Mật khẩu không đúng");
            return response;
        }

        if (!taiKhoan.getTrangThai()) {
            response.put("message", "Tài khoản đã bị khóa");
            return response;
        }

        // Đăng nhập thành công
        response.put("message", "Đăng nhập thành công");
        response.put("vaiTro", taiKhoan.getVaiTro() ? 1 : 0); // 1 = ADMIN, 0 = USER
        response.put("hoVaTen", taiKhoan.getHoVaTen());
        return response;
    }

    // === REGISTER ===
    public Map<String, Object> register(TaiKhoan taiKhoan) {
        Map<String, Object> response = new HashMap<>();

        // Kiểm tra dữ liệu đầu vào
        if (taiKhoan.getTenDangNhap() == null || taiKhoan.getMatKhau() == null || taiKhoan.getHoVaTen() == null) {
            response.put("message", "Vui lòng điền đầy đủ thông tin");
            return response;
        }

        // Bắt buộc phải có email hoặc số điện thoại
        if (taiKhoan.getEmail() == null && taiKhoan.getSoDienThoai() == null) {
            response.put("message", "Phải cung cấp Email hoặc Số điện thoại");
            return response;
        }

        // Kiểm tra trùng lặp thông tin
        if (taiKhoanDao.findByTenDangNhap(taiKhoan.getTenDangNhap()).isPresent()) {
            response.put("message", "Tên đăng nhập đã tồn tại");
            return response;
        }
        if (taiKhoan.getEmail() != null && taiKhoanDao.findByEmail(taiKhoan.getEmail()).isPresent()) {
            response.put("message", "Email đã được sử dụng");
            return response;
        }
        if (taiKhoan.getSoDienThoai() != null && taiKhoanDao.findBySoDienThoai(taiKhoan.getSoDienThoai()).isPresent()) {
            response.put("message", "Số điện thoại đã được sử dụng");
            return response;
        }

        // Thiết lập mặc định
        taiKhoan.setVaiTro(false); // Mặc định là USER
        taiKhoan.setTrangThai(true); // Kích hoạt tài khoản
        taiKhoan.setNgayTao(LocalDateTime.now());

        // Lưu vào CSDL
        taiKhoanDao.save(taiKhoan);

        response.put("message", "Đăng ký thành công");
        return response;
    }

    // === PRIVATE UTIL ===
    private Optional<TaiKhoan> timTaiKhoanTheoThongTinDangNhap(String thongTin) {
        // Ưu tiên theo tên đăng nhập, nếu không có thì email, sau đó số điện thoại
        Optional<TaiKhoan> tk = taiKhoanDao.findByTenDangNhap(thongTin);
        if (tk.isPresent()) return tk;

        tk = taiKhoanDao.findByEmail(thongTin);
        if (tk.isPresent()) return tk;

        return taiKhoanDao.findBySoDienThoai(thongTin);
    }

}
