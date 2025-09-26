<template>
  <section class="shop spad">
    <div class="container">
      <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3">
          <div class="shop__sidebar">
            <div class="shop__sidebar__search">
              <form @submit.prevent="searchProducts(searchQuery, 0)">
                <input type="text" v-model="searchQuery" placeholder="Search..."/>
                <button type="submit"><span class="icon_search"></span></button>
              </form>
            </div>
            <div class="shop__sidebar__accordion">
              <div class="accordion" id="accordionExample">
                <!-- Categories -->
                <div class="card">
                  <div class="card-heading">
                    <a data-toggle="collapse" data-target="#collapseOne">Categories</a>
                  </div>
                  <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                    <div class="card-body">
                      <div class="shop__sidebar__categories">
                        <ul class="nice-scroll">
                          <li v-for="category in categories" :key="category.id">
                            <a href="#" @click.prevent="filterByCategory(category.id)">{{ category.name }}</a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- Brands -->
                <div class="card">
                  <div class="card-heading">
                    <a data-toggle="collapse" data-target="#collapseTwo">Branding</a>
                  </div>
                  <div id="collapseTwo" class="collapse show" data-parent="#accordionExample">
                    <div class="card-body">
                      <div class="shop__sidebar__brand">
                        <ul>
                          <li v-for="brand in brands" :key="brand.id">
                            <a href="#" @click.prevent="filterByBrands(brand.id)">{{ brand.name }}</a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- Price Filter -->
                <div class="card">
                  <div class="card-heading">
                    <a data-toggle="collapse" data-target="#collapseThree">Filter Price</a>
                  </div>
                  <div id="collapseThree" class="collapse show" data-parent="#accordionExample">
                    <div class="card-body">
                      <div class="shop__sidebar__price">
                        <ul>
                          <li v-for="priceRange in priceRanges" :key="priceRange.value">
                            <a href="#" @click.prevent="onPriceRangeClick(priceRange.value)">{{ priceRange.label }}</a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- Product Grid -->
        <div class="col-lg-9">
          <div class="shop__product__option">
            <div class="row">
              <div class="col-lg-6 col-md-6 col-sm-6">
                <div class="shop__product__option__left">
                  <p>Showing {{ currentPage }}–{{ pageSize }} of {{ totalProducts }} results</p>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-4 col-md-6 col-sm-6" v-for="v in all_variations" :key="v.id">
              <div class="product__item">
                <div class="product__item__pic set-bg"
                     :style="{ backgroundImage: `url(http://localhost:8080/upload/images/${v.images.cd_Images})` }">
                  <ul class="product__hover">
                    <li><a href="#"><img src="../../assets/img/icon/heart.png" alt=""></a></li>
                    <li><a href="#"><img src="../../assets/img/icon/compare.png" alt=""> <span>Compare</span></a></li>
                    <li><a href="#"><img src="../../assets/img/icon/search.png" @click="openDetail(v.productID.id)"></a></li>
                  </ul>
                </div>
                <div class="product__item__text">
                  <h6>{{ v.name }}</h6>
                  <a
                      v-if="v?.status"
                      @click="addToCart(v)"
                      class="add-cart"
                  >
                    + Add To Cart
                  </a>
                  <h5>{{ formatCurrency(v.price) }}</h5>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12">
              <div class="product__pagination">
                <a href="#" v-for="page in totalPages" :key="page" @click.prevent="changePage(page)"
                   :class="{ active: currentPage === page }">{{ page }}</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import {ref, onMounted} from "vue";
import axios from "axios";
import Cookies from "js-cookie";
import {useUser} from "@/components/composables/useUser";

