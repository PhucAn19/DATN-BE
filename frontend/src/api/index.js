import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
  },
})

export default apiClient

// ===== FEEDBACK API =====
export function postFeedback(data) {
  return apiClient.post('/san-pham/tao-gop-y', data)
}

export function fetchFeedback(page = 1, size = 10) {
  return apiClient.get('/san-pham/gop-y', {
    params: {
      p_pageNo: page,
      p_pageSize: size,
    },
  });
}

// ===== GIỎ HÀNG API =====
export function themVaoGioHang(data) {
  return apiClient.post('/gio-hang/them', data)
}

export function xemGioHang() {
  return apiClient.get('/gio-hang/xem')
}

export function capNhatGioHang(data) {
  return apiClient.put('/gio-hang/cap-nhat', data)
}

export function xoaKhoiGioHang(sanPhamId) {
  return apiClient.delete(`/gio-hang/xoa/${sanPhamId}`)
}

export function xoaTatCaGioHang() {
  return apiClient.delete('/gio-hang/xoa-tat-ca')
}

// ===== THANH TOÁN API =====
export function taoHoaDon(orderData) {
  return apiClient.post('/thanhtoan/tao-hoa-don', orderData)
}

export function lichSuDonHang() {
  return apiClient.get('/thanhtoan/lich-su')
}

export function chiTietHoaDon(hoaDonId) {
  return apiClient.get(`/thanhtoan/chi-tiet/${hoaDonId}`)
}

// ===== ĐĂNG NHẬP API =====
export function dangNhap(data) {
  return apiClient.post('/xacthuc/dangnhap', data)
}

export function dangXuat() {
  return apiClient.post('/xacthuc/dangxuat')
}

export function kiemTraPhien() {
  return apiClient.get('/xacthuc/kiem-tra-phien')
}

// ===== SẢN PHẨM API =====
export function layDanhSachSanPham() {
  return apiClient.get('/SanPham')
}

export function layChiTietSanPham(id) {
  return apiClient.get(`/SanPham/${id}`)
}

// ===== LEGACY (giữ lại để tương thích) =====
export function createMoMoPayment(orderData) {
  return taoHoaDon(orderData)
}

export function saveOrder(orderData) {
  return taoHoaDon(orderData)
}