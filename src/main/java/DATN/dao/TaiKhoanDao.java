package DATN.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.entity.TaiKhoan.TaiKhoan;

import java.util.Optional;

@Repository
public interface TaiKhoanDao extends JpaRepository<TaiKhoan, Integer> {
    Optional<TaiKhoan> findByTenDangNhap(String tenDangNhap);

    Optional<TaiKhoan> findByEmail(String email);

    Optional<TaiKhoan> findBySoDienThoai(String soDienThoai);
}