export default {
  setup() {
    const currentPage = ref(1);
    const pageSize = ref(9);
    const totalPages = ref(0);
    const totalProducts = ref(0);
    const categories = ref([]);
    const brands = ref([]);
    const all_variations = ref([]);
    // const variations = ref([]);
    const searchQuery = ref("");
    const sortOrder = ref("asc");
    const selectedPriceRange = ref(null)
    const selectedCategoryId = ref(null)
    const selectedBrandsID = ref(null)
    const priceRanges = ref([
      {value: "0-1000000", label: "Dưới 1,000,000đ"},
      {value: "1000000-2000000", label: "1,000,000đ->2,000,000đ"},
      {value: "2000000-3000000", label: "2,000,000đ->3,000,000đ"},
      {value: "3000000-4000000", label: "3,000,000đ->4,000,000đ"},
      {value: "4000000-100000000", label: "Trên 4,000,000đ"},
    ]);
    const addToCart = async (variation) => {
      // alert("Chức năng thêm vào giỏ hàng đang được phát triển!");
      const customerCookie = Cookies.get("customers");
      if(variation.quantity < 1) {
        alert("Sản phẩm hiện đã hết hàng!");
        return;
      }
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
          id: variation.id,
        },
        quantity: "1",
      };
      try {
        console.log(cartItem)
        const response = await axios.post("http://localhost:8080/api/v1/cart/addtocart", cartItem);
        if (response.status === 200) {
          alert("Thêm sản phẩm vào giỏ hàng thành công!");
          await useUser();
          console.log("Added to cart:", response);
          // window.location.reload();
        }
      } catch (error) {
        alert("Hiện đã hết hàng, không thể thêm sản phẩm vào giỏ hàng!");
      }
    };
    function getMinPrice(variations) {
      if (!Array.isArray(variations) || variations.length === 0) return 0;
      return variations.reduce((min, v) => v.price < min ? v.price : min, variations[0].price);
    }

    const searchProducts = async (searchKeyword, page = 0) => {
      try {
        // Nếu không nhập gì -> load tất cả sản phẩm
        if (!searchKeyword || searchKeyword.trim() === "") {
          await fetchProducts(page);
          return;
        }

        const {data} = await axios.get(
            `http://localhost:8080/MiniatureCrafts/result/${searchKeyword}`,
            {
              params: {page, size: pageSize.value}
            }
        );


        all_variations.value = data.content;
        totalPages.value = data.page?.totalPages || 1;
        totalProducts.value = data.page?.totalElements || 0;
        currentPage.value = page + 1;
        console.log(all_variations.value)
      } catch (error) {
        console.error("Lỗi khi tìm kiếm sản phẩm:", error);
      }
    };


    function formatCurrency(value) {
      const number = Number(value);
      if (isNaN(number)) return '0 ₫';
      return number.toLocaleString('vi-VN') + ' ₫';
    }

    async function fetchProducts(page = 0) {
      try {
        const {data} = await axios.get("http://localhost:8080/MiniatureCrafts/new", {
          params: {page, size: pageSize.value, sort: sortOrder.value},
        });

        all_variations.value = data.content;
        totalPages.value = data.page?.totalPages || 1;
        totalProducts.value = data.page?.totalElements || 0;
        currentPage.value = page + 1;
        console.log(all_variations.value)
      } catch (error) {
        console.error("Error fetching products:", error);
      }
    }

    function sortProducts() {
      fetchProducts(currentPage.value - 1);
    }

    function changePage(page) {
      if (page < 1 || page > totalPages.value) return;
      fetchProducts(page - 1);
    }

    function openDetail(id) {
      window.location.href = '/product/' + id
    }

    async function getCategories() {
      try {
        const {data} = await axios.get('http://localhost:8080/MiniatureCrafts/categories')
        categories.value = data
      } catch (error) {
        console.error('Error fetching categories:', error)
      }
    }

    async function getBrands() {
      try {
        const {data} = await axios.get('http://localhost:8080/MiniatureCrafts/brands')
        brands.value = data
      } catch (error) {
        console.error('Error fetching brands:', error)
      }
    }

    // Thêm hàm xử lý khi click vào price range
    function onPriceRangeClick(value) {
      const [min, max] = value.split('-').map(Number);
      filterByPrice(min, max);
    }

    async function filterByPrice(min, max) {
      try {
        const {data} = await axios.get(`http://localhost:8080/MiniatureCrafts/filter_price`, {
          params: { min, max }
        });
        all_variations.value = data.content || [];
        totalPages.value = data.page?.totalPages || 1;
        totalProducts.value = data.page?.totalElements || 0;
      } catch (error) {
        console.error('Error filtering by price:', error);
      }
    }

    async function filterByCategory(id, page = currentPage.value - 1) {
      selectedCategoryId.value = id
      try {
        const {data} = await axios.get(`http://localhost:8080/MiniatureCrafts/categories/${id}`, {
          params: {
            page,
            size: pageSize.value
          }
        })
        all_variations.value = data.content || [];
        totalPages.value = data.page?.totalPages || 1
      } catch (error) {
        console.error('Error filtering by category:', error)
      }
    }

    async function filterByBrands(id, page = currentPage.value - 1) {
      selectedBrandsID.value = id
      try {
        const {data} = await axios.get(`http://localhost:8080/MiniatureCrafts/brands/${id}`, {
          params: {
            page,
            size: pageSize.value
          }
        })
        all_variations.value = data.content || [];
        totalPages.value = data.page?.totalPages || 1
      } catch (error) {
        console.error('Error filtering by category:', error)
      }
    }

    onMounted(async () => {
      await getCategories()
      await getBrands()
      await fetchProducts()
    });


    return {
      addToCart,
      openDetail,
      getMinPrice,
      formatCurrency,
      currentPage,
      pageSize,
      totalPages,
      totalProducts,
      categories,
      brands,
      all_variations,
      searchQuery,
      sortOrder,
      priceRanges,
      fetchProducts,
      filterByCategory,
      filterByBrands,
      sortProducts,
      searchProducts,
      selectedPriceRange,
      selectedCategoryId,
      selectedBrandsID,
      changePage,
      filterByPrice,
      onPriceRangeClick,
    };
  },
};
</script>

<style scoped>
/* Add your styles here */
.add-cart.disabled {
  pointer-events: none;
  opacity: 0.5;
}
</style>
