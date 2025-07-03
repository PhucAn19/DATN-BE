package DATN.repository.sanpham;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import DATN.dto.sanpham.SANPHAM_CREATE;
import DATN.dto.sanpham.SANPHAM_DETAILS;

@Repository
public class sanpham_repositpry implements sanpham_custom{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void DATN_CRE_SP_DB00001_0(SANPHAM_CREATE dto) {
        String sql = "EXEC DATN_CRE_SP_DB00001_0 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?";

        jdbcTemplate.update(sql,
            dto.getTensanpham(),
            dto.getDongia(),
            dto.getLoai(),
            dto.getThuonghieu(),
            dto.getAnhgoc(),
            dto.getCpuBrand(),
            dto.getCpuModel(),
            dto.getCpuType(),
            dto.getCpuMinSpeed(),
            dto.getCpuMaxSpeed(),
            dto.getCpuCores(),
            dto.getCpuThreads(),
            dto.getCpuCache(),
            dto.getGpuBrand(),
            dto.getGpuModel(),
            dto.getGpuFullName(),
            dto.getGpuMemory(),
            dto.getRam(),
            dto.getRom(),
            dto.getScreen(),
            dto.getMausac(),
            dto.getSoluong(),
            dto.getDiachianh()
        );
    }

    @Override
    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_1(int id) {
        String sql = "EXEC DATN_SEL_SP_DB00001_1 ?";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(SANPHAM_DETAILS.class),
            id
        );
    }


    @Override
    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_2() {
        String sql = "EXEC DATN_SEL_SP_DB00001_2";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(SANPHAM_DETAILS.class)
        );
    }

    @Override
    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_3() {
        String sql = "EXEC DATN_SEL_SP_DB00001_3";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(SANPHAM_DETAILS.class)
        );
    }

    @Override
    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_4() {
        String sql = "EXEC DATN_SEL_SP_DB00001_4";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(SANPHAM_DETAILS.class)
        );
    }

    @Override
    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_5() {
        String sql = "EXEC DATN_SEL_SP_DB00001_5";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(SANPHAM_DETAILS.class)
        );
    }
}
