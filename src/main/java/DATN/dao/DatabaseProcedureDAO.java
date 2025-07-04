package DATN.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import DATN.entity.databaseprocedure.DatabaseProcedure;

@Repository
public interface DatabaseProcedureDAO extends JpaRepository<DatabaseProcedure, Long> {

    @Procedure(procedureName  = "DATN_CRE_SP_DB00001_0")
    void taoSanPham(
        @Param("tensanpham") String tenSanPham,
        @Param("dongia") Long donGia,
        @Param("loai") Integer loai,
        @Param("thuonghieu") Integer thuongHieu,
        @Param("anhgoc") String anhGoc,
        @Param("cpu_brand") String cpuBrand,
        @Param("cpu_model") String cpuModel,
        @Param("cpu_type") String cpuType,
        @Param("cpu_min_speed") String cpuMinSpeed,
        @Param("cpu_max_speed") String cpuMaxSpeed,
        @Param("cpu_cores") String cpuCores,
        @Param("cpu_threads") String cpuThreads,
        @Param("cpu_cache") String cpuCache,
        @Param("gpu_brand") String gpuBrand,
        @Param("gpu_model") String gpuModel,
        @Param("gpu_full_name") String gpuFullName,
        @Param("gpu_memory") String gpuMemory,
        @Param("ram") String ram,
        @Param("storage") String storage,
        @Param("screen") String screen,
        @Param("mausac") String mauSac,
        @Param("soluong") Integer soLuong,
        @Param("anhphu") String anhPhu
    );
}
