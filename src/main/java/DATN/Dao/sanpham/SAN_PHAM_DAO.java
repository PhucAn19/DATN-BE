package DATN.Dao.sanpham;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import DATN.entity.sanpham.SAN_PHAM;

@Repository
public interface SAN_PHAM_DAO extends JpaRepository<SAN_PHAM, Integer> {
	
}
