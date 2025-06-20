
package DATN.service;

import DATN.dao.TaiKhoanDao;
import DATN.entity.TaiKhoan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TaiKhoanService {
    private final TaiKhoanDao taiKhoanDao;

    public Map<String, Object> login(String tenDangNhap, String matKhau) {
        Map<String, Object> response = new HashMap<>();

        Optional<TaiKhoan> taiKhoanOpt = taiKhoanDao.findByTenDangNhap(tenDangNhap);
        if (taiKhoanOpt.isEmpty()) {
            taiKhoanOpt = taiKhoanDao.findByEmail(tenDangNhap);
        }
        if (taiKhoanOpt.isEmpty()) {
            taiKhoanOpt = taiKhoanDao.findBySoDienThoai(tenDangNhap);
        }

        if (taiKhoanOpt.isPresent()) {
            TaiKhoan taiKhoan = taiKhoanOpt.get();
            if (taiKhoan.getMatKhau().equals(matKhau) && taiKhoan.getTrangThai()) {
                response.put("message", "Đăng nhập thành công");
                response.put("vaiTro", taiKhoan.getVaiTro() ? "ADMIN" : "USER");
                response.put("hoVaTen", taiKhoan.getHoVaTen());
                return response;
            } else if (!taiKhoan.getTrangThai()) {
                response.put("message", "Tài khoản đã bị khóa");
                return response;
            }
        }

        response.put("message", "Tên đăng nhập, email hoặc số điện thoại không đúng");
        return response;
    }

    public Map<String, Object> register(TaiKhoan taiKhoan) {
        Map<String, Object> response = new HashMap<>();

        if (taiKhoan.getTenDangNhap() == null || taiKhoan.getMatKhau() == null ||
            taiKhoan.getHoVaTen() == null || (taiKhoan.getEmail() == null && taiKhoan.getSoDienThoai() == null)) {
            response.put("message", "Vui lòng điền đầy đủ thông tin");
            return response;
        }

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

        taiKhoan.setVaiTro(false); // Default to USER
        taiKhoan.setTrangThai(true); // Active account
        taiKhoan.setNgayTao(LocalDateTime.now());
        taiKhoanDao.save(taiKhoan);

        response.put("message", "Đăng ký thành công");
        return response;
    }
}
