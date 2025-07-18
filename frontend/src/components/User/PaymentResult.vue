<template>
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-5 text-center">
                        <!-- Thành công -->
                        <div v-if="isSuccess" class="text-success">
                            <div class="mb-4">
                                <i class="bi bi-check-circle-fill" style="font-size: 4rem;"></i>
                            </div>
                            <h2 class="text-success mb-3">🎉 Thanh toán thành công!</h2>
                            <div class="alert alert-success text-start">
                                <h5>📋 Thông tin đơn hàng:</h5>
                                <p class="mb-1"><strong>Mã đơn hàng:</strong> {{ orderId }}</p>
                                <p class="mb-1"><strong>Số tiền:</strong> {{ formatPrice(amount) }} đ</p>
                                <p class="mb-1"><strong>Thời gian:</strong> {{ formatDateTime(new Date()) }}</p>
                                <p class="mb-0"><strong>Trạng thái:</strong> <span class="badge bg-success">Đã thanh toán</span></p>
                            </div>
                            <p class="text-muted mb-4">
                                Cảm ơn bạn đã mua hàng! Đơn hàng của bạn đang được xử lý và sẽ được giao sớm nhất có thể.
                            </p>
                        </div>

                        <!-- Thất bại -->
                        <div v-else class="text-danger">
                            <div class="mb-4">
                                <i class="bi bi-x-circle-fill" style="font-size: 4rem;"></i>
                            </div>
                            <h2 class="text-danger mb-3">❌ Thanh toán thất bại!</h2>
                            <div class="alert alert-danger text-start">
                                <h5>⚠️ Thông tin lỗi:</h5>
                                <p class="mb-1"><strong>Mã đơn hàng:</strong> {{ orderId || 'Không xác định' }}</p>
                                <p class="mb-1"><strong>Lý do:</strong> {{ message || 'Không có thông tin chi tiết' }}</p>
                                <p class="mb-0"><strong>Trạng thái:</strong> <span class="badge bg-danger">Thất bại</span></p>
                            </div>
                            <p class="text-muted mb-4">
                                Đừng lo lắng! Bạn có thể thử lại hoặc chọn phương thức thanh toán khác.
                            </p>
                        </div>

                        <!-- Nút hành động -->
                        <div class="d-flex gap-3 justify-content-center flex-wrap">
                            <RouterLink to="/" class="btn btn-primary btn-lg px-4">
                                <i class="bi bi-house-fill me-2"></i>Về trang chủ
                            </RouterLink>
                            
                            <RouterLink v-if="!isSuccess" to="/giohang" class="btn btn-outline-primary btn-lg px-4">
                                <i class="bi bi-cart-fill me-2"></i>Quay lại giỏ hàng
                            </RouterLink>
                            
                            <RouterLink v-if="isSuccess" to="/hoadon" class="btn btn-outline-success btn-lg px-4">
                                <i class="bi bi-receipt me-2"></i>Xem đơn hàng
                            </RouterLink>
                        </div>

                        <!-- Thông tin hỗ trợ -->
                        <div class="mt-5 pt-4 border-top">
                            <h6 class="text-muted mb-3">Cần hỗ trợ?</h6>
                            <div class="row text-center">
                                <div class="col-md-4">
                                    <i class="bi bi-telephone-fill text-primary fs-4"></i>
                                    <p class="small mt-2 mb-0">Hotline: <strong>1900-1234</strong></p>
                                </div>
                                <div class="col-md-4">
                                    <i class="bi bi-envelope-fill text-primary fs-4"></i>
                                    <p class="small mt-2 mb-0">Email: <strong>support@shop.com</strong></p>
                                </div>
                                <div class="col-md-4">
                                    <i class="bi bi-chat-dots-fill text-primary fs-4"></i>
                                    <p class="small mt-2 mb-0">Chat: <strong>24/7</strong></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'PaymentResult',
    data() {
        return {
            orderId: '',
            amount: '',
            resultCode: '',
            message: '',
            isSuccess: false
        };
    },
    computed: {
        
    },
    mounted() {
        // Lấy tham số từ query string
        const query = this.$route.query;
        this.orderId = query.orderId || '';
        this.amount = query.amount || '';
        this.resultCode = query.resultCode || '';
        this.message = query.message || 'Không có thông tin chi tiết';
        
        // Xác định trạng thái thành công
        this.isSuccess = this.resultCode === '0' || this.resultCode === 0;
        
        console.log('🔍 Payment Result Data:', {
            orderId: this.orderId,
            amount: this.amount,
            resultCode: this.resultCode,
            message: this.message,
            isSuccess: this.isSuccess
        });
    },
    methods: {
        formatPrice(val) {
            return Number(val || 0).toLocaleString('vi-VN');
        },
        formatDateTime(date) {
            return new Intl.DateTimeFormat('vi-VN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            }).format(date);
        }
    }
};
</script>

<style scoped>
.card {
    transition: transform 0.2s ease-in-out;
}

.card:hover {
    transform: translateY(-2px);
}

.btn {
    transition: all 0.2s ease-in-out;
}

.btn:hover {
    transform: translateY(-1px);
}

.alert {
    border-radius: 0.75rem;
}

.badge {
    font-size: 0.9em;
}
</style>