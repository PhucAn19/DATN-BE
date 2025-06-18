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
            dto.getThongso(),
            dto.getMausac(),
            dto.getSoluong(),
            dto.getAnhphu()
        );
    }
}
