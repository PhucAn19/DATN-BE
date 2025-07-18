@@ .. @@
 <script>
+import { themVaoGioHang, xemGioHang, capNhatGioHang, xoaKhoiGioHang } from '@/api';
+
 export default {
     name: 'ProductCart',
     data() {
         return {
             selectAll: false,
-            cart: []
+            cart: [],
+            isLoading: false
         };
     },
@@ .. @@
         formatPrice(val) {
             return val.toLocaleString('vi-VN');
         },
-        increaseQty(index) {
+        async increaseQty(index) {
             this.cart[index].quantity++;
-            this.saveCart();
+            await this.updateCartOnServer(index);
         },
-        decreaseQty(index) {
+        async decreaseQty(index) {
             if (this.cart[index].quantity > 1) {
                 this.cart[index].quantity--;
-                this.saveCart();
+                await this.updateCartOnServer(index);
             }
         },
-        removeItem(index) {
+        async removeItem(index) {
+            const item = this.cart[index];
+            try {
+                await xoaKhoiGioHang(item.sanPhamId || item.id);
+                this.cart.splice(index, 1);
+                this.saveCart();
+                alert('Đã xóa sản phẩm khỏi giỏ hàng');
+            } catch (error) {
+                console.error('Lỗi khi xóa sản phẩm:', error);
+                alert('Không thể xóa sản phẩm. Vui lòng thử lại.');
+            }
+        },
+        async updateCartOnServer(index) {
+            const item = this.cart[index];
+            try {
+                await capNhatGioHang({
+                    sanPhamId: item.sanPhamId || item.id,
+                    soLuong: item.quantity
+                });
+                this.saveCart();
+            } catch (error) {
+                console.error('Lỗi khi cập nhật giỏ hàng:', error);
+                // Revert lại số lượng cũ nếu lỗi
+                this.loadCart();
+            }
+        },
+        async loadCartFromServer() {
+            try {
+                this.isLoading = true;
+                const response = await xemGioHang();
+                if (response.data.danhSachSanPham) {
+                    this.cart = response.data.danhSachSanPham.map(item => ({
+                        ...item,
+                        selected: false,
+                        name: item.tenSanPham,
+                        price: item.donGia,
+                        image: item.anhGoc,
+                        variant: 'Mặc định'
+                    }));
+                    this.saveCart();
+                }
+            } catch (error) {
+                console.error('Lỗi khi tải giỏ hàng từ server:', error);
+                // Fallback to localStorage
+                this.loadCart();
+            } finally {
+                this.isLoading = false;
+            }
+        },
+        loadCart() {
+            const saved = localStorage.getItem('cart');
+            if (saved) {
+                try {
+                    this.cart = JSON.parse(saved);
+                } catch (e) {
+                    console.error('Không thể parse giỏ hàng:', e);
+                }
+            }
+        },
+        removeItemLocal(index) {
             this.cart.splice(index, 1);
             this.saveCart();
         },
@@ .. @@
             // Lưu các sản phẩm được chọn vào localStorage
             localStorage.setItem('selectedCart', JSON.stringify(selectedItems));

             // Kiểm tra đăng nhập
-            const user = JSON.parse(localStorage.getItem("user")) || JSON.parse(sessionStorage.getItem("user"));
-            if (user) {
+            // Kiểm tra session thông qua API
+            this.checkLoginAndProceed();
+        },
+        async checkLoginAndProceed() {
+            try {
+                const response = await fetch('http://localhost:8080/api/xacthuc/kiem-tra-phien', {
+                    credentials: 'include'
+                });
+                const data = await response.json();
+                
+                if (response.ok && data.message === 'Đã đăng nhập') {
+                    this.$router.push("/thanhtoan");
+                } else {
+                    alert('Vui lòng đăng nhập để tiếp tục thanh toán.');
+                    this.$router.push("/dangnhap");
+                }
+            } catch (error) {
+                console.error('Lỗi kiểm tra đăng nhập:', error);
                 this.$router.push("/thanhtoan");
-            } else {
-                this.$router.push("/dangnhap");
             }
         }
     },
@@ .. @@
     },
     mounted() {
-        const saved = localStorage.getItem('cart');
-        if (saved) {
-            try {
-                this.cart = JSON.parse(saved);
-            } catch (e) {
-                console.error('Không thể parse giỏ hàng:', e);
-            }
-        }
+        // Thử tải từ server trước, nếu không được thì dùng localStorage
+        this.loadCartFromServer();
     }
 };
 </script>