<template>
  <div>

    <!-- Banner Section -->
    <section class="banner spad">
      <div class="container">
        <div class="row">
          <div class="col-lg-7 offset-lg-4">
            <div class="banner__item">
              <div class="banner__item__pic">
                <img src="../assets/img/banner/banner-1.jpg" alt="" />
              </div>
              <div class="banner__item__text">
                <h2>Clothing Collections 2025</h2>
                <a href="/product">Shop now</a>
              </div>
            </div>
          </div>
          <div class="col-lg-5">
            <div class="banner__item banner__item--middle">
              <div class="banner__item__pic">
                <img src="../assets/img/banner/banner-2.jpg" alt="" />
              </div>
              <div class="banner__item__text">
                <h2>Accessories</h2>
                <a href="#">Shop now</a>
              </div>
            </div>
          </div>
          <div class="col-lg-7">
            <div class="banner__item banner__item--last">
              <div class="banner__item__pic">
                <img src="../assets/img/banner/banner-3.jpg" alt="" />
              </div>
              <div class="banner__item__text">
                <h2>Shoes Spring 2025</h2>
                <a href="#">Shop now</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Product Section -->
    <section class="product spad">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <ul class="filter__controls">
              <li
                  :class="{ active: activeTab === 'newproduct' }"
                  @click="activeTab = 'newproduct'"
              >
                Sản phẩm mới cập nhật
              </li>
              <li
                  :class="{ active: activeTab === 'bestseller' }"
                  @click="activeTab = 'bestseller'"
              >
                Sản phẩm bán chạy
              </li>

            </ul>
          </div>
        </div>

        <div class="row product__filter">
          <!-- Best Sellers -->
          <template v-if="activeTab === 'bestseller'">
            <div
                v-for="(product, index) in bestSellers"
                :key="'best-' + index"
                class="col-lg-3 col-md-6 col-sm-6"
            >
              <div class="product__item">
                <div class="product__item__pic set-bg"
                     :style="{ backgroundImage: `url('http://localhost:8080/upload/images/${product.productID.defaultImage || 'default.png'}')` }">
                  <ul class="product__hover">
                    <li><a href="#"><img src="../assets/img/icon/heart.png" alt="" /></a></li>
                    <li>
                      <a href="#"><img src="../assets/img/icon/compare.png" alt="" /> <span>Compare</span></a>
                    </li>
                    <li><a href="#"><img src="../assets/img/icon/search.png" alt="" /></a></li>
                  </ul>
                </div>

                <div class="product__item__text">
                  <h6>{{ product.name }}</h6>
                  <a
                      href="#"
                      class="add-cart"
                      @click.prevent="openDetail(product.id)"
                  >+ Add To Cart</a>
                  <div class="rating">
                    <i v-for="i in 5" :key="i" class="fa fa-star-o"></i>
                  </div>
                  <h5>{{ formatCurrency(product.price) }}</h5>
                </div>
              </div>
            </div>
          </template>

          <!-- Top Sellers -->
          <template v-if="activeTab === 'newproduct'">
            <div
                v-for="(v, index) in variations"
                :key="'top-' + index"
                class="col-lg-3 col-md-6 col-sm-6"
            >
              <div class="product__item">
                <div
                    class="product__item__pic set-bg"
                    :style="{ backgroundImage: `url('http://localhost:8080/upload/images/${v.productID.defaultImage || 'default.png'}')` }"
                >
                  <ul class="product__hover">
                    <li><a href="#"><img src="../assets/img/icon/heart.png" alt="" /></a></li>
                    <li>
                      <a href="#"><img src="../assets/img/icon/compare.png" alt="" /> <span>Compare</span></a>
                    </li>
                    <li><a href="#"><img src="../assets/img/icon/search.png" @click="openDetail(v.productID.id)"></a></li>
                  </ul>
                </div>
                <div class="product__item__text">
                  <h6>{{ v.name }}</h6>
                  <a
                      href="#"
                      class="add-cart"
                      @click.prevent="openDetail(v.id)"
                  >+ Add To Cart</a>
                  <div class="rating">
                    <i v-for="i in 5" :key="i" class="fa fa-star-o"></i>
                  </div>
                  <h5>{{ formatCurrency(v.price) }}</h5>
                </div>
              </div>
            </div>
          </template>
        </div>
      </div>
    </section>


    <!-- Categories Section -->
    <section class="categories spad">
      <div class="container">
        <div class="row">
          <div class="col-lg-3">
            <div class="categories__text">
              <h2>
                Clothings Hot <br />
                <span>Shoe Collection</span> <br />
                Accessories
              </h2>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="categories__hot__deal">
              <img src="../assets/img/product-sale.png" alt="" />
              <div class="hot__deal__sticker">
                <span>Sale Of</span>
                <h5>$29.99</h5>
              </div>
            </div>
          </div>
          <div class="col-lg-4 offset-lg-1">
            <div class="categories__deal__countdown">
              <span>Deal Of The Week</span>
              <h2>Multi-pocket Chest Bag Black</h2>
              <div
                  class="categories__deal__countdown__timer"
                  id="countdown"
              >
                <div class="cd-item">
                  <span>3</span>
                  <p>Days</p>
                </div>
                <div class="cd-item">
                  <span>1</span>
                  <p>Hours</p>
                </div>
                <div class="cd-item">
                  <span>50</span>
                  <p>Minutes</p>
                </div>
                <div class="cd-item">
                  <span>18</span>
                  <p>Seconds</p>
                </div>
              </div>
              <a href="/product" class="primary-btn">Shop now</a>
            </div>
          </div>
        </div>
      </div>
    </section>

  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      variations: [],
      policies: [],
      bestSellers: [],
      topSellers: [],
      activeTab: "newproduct",
    };
  },
  mounted() {
    this.getProducts();
    this.getBestSellers();
    this.getTopSellers();
    this.setBgImages(); // Thêm dòng này để set background-image từ data-setbg
  },
  methods: {
    setBgImages() {
      // Tìm tất cả phần tử có class 'set-bg' và set background-image từ data-setbg
      this.$nextTick(() => {
        const elements = document.querySelectorAll('.set-bg');
        elements.forEach(el => {
          const bg = el.getAttribute('data-setbg');
          if (bg) {
            el.style.backgroundImage = `url('${bg}')`;
          }
        });
      });
    },
    formatCurrency(value) {
      const number = Number(value);
      return isNaN(number) ? "0 ₫" : number.toLocaleString("vi-VN") + " ₫";
    },
    openDetail(id) {
      sessionStorage.setItem("idvariation", id);
      this.$router.push({ path: `/product/${id}` });
    },
    processData(data) {
      return data.map((item) => {
        item.productID.defaultImage =
            item.images.cd_Images || "default.png";
        item.sold = item.sold || 0;
        return item;
      });
    },
    getProducts() {
      axios
          .get(`http://localhost:8080/MiniatureCrafts/new?page=0&size=8`)
          .then((response) => {
            this.variations = this.processData(response.data.content || []);
          });
    },
    getBestSellers() {
      axios
          .get(`http://localhost:8080/MiniatureCrafts/bestseller?page=1&size=8`)
          .then((response) => {
            const data = this.processData(response.data.content || []);
            this.bestSellers = data;
            console.log(response.data)
          })
          .catch((error) => {
            console.error("Lỗi khi lấy danh sách sản phẩm bán chạy:", error);
          });
    },
    getTopSellers() {
      axios
          .get(`http://localhost:8080/MiniatureCrafts/new?page=0&size=6`)
          .then((response) => {
            this.topSellers = this.processData(response.data.content || []);
          });
    },
  },
};
</script>
