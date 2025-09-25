<template>
  <div id="app" class="app sidebar-mini rtl">
    <main class="app-content">
      <div class="app-title">
        <ul class="app-breadcrumb breadcrumb side">
          <li class="breadcrumb-item active">
            <a href="#"><b>Thêm mới sản phẩm</b></a>
          </li>
        </ul>
      </div>

      <div class="row">
        <div class="col-md-12">
          <div class="tile">
            <div class="tile-body">
              <form @submit.prevent="isEditing ? updateProduct() : addProduct()" class="row">
                <!-- Tên -->
                <div class="form-group col-md-4">
                  <label for="productName">Tên sản phẩm:</label>
                  <input id="productName" v-model="product.name" class="form-control"/>
                </div>

                <!-- Danh mục -->
                <div class="form-group col-md-4">
                  <label>Danh mục</label>
                  <select v-model="product.categoryID.id" class="form-control">
                    <option v-for="item in categories" :key="item.id" :value="item.id">
                      {{ item.name }}
                    </option>
                  </select>
                </div>

                <!-- Thương hiệu -->
                <div class="form-group col-md-4">
                  <label>Thương hiệu</label>
                  <select v-model="product.brandID.id" class="form-control">
                    <option v-for="item in brands" :key="item.id" :value="item.id">
                      {{ item.name }}
                    </option>
                  </select>
                </div>

                <!-- Upload ảnh -->
                <div class="form-group col-md-12">
                  <h5>Ảnh sản phẩm</h5>
                  <input type="file" multiple @change="handleFileUpload" class="form-control mb-2"/>

                  <div v-for="(image, index) in images" :key="index" class="image-preview-wrapper">
                    <img v-if="image.preview" :src="image.preview" class="img-thumbnail mt-2" style="max-width: 80px;"/>

                    <label class="radio-label">
                      <input type="radio" v-model="defaultImageIndex" :value="index"/>
                      Ảnh mặc định
                    </label>

                    <button type="button" class="btn btn-danger btn-sm ml-2" @click="removeImage(index)">
                      Xóa
                    </button>
                  </div>
                </div>

                <div class="form-group col-md-4">
                  <button type="submit" class="btn btn-primary" style="font-size: large">
                    {{ isEditing ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm' }}
                  </button>
                </div>

                <div class="form-group col-md-4">
                  <button type="button" @click="resetForm" class="btn btn-primary" style="font-size: large">
                    Reset Form
                  </button>
                </div>

              </form>

              <!-- Bảng danh sách -->
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
                <button class="btn btn-secondary" :disabled="currentPage === 1" @click="currentPage--">
                  Trước
                </button>
                <span class="mx-2">Trang {{ currentPage }} / {{ totalPages }}</span>
                <button class="btn btn-secondary" :disabled="currentPage === totalPages" @click="currentPage++">
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
      images: [], // list động ảnh
      defaultImageIndex: 0,
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
  methods: {
    async fetchProducts() {
      const token = Cookies.get("authToken");
      if (!token) return this.$router.push("/login");
      try {
        const res = await axios.get("http://localhost:8080/admin/product/findAll", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.products = res.data;
      } catch (err) {
        console.error("Lỗi khi tải sản phẩm:", err);
      }
    },
    async fetchBrands() {
      const token = Cookies.get("token");
      if (!token) return this.$router.push("/login");
      try {
        const res = await axios.get("http://localhost:8080/admin/brands/getbrands", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.brands = res.data.content;
      } catch (err) {
        console.error("Lỗi khi fetch brands:", err);
      }
    },
    async fetchCategories() {
      const token = Cookies.get("token");
      if (!token) return this.$router.push("/login");
      try {
        const res = await axios.get("http://localhost:8080/admin/category/getcategory", {
          headers: {Authorization: `Bearer ${token}`}
        });
        this.categories = res.data.content;
      } catch (err) {
        console.error("Lỗi khi lấy danh mục:", err);
      }
    },

    // thêm nhiều ảnh mới
    handleFileUpload(e) {
      const files = Array.from(e.target.files);
      files.forEach(file => {
        this.images.push({
          file,
          oldName: null,
          preview: URL.createObjectURL(file)
        });
      });
      if (this.images.length > 0 && this.defaultImageIndex === null) {
        this.defaultImageIndex = 0;
      }
    },
    removeImage(index) {
      this.images.splice(index, 1);
      if (this.defaultImageIndex >= this.images.length) {
        this.defaultImageIndex = 0;
      }
    },

    async addProduct() {
      const token = Cookies.get("token");
      if (!token) return this.$router.push("/login");

      try {
        // 1. lưu product
        const productRes = await axios.post("http://localhost:8080/admin/product/saved", this.product, {
          headers: {Authorization: `Bearer ${token}`}
        });
        const productId = productRes.data.id;
        alert("✅ Thêm sản phẩm thành công!");

        // 2. upload ảnh mới
        const uploadedImages = [];
        for (const img of this.images) {
          if (img.file) {
            const formData = new FormData();
            formData.append("file", img.file);
            const uploadRes = await axios.post("http://localhost:8080/admin/variation/images/upload", formData, {
              headers: {"Content-Type": "multipart/form-data"}
            });
            uploadedImages.push(...uploadRes.data.urls);
          }
        }

        // 3. gắn ảnh vào product
        const imageRequests = uploadedImages.map((url, idx) => ({
          productID: productId,
          model: "Product",
          cd_Images: url,
          set_Default: idx === this.defaultImageIndex
        }));
        if (imageRequests.length > 0) {
          await axios.post("http://localhost:8080/admin/variation/images/setproduct", imageRequests, {
            headers: {Authorization: `Bearer ${token}`}
          });
        }

        this.fetchProducts();
        this.resetForm();
      } catch (err) {
        console.error("❌ Lỗi khi thêm sản phẩm:", err);
      }
    },

    async updateProduct() {
      const token = Cookies.get("authToken");
      const productid = this.product.id;
      console.log(productid);
      if (!token) return this.$router.push("/login");

      try {
        // Upload ảnh mới
        const uploadedImages = [];
        for (const img of this.images) {
          if (img.file) {
            const formData = new FormData();
            formData.append("file", img.file);
            const uploadRes = await axios.post("http://localhost:8080/admin/variation/images/upload", formData, {
              headers: {"Content-Type": "multipart/form-data", Authorization: `Bearer ${token}`}
            });
            uploadedImages.push(...uploadRes.data.urls);
          }
        }

        // Giữ lại ảnh cũ
        const keptImages = this.images.filter(img => !img.file && img.oldName).map(img => img.oldName);

        // ❌ Xoá toàn bộ ảnh cũ trước
        if (this.product.images && this.product.images.length > 0) {
          const allOldImages = this.product.images.map(img => img.cd_Images);
          await axios.post("http://localhost:8080/admin/variation/images/delete", allOldImages, {
            headers: {Authorization: `Bearer ${token}`}
          });
        }

        // Update product info
        await axios.post("http://localhost:8080/admin/product/update", this.product, {
          headers: {Authorization: `Bearer ${token}`}
        });

        // Set lại toàn bộ ảnh
        const finalImages = [...keptImages, ...uploadedImages];
        const imageRequests = finalImages.map((url, idx) => ({
          productID: productid,
          model: "Product",
          cd_Images: url,
          set_Default: idx === this.defaultImageIndex
        }));
        console.log(imageRequests)
        if (imageRequests.length > 0) {
          await axios.post("http://localhost:8080/admin/variation/images/setproduct", imageRequests, {
            headers: {Authorization: `Bearer ${token}`}
          });
        }

        alert("✅ Cập nhật sản phẩm thành công!");
        this.resetForm()
        this.$router.push("/product");
      } catch (err) {
        console.error("❌ Lỗi khi cập nhật sản phẩm:", err);
      }
    },
    resetForm() {
      this.product = {
        id: null,
        name: "",
        price: 0,
        description: "",
        images: [], // để đảm bảo clear
        // thêm các field khác của bạn nếu có
      };

      this.images = [];
      this.defaultImageIndex = 0;

      // Nếu có validate errors thì clear
      if (this.errors) {
        this.errors = {};
      }

      // Nếu dùng <input type="file"> thì clear luôn
      const fileInputs = document.querySelectorAll('input[type="file"]');
      fileInputs.forEach(input => input.value = "");

      window.location.reload()
    },

    editProduct(product) {
      this.product = {
        id: product.id,
        name: product.name,
        categoryID: {id: product.categoryID?.id || ""},
        brandID: {id: product.brandID?.id || ""},
        images: product.images || []
      };
      this.isEditing = true;

      console.log(this.product)
      // build lại list ảnh
      this.images = (product.images || []).map(img => ({
        id: img.id,
        oldName: img.cd_Images,
        file: null,
        preview: img.cd_Images.includes("http")
            ? img.cd_Images
            : `http://localhost:8080/upload/images/${img.cd_Images}`
      }));

      this.defaultImageIndex = product.images.findIndex(img => img.set_Default);
      if (this.defaultImageIndex === -1) this.defaultImageIndex = 0;
    }
  }
};
</script>


<style scoped>
/* ==== FORM ==== */
.form-group {
  margin-bottom: 20px;
}

label {
  font-weight: 600;
  margin-bottom: 6px;
  display: inline-block;
  color: #444;
}

.form-control {
  border-radius: 8px;
  border: 1px solid #ddd;
  padding: 8px 12px;
  font-size: 14px;
  transition: all 0.2s ease;
}

.form-control:focus {
  border-color: #FFC7ED;
  box-shadow: 0 0 0 3px rgba(0, 188, 212, 0.15);
  outline: none;
}

/* ==== BUTTON ==== */
.btn-primary {
  background: #FFC7ED;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 600;
  transition: all 0.3s ease;
  color: #322C2B;
}

.btn-primary:hover {
  background: #322C2B;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px #FFC7ED;
}

.btn-warning {
  background: #FFC7ED;
  border: none;
  border-radius: 6px;
  padding: 6px 14px;
  font-size: 14px;
  font-weight: 500;
  color: #322C2B;
  transition: all 0.3s ease;
}

.btn-warning:hover {
  background: #322C2B;
  color: white;
  transform: scale(1.05);
}

/* ==== IMAGE UPLOAD ==== */
.image-preview-wrapper {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
  background: #f9f9f9;
  padding: 10px;
  border-radius: 10px;
  border: 1px dashed #ccc;
}

.image-preview-wrapper:hover {
  border-color: #FFC7ED;
  background: #f0fcfc;
}

.image-preview-wrapper img {
  max-width: 80px;
  height: 80px;
  border-radius: 10px;
  border: 1px solid #ddd;
  object-fit: cover;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.radio-label {
  font-size: 14px;
  color: #444;
  display: flex;
  align-items: center;
  gap: 5px;
}

/* ==== TABLE ==== */
.table {
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.table th {
  background: #FFC7ED;
  text-align: center;
  font-weight: 600;
  padding: 12px;
}

.table td {
  padding: 12px;
  vertical-align: middle;
  text-align: center;
  font-size: 14px;
}

.table tbody tr {
  transition: background 0.2s ease;
}

.table tbody tr:hover {
  background: #f0fcfc;
}

/* ==== PAGINATION ==== */
.pagination-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 16px;
  gap: 10px;
}

.btn-secondary {
  background: white;
  border: 1px solid #ddd;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s ease;
}

.btn-secondary:hover {
  background: #FFC7ED;
  color: #000;
  border-color: #FFC7ED;
}

.mx-2 {
  font-weight: 600;
  color: #322C2B;
}
</style>
