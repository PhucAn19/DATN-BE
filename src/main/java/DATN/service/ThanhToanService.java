package DATN.service;

import DATN.dao.thanhtoan.HoaDonDAO;
import DATN.dao.thanhtoan.HoaDonChiTietDAO;
import DATN.dao.thanhtoan.ThanhToanDAO;
import DATN.dto.MoMoPaymentResponseDTO;
import DATN.dto.ThanhToanDTO;
import DATN.entity.thanhtoan.HoaDon;
import DATN.entity.thanhtoan.HoaDonChiTiet;
import DATN.entity.thanhtoan.ThanhToan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhToanService {

    private final HoaDonDAO hoaDonDAO;
    private final HoaDonChiTietDAO hoaDonChiTietDAO;
    private final ThanhToanDAO thanhToanDAO;
    private final MoMoPaymentService moMoPaymentService;

    @Transactional
    public Map<String, Object> taoHoaDon(ThanhToanDTO thanhToanDTO) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Tạo hóa đơn
            HoaDon hoaDon = new HoaDon();
            hoaDon.setTaiKhoan(thanhToanDTO.getTaiKhoanId());
            hoaDon.setGiaHoaDon(thanhToanDTO.getTongTien());
            hoaDon.setTrangThai("PENDING");
            hoaDon.setNoiDung(thanhToanDTO.getGhiChu());
            hoaDon.setDiaChiGiaoHang(thanhToanDTO.getDiaChiGiaoHang());

            HoaDon savedHoaDon = hoaDonDAO.save(hoaDon);

            // Tạo chi tiết hóa đơn
            for (ThanhToanDTO.SanPhamThanhToanDTO sanPham : thanhToanDTO.getDanhSachSanPham()) {
                HoaDonChiTiet chiTiet = new HoaDonChiTiet();
                chiTiet.setHoaDon(savedHoaDon.getId());
                chiTiet.setSanPham(sanPham.getSanPhamId());
                chiTiet.setDonGia(sanPham.getDonGia());
                chiTiet.setSoLuong(sanPham.getSoLuong());
                hoaDonChiTietDAO.save(chiTiet);
            }

            // Tạo thanh toán
            ThanhToan thanhToan = new ThanhToan();
            thanhToan.setHoaDon(savedHoaDon.getId());
            thanhToan.setPhuongThuc(thanhToanDTO.getPhuongThucThanhToan());
            thanhToan.setSoTien(thanhToanDTO.getTongTien());
            thanhToan.setTaiKhoan(thanhToanDTO.getTaiKhoanId());
            thanhToan.setTrangThai("PENDING");

            // Xử lý theo phương thức thanh toán
            if ("MOMO".equals(thanhToanDTO.getPhuongThucThanhToan())) {
                String orderId = "ORDER_" + savedHoaDon.getId() + "_" + System.currentTimeMillis();
                String orderInfo = "Thanh toán đơn hàng #" + savedHoaDon.getId();
                Long amount = thanhToanDTO.getTongTien().longValue();

                MoMoPaymentResponseDTO momoResponse = moMoPaymentService.createPayment(orderId, amount, orderInfo);

                if (momoResponse.getResultCode() == 0) {
                    thanhToan.setMaGiaoDich(orderId);
                    thanhToanDAO.save(thanhToan);

                    response.put("success", true);
                    response.put("message", "Tạo thanh toán MoMo thành công");
                    response.put("hoaDonId", savedHoaDon.getId());
                    response.put("payUrl", momoResponse.getPayUrl());
                    response.put("qrCodeUrl", momoResponse.getQrCodeUrl());
                    response.put("orderId", orderId);
                } else {
                    response.put("success", false);
                    response.put("message", "Lỗi tạo thanh toán MoMo: " + momoResponse.getMessage());
                }
            } else if ("COD".equals(thanhToanDTO.getPhuongThucThanhToan())) {
                thanhToan.setMaGiaoDich("COD_" + UUID.randomUUID().toString());
                thanhToanDAO.save(thanhToan);

                response.put("success", true);
                response.put("message", "Đặt hàng thành công. Thanh toán khi nhận hàng");
                response.put("hoaDonId", savedHoaDon.getId());
            } else {
                response.put("success", false);
                response.put("message", "Phương thức thanh toán không được hỗ trợ");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi khi tạo hóa đơn: " + e.getMessage());
        }

        return response;
    }

    @Transactional
    public Map<String, Object> xacNhanThanhToan(String maGiaoDich, String trangThai) {
        Map<String, Object> response = new HashMap<>();

        try {
            Optional<ThanhToan> thanhToanOpt = thanhToanDAO.findByMaGiaoDich(maGiaoDich);

            if (thanhToanOpt.isPresent()) {
                ThanhToan thanhToan = thanhToanOpt.get();
                thanhToan.setTrangThai(trangThai);
                thanhToan.setNgayThanhToan(LocalDateTime.now());
                thanhToanDAO.save(thanhToan);

                // Cập nhật trạng thái hóa đơn
                Optional<HoaDon> hoaDonOpt = hoaDonDAO.findById(thanhToan.getHoaDon());
                if (hoaDonOpt.isPresent()) {
                    HoaDon hoaDon = hoaDonOpt.get();
                    if ("SUCCESS".equals(trangThai)) {
                        hoaDon.setTrangThai("PAID");
                    } else {
                        hoaDon.setTrangThai("CANCELLED");
                    }
                    hoaDonDAO.save(hoaDon);
                }

                response.put("success", true);
                response.put("message", "Cập nhật trạng thái thanh toán thành công");
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy giao dịch");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi khi xác nhận thanh toán: " + e.getMessage());
        }

        return response;
    }
}