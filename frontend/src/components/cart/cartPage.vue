<template>
  <!-- Shopping Cart Section -->
  <section class="shopping-cart spad">
    <div class="container">
      <div class="row">
        <!-- Cart Items -->
        <div class="col-lg-8">
          <div class="shopping__cart__table">
            <table>
              <thead>
              <tr>
                <th>Product</th>
                <th>Quantity</th>
                <th>Total</th>
                <th></th>
              </tr>
              </thead>
              <tbody>
              <!-- Nếu giỏ hàng trống -->
              <tr v-if="cart.length === 0">
                <td colspan="4" style="text-align: center; padding: 20px; color: gray;">
                  Giỏ hàng của bạn đang trống.
                </td>
              </tr>

              <!-- Danh sách sản phẩm -->
              <tr v-for="item in cart" :key="item.id">
                <td class="product__cart__item">
                  <div class="product__cart__item__pic">
                    <img
                        :src="getDefaultImage(item.variation_id.images)"
                        alt="Product"
                        style="width: 80px; height: 80px; object-fit: cover;"
                    />
                  </div>
                  <div class="product__cart__item__text">
                    <h6>{{ item.variation_id.name }}</h6>
                    <h5>{{ formatCurrency(item.variation_id.price) }}</h5>
                  </div>
                </td>

                <td class="quantity__item">
                  <div class="quantity">
                    <div class="pro-qty-2">
                      <input
                          type="number"
                          :value="item.quantity"
                          min="1"
                          @change="updateQuantity(item.id, $event.target.value)"
                      />
                    </div>
                  </div>
                </td>

                <td class="cart__price">
                  {{ formatCurrency(item.quantity * item.variation_id.price) }}
                </td>

                <td class="cart__close">
                  <i class="fa fa-close" @click="removeFromCart(item.id)"></i>
                </td>
              </tr>
              </tbody>
            </table>
          </div>

          <!-- Continue Shopping -->
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-6">
              <div class="continue__btn">
                <a href="/product">Tiếp tục mua sắm</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Cart Summary -->
        <div class="col-lg-4">
          <div class="cart__total">
            <h6>Cart total</h6>
            <ul>
              <li>Subtotal <span>{{ formatCurrency(totalPrice) }}</span></li>
              <li>Total <span>{{ formatCurrency(totalPrice) }}</span></li>
            </ul>
            <a
                v-if="cart.length > 0"
                @click="payment"
                class="primary-btn"
                style="cursor: pointer;"
            >Proceed to checkout</a>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import axios from "axios";
import { ref, onMounted } from "vue";
import Cookies from "js-cookie";
import { useRoute } from "vue-router";
import { useUser } from "@/components/composables/useUser";

