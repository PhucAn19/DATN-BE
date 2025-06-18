package DATN.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import DATN.entity.TaiKhoan;


@Repository
public interface TaiKhoanDao extends JpaRepository<TaiKhoan, Integer> {
	
}