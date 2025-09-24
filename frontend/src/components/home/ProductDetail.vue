<template>
  <section class="shop-details">
    <div class="product__details__pic">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="product__details__breadcrumb">
              <a href="/">Home</a>
              <a href="/product">Shop</a>
              <span>Product Details</span>
            </div>
          </div>
        </div>
        <div class="row" v-if="selectedProduct">
          <div class="col-lg-3 col-md-3">
            <ul class="nav nav-tabs" role="tablist">
              <li
                  class="nav-item"
                  v-for="(image) in selectedProduct.images"
                  :key="image.id"
              >
                <a
                    class="nav-link"
                    :class="{ active: selectedImage === image.cd_Images }"
                    data-toggle="tab"
                    href="#"
                    role="tab"
                    @click.prevent="changeImg(image.cd_Images)"
                >
                  <div
                      class="product__thumb__pic"
                      :style="{ backgroundImage: `url(http://localhost:8080/upload/images/${image.cd_Images})`, backgroundSize: 'cover', width: '80px', height: '80px' }"
                  ></div>
                </a>
              </li>
            </ul>
          </div>
          <div class="col-lg-6 col-md-9">
            <div class="tab-content">
              <div class="tab-pane active" role="tabpanel">
                <div class="product__details__pic__item" style="position:relative;">
                  <img
                      :src="`http://localhost:8080/upload/images/${selectedImage}`"
                      alt="Ảnh chính"
                      style="width:100%;max-height:400px;object-fit:contain;"
                  />
                </div>
              </div>
            </div>
          </div>

          <!--          container nhỏ-->
          <div class="product__details__content">
            <div class="container">
              <div class="row d-flex justify-content-center">
                <div class="col-lg-8">
                  <div class="product__details__text">
                    <h4>{{ selectedProduct.name }}</h4>
                    <h3>
                      {{ formatCurrency(activeVariation?.price || 0) }}
                    </h3>
                    <p>{{ activeVariation?.description || selectedProduct.description }}</p>
                    <div class="product__details__option">
                      <div class="product__details__option__size"
                           v-if="selectedProduct.variations && selectedProduct.variations.length">
                        <span>Biến thể:</span>
                        <label
                            v-for="v in selectedProduct.variations"
                            :key="v.id"
                            :class="{ active: activeVariation?.id === v.id }"
                            style="margin-right:8px;cursor:pointer;"
                        >
                          {{ v.name }}
                          <input
                              type="radio"
                              :id="'size-' + v.id"
                              :checked="activeVariation?.id === v.id"
                              @change="selectVariation(v)"
                          />
                        </label>
                      </div>
                      <div class="product__details__option__size"
                           v-if="selectedProduct.variations && selectedProduct.variations.length">
                        <span>Size:</span>
                        <label
                            v-for="v in selectedProduct.variations"
                            :key="v.id"
                            :class="{ active: activeVariation?.id === v.id }"
                            style="margin-right:8px;cursor:pointer;"
                        >
                          {{ v.size }}
                          <input
                              type="radio"
                              :id="'size-' + v.id"
                              :checked="activeVariation?.id === v.id"
                              @change="selectVariation(v)"
                          />
                        </label>
                      </div>
                      <div class="product__details__option__color"
                           v-if="selectedProduct.variations && selectedProduct.variations.length">
                        <span>Color:</span>
                        <label
                            v-for="v in selectedProduct.variations"
                            :key="v.id"
                            :class="{ active: activeVariation?.id === v.id }"
                            class="color-swatch"
                            @click="selectVariation(v)"
                            :style="{
                              backgroundColor: v.color,
                              border: activeVariation?.id === v.id ? '2px solid #000' : '1px solid #ccc',
                              width: '25px',
                              height: '25px',
                              borderRadius: '50%',
                              display: 'inline-block',
                              marginLeft: '8px',
                              cursor: 'pointer'
                            }"
                        ></label>
                      </div>

                    </div>
                    <div class="product__details__cart__option">
                      <div class="quantity">
                        <div class="pro-qty" style="display:flex;align-items:center;">
                          <input type="button" value="-" class="control" @click="changeQuantity(-1)"/>
                          <input type="text" v-model="quantity" class="text-input"
                                 style="width:40px;text-align:center;"/>
                          <input type="button" value="+" class="control" @click="changeQuantity(1)"/>
                        </div>
                      </div>
                      <button class="primary-btn" @click="addToCart" :disabled="!activeVariation?.status">add to cart
                      </button>
                    </div>
                    <div class="product__details__last__option">
                      <ul>
                        <li><span>SKU:</span> {{ activeVariation?.sku || selectedProduct.id }}</li>
                        <li><span>Categories:</span> {{ selectedProduct.categoryID?.name }}</li>
                        <li><span>Tag:</span> Clothes, Fashion</li>
                      </ul>
                      <div class="status-product">
                        Trạng thái:
                        <b v-if="activeVariation?.status" class="text-success">Còn hàng</b>
                        <b v-else class="text-danger">Hết hàng</b>
                      </div>
                      <div>
                        Đã bán: {{ activeVariation?.sold || 0 }}
                      </div>
                      <div>
                        Số lượng còn lại: {{ activeVariation?.quantity || 0 }}
                      </div>
                    </div>
                    <div class="product__shopnow mt-2">
                      <button @click="payment" class="shopnow" style="color: #9a5252"
                              :disabled="!activeVariation?.status">
                        Mua ngay
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row">
                <div class="col-lg-12">
                  <div class="product__details__tab">
                    <ul class="nav nav-tabs" role="tablist">
                      <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#tabs-5" role="tab">Description</a>
                      </li>
                    </ul>
                    <div class="tab-content">
                      <div class="tab-pane active" id="tabs-5" role="tabpanel">
                        <div class="product__details__tab__content">
                          <p class="note">{{ selectedProduct?.description }}</p>
                          <div class="product__details__tab__content__item">
                            <h5>Products Infomation</h5>
                            <p>{{ activeVariation?.description || selectedProduct?.description }}</p>
                          </div>
                          <div class="product__details__tab__content__item">
                            <h5>Material used</h5>
                            <p>{{ activeVariation?.material || 'N/A' }}</p>
                          </div>
                        </div>
                      </div>
                      <div class="tab-pane" id="tabs-6" role="tabpanel">
                        <div class="product__details__tab__content">
                          <div class="product__details__tab__content__item">
                            <h5>Products Infomation</h5>
                            <p>{{ activeVariation?.description || selectedProduct?.description }}</p>
                          </div>
                          <div class="product__details__tab__content__item">
                            <h5>Material used</h5>
                            <p>{{ activeVariation?.material || 'N/A' }}</p>
                          </div>
                        </div>
                      </div>
                      <div class="tab-pane" id="tabs-7" role="tabpanel">
                        <div class="product__details__tab__content">
                          <p class="note">{{ selectedProduct?.description }}</p>
                          <div class="product__details__tab__content__item">
                            <h5>Products Infomation</h5>
                            <p>{{ activeVariation?.description || selectedProduct?.description }}</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div v-else>
          <p>Loading product details...</p>
        </div>
      </div>
    </div>
    <div class="product__details__content">
      <div class="container">
        <!-- Sản phẩm bán chạy -->
        <div class="product__relateto">
          <div class="container">
            <h3 class="product__relateto-heading">Sản phẩm bán chạy</h3>
            <div class="row">
              <div class="col-lg-3 col-md-6 col-sm-12 mb-20"
                   v-for="(v, index) in bestSellers"
                   :key="index"
                   style="margin-top: 20px">
                <a @click="openDetail(v.productID.id)" class="product__new-item">
                  <div class="card" style="width: 100%">
                    <div
                        class="product__item__pic set-bg"
                        :style="{ backgroundImage: `url('http://localhost:8080/upload/images/${v.images.cd_Images || 'default.png'}')` }"
                    >
                      <ul class="product__hover">
                        <li><a href="#"><img src="../../assets/img/icon/heart.png" alt=""/></a></li>
                        <li>
                          <a href="#"><img src="../../assets/img/icon/compare.png" alt=""/> <span>Compare</span></a>
                        </li>
                        <li><a href="#"><img src="../../assets/img/icon/search.png" @click="openDetail(v.productID.id)"></a>
                        </li>
                      </ul>
                    </div>
                    <div class="card-body">
                      <h5 class="card-title custom__name-product">
                        {{ v.name }}
                      </h5>
                      <div class="product__price">
                        <p class="card-text brand-color">{{ v.productID.brandID.name }}</p>
                      </div>
                      <div class="product__price">
                        <p class="card-text price-color product__price-new">{{ formatCurrency(v.price) }} VND</p>
                      </div>
                      <div class="status-product">
                        Trạng thái:
                        <b v-if="v.status" class="text-success">Còn hàng</b>
                        <b v-else class="text-danger">Hết hàng</b>
                      </div>
                      <div class="home-product-item__action">
                        <span class="home-product-item__sold">{{ v.sold }} đã bán</span>
                      </div>
                    </div>
                  </div>
                </a>
              </div>
            </div>
            <div class="see-more-container">
              <a href="/product" class="see-more-btn">Xem thêm</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import axios from "axios";
