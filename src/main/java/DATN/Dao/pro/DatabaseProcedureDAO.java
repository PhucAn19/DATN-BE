package DATN.Dao.pro;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import DATN.entity.DatabaseProcedure.DatabaseProcedure;

@Repository
public interface DatabaseProcedureDAO extends JpaRepository<DatabaseProcedure, Long> {

    @Procedure(name = "DATN_CRE_SP_DB00001_0")
    void taoSanPham(
        @Param("tensanpham") String tenSanPham,
        @Param("dongia") Long donGia,
        @Param("loai") Integer loai,
        @Param("thuonghieu") Integer thuongHieu,
        @Param("anhgoc") String anhGoc,
        @Param("thongso") String thongSo,
        @Param("mausac") String mauSac,
        @Param("soluong") Integer soLuong,
        @Param("anhphu") String anhPhu
    );
}
