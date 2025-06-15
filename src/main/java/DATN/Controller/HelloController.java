package DATN.controller;

import java.util.List;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import DATN.Dao.TaiKhoanDao;
import DATN.entity.TaiKhoan;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/taikhoan")
@RequiredArgsConstructor
public class HelloController {

    private final TaiKhoanDao taiKhoanDao; // KHÔNG gán = null

    @GetMapping
    public List<TaiKhoan> getAllTaiKhoan() {
        return taiKhoanDao.findAll();
    }

    @GetMapping("/{id}")
    public TaiKhoan getTaiKhoanById(@PathVariable Integer id) {
        return  taiKhoanDao.findById(id).orElse(null);
    }
}
