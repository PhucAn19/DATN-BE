package DATN.Dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import DATN.Entity.TaiKhoan;

@Repository
public interface TaiKhoanDao extends JpaRepository<TaiKhoan, Integer> {
}