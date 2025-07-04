package DATN.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import DATN.dao.DatabaseProcedureDAO;
import DATN.dao.SanPhamDao;
import DATN.dto.SAN_PHAM_DTO;
import DATN.entity.sanpham.SanPham;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SanPhamService {
    
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
    
}
