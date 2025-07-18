<template>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb p-2 mt-2" style="background-color: #eaf0fc;">
            <li class="breadcrumb-item">
                <a href="/" class="text-primary">Trang chủ</a>
            </li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Thanh toán</li>
        </ol>
    </nav>

    <div class="text-start ms-5 mt-4">
        <RouterLink to="/giohang" class="text-primary text-decoration-none d-inline-flex align-items-center">
            <i class="bi bi-chevron-left"></i>
            <span class="ms-1">Quay lại giỏ hàng</span>
        </RouterLink>
    </div>

    <div class="container my-4">
        <div class="row">
            <!-- DANH SÁCH SẢN PHẨM -->
            <div class="col-12 mb-4">
                <div class="card shadow-sm border-0 p-3 bg-light rounded-4">
                    <div class="d-flex align-items-center mb-3">
                        <label class="form-check-label fw-semibold">
                            Tổng sản phẩm ({{ selectedQuantity }})
                        </label>
                    </div>

                    <div v-for="(item, index) in cart" :key="index" class="d-flex align-items-center mb-3">
                        <img :src="item.image || item.anhGoc" class="rounded border"
                            style="width: 100px; height: 100px; object-fit: contain" :alt="item.name || item.tenSanPham" />
                        <div class="ms-3 flex-grow-1">
                            <div class="fw-semibold">{{ item.name || item.tenSanPham }}</div>
                            <div>
                                <span class="badge bg-light text-dark border mt-1 px-2 py-1" style="font-size: 13px">
                                    Phân loại: {{ item.variant || 'Mặc định' }}
                                </span>
                            </div>
                        </div>
                        <div class="text-muted me-5">x{{ item.quantity || item.soLuong }}</div>
                        <div class="text-end">
                            <div class="fw-bold text-danger">{{ formatPrice(item.price || item.donGia) }} đ</div>
                            <div v-if="item.originalPrice" class="text-decoration-line-through text-muted small">
                                {{ formatPrice(item.originalPrice) }} đ
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- THÔNG TIN ĐƠN HÀNG VÀ FORM -->
            <div class="col-lg-8">
                <div class="card border-0 rounded-4 p-4 bg-light">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên người nhận hàng</label>
                        <input type="text" class="form-control" v-model="receiverName" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại</label>
                        <input type="tel" class="form-control" v-model="phone" />
                    </div>

                    <p class="fw-semibold mb-2">Địa chỉ nhận hàng</p>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <select class="form-select" v-model="city">
                                <option disabled selected>Chọn tỉnh/ Thành phố</option>
                                <option value="TP.HCM">TP.HCM</option>
                                <option value="Hà Nội">Hà Nội</option>
                                <option value="Đà Nẵng">Đà Nẵng</option>
                                <option value="Cần Thơ">Cần Thơ</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <select class="form-select" v-model="district">
                                <option disabled selected>Chọn quận/huyện</option>
                                <option value="Quận 1">Quận 1</option>
                                <option value="Quận 3">Quận 3</option>
                                <option value="Quận 7">Quận 7</option>
                                <option value="Quận Thủ Đức">Quận Thủ Đức</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <select class="form-select" v-model="ward">
                                <option disabled selected>Chọn phường xã</option>
                                <option value="Phường Bến Nghé">Phường Bến Nghé</option>
                                <option value="Phường Đa Kao">Phường Đa Kao</option>
                                <option value="Phường Tân Định">Phường Tân Định</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <input type="text" class="form-control" v-model="address"
                                placeholder="Nhập tên đường/ toà nhà/ số nhà" />
                        </div>
                    </div>

                    <div class="form-check form-switch mt-4">
                        <label class="form-check-label fw-semibold">Xuất hóa đơn điện tử</label>
                        <input class="form-check-input" type="checkbox" v-model="useEInvoice" />
                    </div>

                    <div class="mt-4 w-50">
                        <label class="form-label fw-semibold">Phương thức thanh toán</label>
                        <select class="form-select" v-model="paymentMethod">
                            <option value="COD">Thanh toán khi nhận hàng</option>
                            <option value="BANK_TRANSFER">Chuyển khoản ngân hàng</option>
                            <option value="MOMO">Ví điện tử (MoMo)</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Tổng kết -->
            <div class="col-lg-4 mt-4 mt-lg-0">
                <div class="card p-3 rounded-4 shadow-sm">
                    <button class="btn btn-light d-flex justify-content-between align-items-center mb-3">
                        <span><i class="bi bi-percent text-danger me-2"></i>Chọn hoặc nhập ưu đãi</span>
                        <i class="bi bi-chevron-right"></i>
                    </button>

                    <h6 class="fw-bold">Thông tin đơn hàng</h6>
                    <div class="d-flex justify-content-between py-2">
                        <span>Tổng tiền</span>
                        <span class="text-danger fw-bold">{{ formatPrice(totalPrice) }} đ</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-top">
                        <span>Tổng khuyến mãi</span>
                        <span>0 đ</span>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-top fw-bold">
                        <span>Cần thanh toán</span>
                        <span class="text-danger fs-5">{{ formatPrice(totalPrice) }} đ</span>
                    </div>

                    <button class="btn btn-primary w-100 mt-3" @click="submitOrder" :disabled="isProcessing">
                        <span v-if="isProcessing" class="spinner-border spinner-border-sm me-2"></span>
                        {{ isProcessing ? 'Đang xử lý...' : 'Thanh toán' }}
                    </button>

                    <!-- Hiển thị kết quả thanh toán MoMo -->
                    <div v-if="payUrl" class="mt-3">
                        <div class="alert alert-success">
                            <h6>✅ Tạo thanh toán MoMo thành công!</h6>
                            <p class="mb-2">Mã đơn hàng: <strong>{{ orderId }}</strong></p>
                        </div>
                        <a :href="payUrl" target="_blank" class="btn btn-outline-primary w-100 mb-2">
                            <i class="bi bi-wallet2 me-2"></i>Thanh toán qua MoMo
                        </a>
                        <div v-if="qrCodeUrl" class="text-center mt-3">
                            <p class="fw-semibold">Hoặc quét mã QR:</p>
                            <qrcode-vue :value="qrCodeUrl" :size="200" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Thông tin cam kết -->
    <div class="row text-center mt-5">
        <div v-for="(info, index) in guarantees" :key="index" class="col-6 col-md-3 mb-3">
            <div class="text-danger fs-3">
                <i :class="info.icon"></i>
            </div>
            <div class="fw-bold">{{ info.title }}</div>
            <div>{{ info.subtitle }}</div>
        </div>
    </div>
