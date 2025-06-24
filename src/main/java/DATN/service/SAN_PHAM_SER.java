package DATN.service;

import org.springframework.stereotype.Service;

import DATN.dao.procdure.DatabaseProcedureDAO;
import DATN.dto.SAN_PHAM_DTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SAN_PHAM_SER {

    private final DatabaseProcedureDAO procedureRepo;

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
