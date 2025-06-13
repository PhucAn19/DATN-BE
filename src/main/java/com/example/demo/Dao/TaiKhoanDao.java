package com.example.demo.Dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.Entity.TaiKhoan;

@Repository
public interface TaiKhoanDao extends JpaRepository<TaiKhoan, Integer> {
}