package DATN.service.sanpham;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import DATN.dto.sanpham.SANPHAM_CREATE;
import DATN.dto.sanpham.SANPHAM_DETAILS;
import DATN.repository.sanpham.sanpham_custom;

@Service 
public class sanpham_service {
    @Autowired
    private sanpham_custom sanpham_custom;

    public void DATN_CRE_SP_DB00001_0(SANPHAM_CREATE dto) {
        sanpham_custom.DATN_CRE_SP_DB00001_0(dto);
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_1(int id) {
        return sanpham_custom.DATN_SEL_SP_DB00001_1(id);
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_2() {
        return sanpham_custom.DATN_SEL_SP_DB00001_2();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_3() {
        return sanpham_custom.DATN_SEL_SP_DB00001_3();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_4() {
        return sanpham_custom.DATN_SEL_SP_DB00001_4();
    }

    public List<SANPHAM_DETAILS> DATN_SEL_SP_DB00001_5() {
        return sanpham_custom.DATN_SEL_SP_DB00001_5();
    }
}