import {ref, onMounted} from "vue";
import Cookies from "js-cookie";
import {useRouter, useRoute} from "vue-router";
import {useUser} from '@/components/composables/useUser';

export default {
  setup() {
    const router = useRouter();
    const route = useRoute();
    const selectedProduct = ref(null);
    const selectedImage = ref("");
    const quantity = ref(1);
    const activeVariation = ref({});
    const variations = ref(null);

    const payment = () => {
      if (quantity.value > (activeVariation.value?.quantity || 0)) {
        alert("Số lượng mua vượt quá số lượng còn lại!");
        return;
      }
      sessionStorage.removeItem("cart")
      try {
        let cart = JSON.parse(sessionStorage.getItem("cart")) || [];
        const orderItem = {
          customer_id: {},
          variation_id: activeVariation.value,
          id: Date.now(),
          status: 0,
          quantity: quantity.value,
        };
        cart.push(orderItem);
        sessionStorage.setItem("cart", JSON.stringify(cart));
        window.location.href = "/pay";
      } catch (e) {
        console.error("Lỗi khi set sessionStorage:", e);
      }
    };

    const getProductDetail = async () => {
      const id = route.params.id;
      const api = `http://localhost:8080/MiniatureCrafts/product/findByID/${id}`;
      try {
        const response = await axios.get(api);
        selectedProduct.value = response.data;
        const defaultImage = selectedProduct.value.images.find((img) => img.set_Default);
        selectedImage.value = defaultImage
            ? defaultImage.cd_Images
            : selectedProduct.value.images[0]?.cd_Images;
        if (selectedProduct.value.variations && selectedProduct.value.variations.length > 0) {
          selectVariation(selectedProduct.value.variations[0]);
        }
      } catch (error) {
        console.error("Lỗi khi lấy chi tiết s���n phẩm:", error);
      }
    };

    function selectVariation(variation) {
      activeVariation.value = variation;
      if (variation.images && variation.images.cd_Images) {
        selectedImage.value = variation.images.cd_Images;
      } else {
        const defaultImage = selectedProduct.value.images.find((img) => img.set_Default);
        selectedImage.value = defaultImage
            ? defaultImage.cd_Images
            : selectedProduct.value.images[0]?.cd_Images;
      }
    }

    const changeImg = (imageName) => {
      selectedImage.value = imageName;
    };

    const changeQuantity = (value) => {
      const newQuantity = quantity.value + value;
      if (newQuantity > 0 && newQuantity <= (activeVariation.value?.quantity || 0)) {
        quantity.value = newQuantity;
      }
    };

    const addToCart = async () => {
      const customerCookie = Cookies.get("customers");
      if (!customerCookie) {
        alert("Vui lòng đăng nhập!");
        window.location.href = '/login';
        return;
      }
      const customer = JSON.parse(customerCookie);
      const cartItem = {
        customer_id: {
          id: customer.id,
        },
        variation_id: {
          id: activeVariation.value.id,
        },
        quantity: quantity.value,
      };
      try {
        const response = await axios.post("http://localhost:8080/api/v1/cart/addtocart", cartItem);
        if (response.status === 200) {
          alert("Thêm sản phẩm vào giỏ hàng thành công!");
          await useUser();
          window.location.reload();
        }
      } catch (error) {
        alert("Hiện đã hết hàng, không thể thêm sản phẩm vào giỏ hàng!");
      }
    };

    const openDetail = (id) => {
      sessionStorage.setItem("idvariation", id);
      router.push({path: `/product/${id}`}).then(() => {
        location.reload();
      });
    };


    const getProducts = async () => {
      try {
        const response = await axios.get(
            "http://localhost:8080/MiniatureCrafts/bestseller?page=2&size=4"
        );
        variations.value = response.data.content || [];
        console.log(variations.value)
      } catch (error) {
        console.error("Lỗi khi lấy danh sách sản phẩm:", error);
      }
    };

    function formatCurrency(value) {
      if (!value) return "0 ₫";
      return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + " ₫";
    }

    onMounted(() => {
      getProductDetail();
      getProducts();
    });

    return {
      payment,
      selectVariation,
      openDetail,
      bestSellers: variations,
      formatCurrency,
      selectedProduct,
      selectedImage,
      quantity,
      changeImg,
      changeQuantity,
      getProductDetail,
      addToCart,
      activeVariation,
    };
  },
};
</script>

<style>
.container {
  width: 100%;
}

.product__thumb__pic {
  border: 1px solid #eee;
  margin-bottom: 10px;
  border-radius: 6px;
}

.product__details__pic__item img {
  border-radius: 8px;
}

.product__details__option__size label.active {
  font-weight: bold;
  border-bottom: 2px solid #007bff;
}

/* Always center the product__details__content on the screen */
.product__details__content {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  min-height: 100vh;
  width: 100vw;
  box-sizing: border-box;
}
</style>
