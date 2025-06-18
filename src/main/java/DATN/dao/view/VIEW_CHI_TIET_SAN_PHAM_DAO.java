package DATN.dao.view;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import DATN.entity.sanpham.VIEW_CHI_TIET_SAN_PHAM;

@Repository
public interface VIEW_CHI_TIET_SAN_PHAM_DAO extends JpaRepository<VIEW_CHI_TIET_SAN_PHAM, Integer> {
}

