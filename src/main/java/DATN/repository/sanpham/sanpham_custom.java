package DATN.repository.sanpham;

import java.util.List;

import DATN.dto.sanpham.SANPHAM_CREATE;
import DATN.dto.sanpham.SANPHAM_DETAILS;

public interface sanpham_custom {
    void DATN_CRE_SP_DB00001_0(SANPHAM_CREATE dto);
    List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_1(int id);
    List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_2();
    List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_3();
    List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_4();
    List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_5();
}
