package DATN.dao.sanpham;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import DATN.entity.sanpham.SanPham;

@Repository
public interface SanPhamDao extends JpaRepository<SanPham, Integer> {

	List<SanPham> findTop10ByOrderByIdDesc();
	
}
