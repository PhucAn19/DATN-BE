package DATN.dao.view;

import DATN.entity.sanpham.SanPhamXepHangView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SanPhamXepHangViewDao extends JpaRepository<SanPhamXepHangView, Integer> {
    List<SanPhamXepHangView> findTop10ByOrderByDiemDanhGiaTBDescSoLuotYeuThichDesc();
}
