package DATN.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import DATN.dao.procdure.DatabaseProcedureDAO;
import DATN.dao.sanpham.SanPhamDao;
import DATN.dao.view.SanPhamXepHangViewDao;
import DATN.dao.view.VIEW_CHI_TIET_SAN_PHAM_DAO;
import DATN.dto.SAN_PHAM_DTO;
import DATN.dto.SanPhamNoiBatDTO;
import DATN.dto.SanPhamXepHangDTO;
import DATN.entity.sanpham.SanPham;
import DATN.entity.sanpham.VIEW_CHI_TIET_SAN_PHAM;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SanPhamService {

	@Autowired
    private SanPhamXepHangViewDao viewDao;
	
	@Autowired
    private VIEW_CHI_TIET_SAN_PHAM_DAO viewChiTietDAO;

    public VIEW_CHI_TIET_SAN_PHAM getChiTietById(Integer id) {
        return viewChiTietDAO.findById(id).orElse(null);
    }
    
    private final DatabaseProcedureDAO procedureRepo;

    private final SanPhamDao SPDao;
    
    public List<SanPham> getTop10SanPhams() {
        return SPDao.findTop10ByOrderByIdDesc();
    }
    
    public List<SanPham> getAllSanPhams() {
        return SPDao.findAll();
    }

    public SanPham getSanPhamById(Integer id) {
        return SPDao.findById(id).orElse(null);
    }
    
    public List<SanPhamNoiBatDTO> getSanPhamNoiBat() {
        List<Object[]> rawList = SPDao.getSanPhamNoiBatRaw();
        List<SanPhamNoiBatDTO> result = new ArrayList<>();

        for (Object[] row : rawList) {
            SanPhamNoiBatDTO dto = new SanPhamNoiBatDTO();
            dto.setId((Integer) row[0]);
            dto.setTenSanPham((String) row[1]);
            dto.setAnhGoc((String) row[2]);
            dto.setTongSoLuongBan((Integer) row[3]);
            dto.setTongDoanhThu(
                row[4] instanceof Double ? (Double) row[4] : ((Number) row[4]).doubleValue()
            );
            result.add(dto);
        }

        return result;
    }

    public void createSanPham(SAN_PHAM_DTO dto) {
        procedureRepo.taoSanPham(
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
            dto.getStorage(),
            dto.getScreen(),
            dto.getMausac(),
            dto.getSoluong(),
            dto.getAnhphu()
        );        
    }
    
    public List<SanPhamXepHangDTO> getTop10SanPhamXepHang() {
        return viewDao.findTop10ByOrderByDiemDanhGiaTBDescSoLuotYeuThichDesc()
                      .stream()
                      .map(sp -> new SanPhamXepHangDTO(
                          sp.getId(),
                          sp.getTenSanPham(),
                          sp.getDonGia(),
                          sp.getAnhGoc(),
                          sp.getSoLuotYeuThich(),
                          sp.getDiemDanhGiaTB()
                      ))
                      .toList();
    }
    
}