export default {
  setup() {
    const {getCart} = useUser();
    const cart = ref([]);
    const totalPrice = ref(0);
    const apiUrl = "http://localhost:8080/api/v1/cart";
    const route = useRoute();
    const token = Cookies.get("authToken");
    const customerId = route.query.userId;

    const getDefaultImage = (images) => {
      if (!images || images.length === 0) return "default-image.jpg";
      const defaultImage = images;
      return defaultImage
          ? `http://localhost:8080/upload/images/${defaultImage.cd_Images}`
          : "default-image.jpg";
    };

    const payment = () => {
      const data = JSON.stringify(cart.value);
      try {
        sessionStorage.removeItem("cart");
        sessionStorage.setItem("cart", data);
      } catch (e) {
        console.error("Lỗi khi set cookie:", e);
      }
      window.location.href = "/pay";
    };

    const getCarts = async () => {
      console.log("Fetching cart for customer ID:", customerId);
      try {
        const response = await axios.get(`${apiUrl}/findall/${customerId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        cart.value = response.data;
        calculateTotal();
      } catch (error) {
        console.error("Lỗi khi lấy giỏ hàng:", error);
      }
    };

    const calculateTotal = () => {
      totalPrice.value = cart.value.reduce((total, item) => {
        return total + item.quantity * item.variation_id.price;
      }, 0);
    };

    const updateQuantity = async (cartItemId, newQuantity) => {
      newQuantity = parseInt(newQuantity);
      if (isNaN(newQuantity) || newQuantity <= 0) {
        alert("Số lượng không hợp lệ!");
        return;
      }
      try {
        const response = await axios.post(
            `${apiUrl}/editquantity/${cartItemId}/${newQuantity}`
        );
        if (response.status === 200) {
          await getCart();
          await getCarts();
          await useUser();
          // window.location.reload();
        }
      } catch (error) {
        console.error("Lỗi khi cập nhật số lượng:", error);
        if (error.response.data === "Not enough stock") {
          alert("Vượt quá số lượng sản phẩm còn lại!");
        }
      }
    };

    const removeFromCart = async (cartItemId) => {
      try {
        const response = await axios.get(`${apiUrl}/remove/${cartItemId}`);
        if (response.status === 200) {
          getCarts();
        }
      } catch (error) {
        console.error("Lỗi khi xóa sản phẩm:", error);
      }
    };

    const formatCurrency = (value) => {
      return value.toLocaleString("vi-VN") + " ₫";
    };

    onMounted(() => {
      getCarts();
    });

    return {
      cart,
      totalPrice,
      getDefaultImage,
      payment,
      updateQuantity,
      removeFromCart,
      formatCurrency,
    };
  },
};
</script>
 <style>
 /* Breadcrumb */
 .breadcrumb-option {
   background: #f5f5f5;
   padding: 20px 0;
   margin-bottom: 30px;
 }
 .breadcrumb__text h4 {
   font-size: 22px;
   font-weight: 600;
   margin-bottom: 8px;
 }
 .breadcrumb__links a {
   color: #666;
   margin-right: 10px;
   font-size: 14px;
   text-decoration: none;
 }
 .breadcrumb__links a:hover {
   color: #ff6f61;
 }
 .breadcrumb__links span {
   color: #333;
   font-weight: 500;
 }

 /* Shopping cart table */
 .shopping__cart__table {
   border: 1px solid #eee;
   border-radius: 8px;
   overflow: hidden;
 }
 .shopping__cart__table table {
   width: 100%;
   text-align: left;
   border-collapse: collapse;
 }
 .shopping__cart__table thead {
   background: #f8f8f8;
 }
 .shopping__cart__table th {
   padding: 15px;
   font-size: 15px;
   color: #333;
   font-weight: 600;
   border-bottom: 1px solid #e6e6e6;
 }
 .shopping__cart__table td {
   padding: 15px;
   vertical-align: middle;
   border-bottom: 1px solid #f0f0f0;
 }

 /* Product column */
 .product__cart__item {
   display: flex;
   align-items: center;
 }
 .product__cart__item__pic img {
   border-radius: 6px;
   border: 1px solid #ddd;
   margin-right: 15px;
 }
 .product__cart__item__text h6 {
   font-size: 15px;
   margin: 0;
   font-weight: 500;
 }
 .product__cart__item__text h5 {
   color: #ff6f61;
   font-size: 14px;
   margin-top: 6px;
 }

 /* Quantity */
 .quantity input {
   width: 60px;
   height: 36px;
   text-align: center;
   border: 1px solid #ddd;
   border-radius: 4px;
 }
 .quantity input:focus {
   outline: none;
   border-color: #ff6f61;
 }

 /* Price + delete */
 .cart__price {
   font-weight: 500;
   color: #333;
 }
 .cart__close {
   cursor: pointer;
   color: #999;
   transition: 0.2s;
 }
 .cart__close:hover {
   color: #ff6f61;
 }

 /* Continue shopping */
 .continue__btn a {
   display: inline-block;
   padding: 10px 18px;
   border: 1px solid #ff6f61;
   border-radius: 4px;
   font-size: 14px;
   color: #ff6f61;
   text-decoration: none;
   transition: 0.3s;
 }
 .continue__btn a:hover {
   background: #ff6f61;
   color: #fff;
 }

 /* Cart total box */
 .cart__total {
   background: #f9f9f9;
   padding: 20px;
   border: 1px solid #eee;
   border-radius: 8px;
 }
 .cart__total h6 {
   font-weight: 600;
   margin-bottom: 20px;
 }
 .cart__total ul {
   list-style: none;
   padding: 0;
   margin: 0 0 20px;
 }
 .cart__total ul li {
   display: flex;
   justify-content: space-between;
   font-size: 15px;
   margin-bottom: 10px;
 }
 .cart__total ul li span {
   font-weight: 600;
   color: #333;
 }
 .primary-btn {
   display: block;
   text-align: center;
   background: #FFC7ED;
   color: black !important;
   padding: 12px;
   border-radius: 6px;
   font-weight: 500;
   text-decoration: none;
   transition: 0.3s;
 }
 .primary-btn:hover {
   background: #e85a4f;
   color: #fff !important;
 }

 /* Responsive */
 @media (max-width: 768px) {
   .product__cart__item {
     flex-direction: column;
     align-items: flex-start;
   }
   .product__cart__item__pic img {
     margin-bottom: 10px;
   }
 }

 </style>
