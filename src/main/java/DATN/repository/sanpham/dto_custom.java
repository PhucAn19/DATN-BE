package DATN.repository.sanpham;

import java.util.List;

import DATN.dto.sanpham.DTO_CREATE;
import DATN.dto.sanpham.DTO_DETAILS;

public interface dto_custom {
    void DATN_CRE_SP_DB00001_0(DTO_CREATE dto);
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_1(int id_sp);
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_2();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_3();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_4();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_5();
    void DATN_CRE_GY_DB00002_0(DTO_CREATE dto);
}
