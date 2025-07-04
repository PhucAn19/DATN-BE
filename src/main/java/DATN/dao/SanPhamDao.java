package DATN.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import DATN.entity.sanpham.SanPham;

@Repository
public interface SanPhamDao extends JpaRepository<SanPham, Integer> {

	List<SanPham> findTop10ByOrderByIdDesc();
	@Query(value = "EXEC sp_san_pham_noi_bat", nativeQuery = true)
    List<Object[]> getSanPhamNoiBatRaw();
}
