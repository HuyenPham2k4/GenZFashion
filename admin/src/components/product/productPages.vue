<template>
  <div id="app" class="app sidebar-mini rtl">
    <main class="app-content">
      <div class="app-title">
        <ul class="app-breadcrumb breadcrumb side">
          <li class="breadcrumb-item active">
            <a href="#"><b>Thêm mới sản phẩm</b></a>
          </li>
          import axios from 'axios';
          import Cookies from 'js-cookie';
          import router from './router'; // Đảm bảo bạn đã import router

          // Tạo một instance của axios
          const apiClient = axios.create({
          baseURL: 'http://localhost:8080', // URL cơ sở của API
          });

          // Thêm một interceptor để xử lý request
          apiClient.interceptors.request.use(
          config => {
          const token = Cookies.get('authToken');
          if (token) {
          config.headers['Authorization'] = `Bearer ${token}`;
          }
          return config;
          },
          error => {
          return Promise.reject(error);
          }
          );

          // Thêm một interceptor để xử lý response
          apiClient.interceptors.response.use(
          response => {
          // Nếu request thành công, không cần làm gì cả
          return response;
          },
          error => {
          // Nếu lỗi là 401 Unauthorized (token hết hạn hoặc không hợp lệ)
          if (error.response && error.response.status === 401) {
          // Xóa cookie token
          Cookies.remove('authToken');
          // Chuyển hướng người dùng về trang đăng nhập
          // Sử dụng router.push để điều hướng
          router.push('/login').then(() => {
          alert('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
          });
          }
          return Promise.reject(error);
          }
          );

          // Export instance đã được cấu hình để sử dụng trong toàn bộ ứng dụng
          export default apiClient;     </ul>
      </div>

      <div class="row">
        <div class="col-md-12">
          <div class="tile">
            <div class="tile-body">
              <form @submit.prevent="isEditing ? updateProduct() : addProduct()" class="row">
                <div class="form-group col-md-4">
                  <label for="productName">Tên sản phẩm:</label>
                  <input id="productName" v-model="product.name" class="form-control"/>
                </div>

                <div class="form-group col-md-4">
                  <label>Danh mục</label>
                  <select v-model="product.categoryID.id" class="form-control">
                    <option v-for="item in categories" :key="item.id" :value="item.id">
                      {{ item.name }}
                    </option>
                  </select>
                </div>

                <div class="form-group col-md-4">
                  <label>Thương hiệu</label>
                  <select v-model="product.brandID.id" class="form-control">
                    <option v-for="item in brands" :key="item.id" :value="item.id">
                      {{ item.name }}
                    </option>
                  </select>
                </div>

                <div class="form-group col-md-12">
                  <h5>Upload 3 ảnh sản phẩm</h5>
                  <div v-for="(image, index) in images" :key="index" class="image-preview-wrapper">
                    <input type="file" @change="handleFileUpload($event, index)" class="form-control mb-2"/>
                    <img v-if="image.preview" :src="image.preview" class="img-thumbnail mt-2" style="max-width: 80px;"/>
                    <label class="radio-label">
                      <input type="radio" v-model="defaultImageIndex" :value="index"/> Ảnh mặc định
                    </label>
                  </div>
                </div>

                <div class="form-group col-md-4">
                  <button type="submit" class="btn btn-primary" style="font-size: large">
                    {{ isEditing ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm' }}
                  </button>
                </div>
              </form>

              <table class="table table-hover table-bordered mt-4">
                <thead>
                <tr>
                  <th>ID</th>
                  <th>Tên sản phẩm</th>
                  <th>Danh mục</th>
                  <th>Thương hiệu</th>
                  <th>Chức năng</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="item in pagedProducts" :key="item.id">
                  <td>{{ item.id }}</td>
                  <td>{{ item.name }}</td>
                  <td>{{ item.categoryID.name }}</td>
                  <td>{{ item.brandID.name }}</td>
                  <td>
                    <button @click="editProduct(item)" class="btn btn-warning">Sửa</button>
                  </td>
                </tr>
                </tbody>
              </table>
              <div class="pagination-wrapper">
                <button
                  class="btn btn-secondary"
                  :disabled="currentPage === 1"
                  @click="currentPage--"
                >
                  Trước
                </button>
                <span class="mx-2">Trang {{ currentPage }} / {{ totalPages }}</span>
                <button
                  class="btn btn-secondary"
                  :disabled="currentPage === totalPages"
                  @click="currentPage++"
                >
                  Sau
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import axios from "axios";
import Cookies from "js-cookie";

export default {
  data() {
    return {
      product: {
        id: "",
        name: "",
        categoryID: {id: ""},
        brandID: {id: ""},
        images: []
      },
      brands: [],
      products: [],
      categories: [],
      images: [
        {id: "", file: null, preview: ""},
        {id: "", file: null, preview: ""},
        {id: "", file: null, preview: ""}
      ],
      defaultImageIndex: 0,
      imageUrls: [],
      imagesDelete: [],
      id_images: [],
      isEditing: false,
      currentPage: 1,
      pageSize: 10,
    };
  },
  created() {
    this.fetchCategories();
    this.fetchProducts();
    this.fetchBrands();
  },
  computed: {
    pagedProducts() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.products.slice(start, start + this.pageSize);
    },
    totalPages() {
      return Math.ceil(this.products.length / this.pageSize) || 1;
    }
  },
  watch: {
    products() {
      // Reset về trang đầu khi dữ liệu thay đổi
      this.currentPage = 1;
    }
  },
  methods: {
    async fetchProducts() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");

      try {
        const response = await axios.get("http://localhost:8080/admin/product/findAll", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.products = response.data;
        console.log(this.products)
      } catch (error) {
        console.error("Lỗi khi tải sản phẩm:", error);
      }
    },

    async fetchBrands() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");

      try {
        const response = await axios.get("http://localhost:8080/admin/brands/getbrands", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.brands = response.data.content;
      } catch (error) {
        console.error("Lỗi khi fetch brands:", error);
      }
    },

    async fetchCategories() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");

      try {
        const response = await axios.get("http://localhost:8080/admin/category/getcategory", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.categories = response.data.content;
      } catch (error) {
        console.error("Lỗi khi lấy danh mục:", error);
      }
    },

    handleFileUpload(event, index) {
      const file = event.target.files[0];
      if (file) {
        this.images[index].file = file;
        this.images[index].preview = URL.createObjectURL(file);
      }
    },

    validateForm() {
      if (!this.product.name.trim() || this.product.name.length > 50) {
        alert("Tên sản phẩm không hợp lệ hoặc dài hơn 50 ký tự.");
        return false;
      }
      if (!this.isEditing) {
        const uploadedFiles = this.images.filter(image => image.file !== null);
        if (uploadedFiles.length < 3) {
          alert("Vui lòng tải lên đủ 3 ảnh cho sản phẩm mới.");
          return false;
        }
      }
      return true;
    },

    async addProduct() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");
      if (!this.validateForm()) {
        console.log("Validation failed:", this.product, this.images);
        return;
      }

      try {
        console.log("Sending product data:", this.product);
        const productResponse = await axios.post(
            "http://localhost:8080/admin/product/saved",
            this.product,
            {headers: {Authorization: `Bearer ${token}`}}
        );
        console.log("Product added successfully:", productResponse.data);

        const productId = productResponse.data.id;
        const uploadedImages = [];
        for (const image of this.images) {
          const formData = new FormData();
          formData.append("file", image.file);

          const uploadResponse = await axios.post(
              "http://localhost:8080/admin/variation/images/upload",
              formData,
              {headers: {Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data"}}
          );
          uploadedImages.push(...uploadResponse.data.urls);
        }

        console.log("Uploaded images:", uploadedImages);
        const imageRequests = uploadedImages.map((imageUrl, index) => ({
          productID: productId,
          model: "Product",
          cd_Images: imageUrl,
          set_Default: index === this.defaultImageIndex
        }));

        await axios.post(
            "http://localhost:8080/admin/variation/images/setproduct",
            imageRequests,
            {headers: {Authorization: `Bearer ${token}`}}
        );

        this.fetchProducts();
      } catch (error) {
        console.error("Error while adding product:", error);
      }
    },

    async updateProduct() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");
      if (!this.validateForm()) return;

      try {
        // Step 1: Update product details (name, category, brand)
        await axios.post(
            "http://localhost:8080/admin/product/update",
            this.product,
            { headers: { Authorization: `Bearer ${token}` } }
        );

        // Step 2: Upload ONLY new images and prepare the final list of image URLs
        const finalImageUrls = [...this.images]; // Create a mutable copy

        for (let i = 0; i < finalImageUrls.length; i++) {
            const imageSlot = finalImageUrls[i];
            if (imageSlot.file) {
                // This is a new file, upload it
                const formData = new FormData();
                formData.append("file", imageSlot.file);
                const uploadResponse = await axios.post(
                    "http://localhost:8080/admin/variation/images/upload",
                    formData,
                    { headers: { "Content-Type": "multipart/form-data", Authorization: `Bearer ${token}` } }
                );
                // Replace the file object with the new URL
                finalImageUrls[i] = uploadResponse.data.urls[0];
            } else if (imageSlot.preview) {
                // This is an existing image, extract its original name from the preview URL
                const urlParts = imageSlot.preview.split('/');
                finalImageUrls[i] = urlParts[urlParts.length - 1];
            } else {
                // This is an empty slot
                finalImageUrls[i] = null;
            }
        }

        // Filter out any empty slots
        const validFinalUrls = finalImageUrls.filter(url => url);

        // Step 3: Associate the complete, final list of images with the product
        const imageRequests = validFinalUrls.map((imageUrl, index) => ({
            productID: this.product.id,
            model: "Product",
            cd_Images: imageUrl,
            set_Default: index === this.defaultImageIndex,
        }));

        await axios.post(
            "http://localhost:8080/admin/variation/images/setproduct",
            imageRequests,
            { headers: { Authorization: `Bearer ${token}` } }
        );

        // Step 4: Notify user, refresh list, and reset form
        alert("Cập nhật sản phẩm thành công!");
        await this.fetchProducts();
        this.resetForm();

      } catch (error) {
        console.error("Lỗi khi cập nhật sản phẩm:", error);
        alert("Có lỗi xảy ra khi cập nhật sản phẩm.");
      }
    },
    
    resetForm() {
      this.isEditing = false;
      this.product = {
        id: "",
        name: "",
        categoryID: { id: "" },
        brandID: { id: "" },
        images: []
      };
      this.images = [
        { id: "", file: null, preview: "" },
        { id: "", file: null, preview: "" },
        { id: "", file: null, preview: "" }
      ];
      this.defaultImageIndex = 0;
      window.scrollTo(0, 0);
    },

    editProduct(product) {
      // Scroll to top to see the form
      window.scrollTo(0, 0);
      
      this.product = {
        id: product.id,
        name: product.name,
        categoryID: {id: product.categoryID?.id || ""},
        brandID: {id: product.brandID?.id || ""},
        // Keep the original images to know what to delete if replaced
        images: product.imagesDTOS || [] 
      };

      this.isEditing = true;
      
      // Reset images state for the form
      this.images = [
        {id: "", file: null, preview: ""},
        {id: "", file: null, preview: ""},
        {id: "", file: null, preview: ""}
      ];

      if (product.imagesDTOS && product.imagesDTOS.length > 0) {
        product.imagesDTOS.forEach((img, index) => {
          if (index < 3) { // Ensure we don't go out of bounds
            this.images[index] = {
              id: img.id,
              file: null,
              preview: img.cd_Images.includes("http")
                  ? img.cd_Images
                  : `http://localhost:8080/upload/images/${img.cd_Images}`
            };
          }
        });

        this.defaultImageIndex = product.imagesDTOS.findIndex(img => img.set_Default);
        if (this.defaultImageIndex === -1) this.defaultImageIndex = 0;
      }
    }
  }
};
</script>

<style scoped>
.form-group {
  margin-bottom: 20px;
}

.btn-primary {
  background-color: #007bff;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
}

.btn-primary:hover {
  background-color: #0056b3;
}

.image-preview-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
}

.image-preview-wrapper img {
  max-width: 80px;
  border-radius: 8px;
  border: 1px solid #ccc;
}

.radio-label {
  font-size: 14px;
  margin-left: 10px;
  color: #555;
}

.pagination-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 16px;
  gap: 8px;
}
</style>