</template>

<script>
import QrcodeVue from 'qrcode.vue';
import { taoHoaDon } from '@/api';

export default {
    name: 'ThanhToan',
    components: {
        QrcodeVue
    },
    data() {
        return {
            cart: [],
            receiverName: '',
            phone: '',
            city: '',
            district: '',
            ward: '',
            address: '',
            useEInvoice: false,
            paymentMethod: 'COD',
            payUrl: '',
            qrCodeUrl: '',
            orderId: '',
            isProcessing: false,
            guarantees: [
                {
                    icon: 'bi bi-bookmark-fill',
                    title: 'Thương hiệu đảm bảo',
                    subtitle: 'Nhập khẩu, bảo hành chính hãng'
                },
                {
                    icon: 'bi bi-house-door-fill',
                    title: 'Giao hàng tận nhà',
                    subtitle: 'Tại 63 tỉnh thành'
                },
                {
                    icon: 'bi bi-check-square-fill',
                    title: 'Sản phẩm chất lượng',
                    subtitle: 'Đảm bảo tương thích và độ bền cao'
                },
                {
                    icon: 'bi bi-arrow-repeat',
                    title: 'Đổi trả dễ dàng',
                    subtitle: 'Theo chính sách đổi trả tại FPT Shop'
                }
            ]
        };
    },
    computed: {
        totalPrice() {
            return this.cart.reduce((total, item) => {
                const price = item.price || item.donGia || 0;
                const quantity = item.quantity || item.soLuong || 0;
                return total + (price * quantity);
            }, 0);
        },
        selectedQuantity() {
            return this.cart.reduce((sum, item) => {
                const quantity = item.quantity || item.soLuong || 0;
                return sum + quantity;
            }, 0);
        }
    },
    methods: {
        formatPrice(val) {
            return Number(val || 0).toLocaleString('vi-VN');
        },
        
        async submitOrder() {
            if (!this.receiverName || !this.phone || !this.city || !this.district || !this.ward || !this.address) {
                alert('Vui lòng điền đầy đủ thông tin nhận hàng.');
                return;
            }

            this.isProcessing = true;

            try {
                // Chuẩn bị dữ liệu đơn hàng
                const orderData = {
                    phuongThucThanhToan: this.paymentMethod,
                    tongTien: this.totalPrice,
                    diaChiGiaoHang: `${this.address}, ${this.ward}, ${this.district}, ${this.city}`,
                    ghiChu: `Người nhận: ${this.receiverName}, SĐT: ${this.phone}${this.useEInvoice ? ', Xuất hóa đơn điện tử' : ''}`,
                    danhSachSanPham: this.cart.map(item => ({
                        sanPhamId: item.sanPhamId || item.id,
                        soLuong: item.quantity || item.soLuong,
                        donGia: item.price || item.donGia
                    }))
                };

                console.log('📤 Gửi dữ liệu đơn hàng:', orderData);

                const response = await taoHoaDon(orderData);
                console.log('📥 Phản hồi từ server:', response.data);

                if (response.data.success) {
                    if (this.paymentMethod === 'MOMO') {
                        // Xử lý thanh toán MoMo
                        this.payUrl = response.data.payUrl;
                        this.qrCodeUrl = response.data.qrCodeUrl;
                        this.orderId = response.data.orderId;

                        if (this.payUrl) {
                            // Xóa giỏ hàng local
                            localStorage.removeItem('selectedCart');
                            localStorage.removeItem('cart');
                            
                            alert('✅ Tạo yêu cầu thanh toán MoMo thành công!\n\nVui lòng nhấn vào nút "Thanh toán qua MoMo" hoặc quét mã QR để hoàn tất thanh toán.');
                        }
                    } else {
                        // Thanh toán COD
                        alert(`✅ Đặt hàng thành công!
                        
🏷️ Thông tin đơn hàng:
• Tên: ${this.receiverName}
• SĐT: ${this.phone}
• Địa chỉ: ${this.address}, ${this.ward}, ${this.district}, ${this.city}
• Hóa đơn điện tử: ${this.useEInvoice ? 'Có' : 'Không'}
• Thanh toán: ${this.paymentMethod === 'COD' ? 'Khi nhận hàng' : 'Chuyển khoản'}
• Tổng tiền: ${this.formatPrice(this.totalPrice)} đ

Cảm ơn bạn đã mua hàng! 🎉`);

                        // Xóa giỏ hàng và chuyển về trang chủ
                        localStorage.removeItem('selectedCart');
                        localStorage.removeItem('cart');
                        this.$router.push('/');
                    }
                } else {
                    alert('❌ Lỗi: ' + response.data.message);
                }

            } catch (error) {
                console.error('❌ Lỗi khi tạo đơn hàng:', error);
                
                if (error.response?.status === 401) {
                    alert('⚠️ Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
                    this.$router.push('/dangnhap');
                } else {
                    alert('❌ Không thể tạo đơn hàng. Vui lòng thử lại sau.\n\nLỗi: ' + (error.response?.data?.message || error.message));
                }
            } finally {
                this.isProcessing = false;
            }
        }
    },
    
    mounted() {
        // Lấy danh sách sản phẩm đã chọn từ localStorage
        const selectedCart = localStorage.getItem('selectedCart');
        if (selectedCart) {
            try {
                this.cart = JSON.parse(selectedCart);
                console.log('🛒 Giỏ hàng được tải:', this.cart);
            } catch (e) {
                console.error('❌ Không thể parse danh sách sản phẩm đã chọn:', e);
                alert('Lỗi tải giỏ hàng. Vui lòng quay lại giỏ hàng và thử lại.');
                this.$router.push('/giohang');
            }
        } else {
            alert('Không có sản phẩm nào được chọn. Vui lòng quay lại giỏ hàng.');
            this.$router.push('/giohang');
        }
    }
};
</script>

<style scoped>
.spinner-border-sm {
    width: 1rem;
    height: 1rem;
}

.alert {
    border-radius: 0.5rem;
}

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}
</style>