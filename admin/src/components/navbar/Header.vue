<template>
  <div>
    <header class="app-header">
      <!-- Sidebar toggle button -->
      <a
          class="app-sidebar__toggle"
          href="/"
          @click.prevent="toggleSidebar"
          aria-label="Hide Sidebar"
      ></a>
      <!-- Navbar Right Menu -->
      <ul class="app-nav">
        <!-- User Menu -->
        <li>
          <a class="app-nav__item header-icon-button" href="/posorder">
            <i class="bx bx-log-out bx-rotate-180"></i>
          </a>
        </li>
      </ul>
    </header>
    <aside class="app-sidebar" v-if="!isWarehouseDetailPage" v-show="isSidebarVisible">
      <div class="app-sidebar__user">
        <img
            class="app-sidebar__user-avatar"
            src="../../assets/img.png"
            width="50px"
            alt="User Image"
        />
        <div>
          <p class="app-sidebar__user-name">
            <b>{{ adminName }}</b>
          </p>
          <p class="app-sidebar__user-designation">Chào mừng bạn trở lại</p>
        </div>
      </div>
      <hr/>
<!--      <ul class="app-menu">-->
<!--        <li>-->
<!--          <a class="app-menu__item " href="/order" @click.prevent="navigateTo('order')">-->
<!--            <i class="app-menu__icon bx bx-cart"></i>-->
<!--            <span class="app-menu__label">POS Bán Hàng</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li v-if="showDashboard">-->
<!--          <a class="app-menu__item" href="/">-->
<!--            <i class='app-menu__icon bx bx-tachometer'></i>-->
<!--            <span class="app-menu__label">Bảng điều khiển</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li v-if="showCustomer">-->
<!--          <a class="app-menu__item" href="/customer">-->
<!--            <i class="app-menu__icon bx bx-group"></i>-->
<!--            <span class="app-menu__label">Quản lý khách hàng</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li>-->
<!--          <router-link to="/product" class="app-menu__item">-->
<!--            <i class="app-menu__icon bx bx-package"></i>-->
<!--            <span class="app-menu__label">Quản lý sản phẩm</span>-->
<!--          </router-link>-->
<!--        </li>-->
<!--        <li>-->
<!--          <a class="app-menu__item" href="/variation">-->
<!--            <i class="app-menu__icon bx bx-package"></i>-->
<!--            <span class="app-menu__label">Quản lý biến thể</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li>-->
<!--          <a class="app-menu__item" href="/posorder">-->
<!--            <i class="app-menu__icon bx bx-receipt"></i>-->
<!--            <span class="app-menu__label">Quản lý đơn hàng</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li v-if="showEmployee">-->
<!--          <a class="app-menu__item" href="/employee">-->
<!--            <i class="app-menu__icon bx bx-id-card"></i>-->
<!--            <span class="app-menu__label">Nhân viên</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li>-->
<!--          <a class="app-menu__item" href="/contact">-->
<!--            <i class="app-menu__icon bx bx-bell"></i>-->
<!--            <span class="app-menu__label">Thông báo</span>-->
<!--          </a>-->
<!--        </li>-->
<!--        <li>-->
<!--          <a class="app-menu__item" href="/login">-->
<!--            <i class="app-menu__icon bx bx-log-in"></i>-->
<!--            <span class="app-menu__label">Đăng nhập</span>-->
<!--          </a>-->
<!--        </li>-->
      <ul class="app-menu">
        <li>
          <router-link to="/order" class="app-menu__item">
            <i class="app-menu__icon bx bx-cart"></i>
            <span class="app-menu__label">POS Bán Hàng</span>
          </router-link>
        </li>

        <li v-if="showDashboard">
          <router-link to="/" class="app-menu__item">
            <i class="app-menu__icon bx bx-tachometer"></i>
            <span class="app-menu__label">Bảng điều khiển</span>
          </router-link>
        </li>

        <li v-if="showCustomer">
          <router-link to="/customer" class="app-menu__item">
            <i class="app-menu__icon bx bx-group"></i>
            <span class="app-menu__label">Quản lý khách hàng</span>
          </router-link>
        </li>

        <li>
          <router-link to="/product" class="app-menu__item">
            <i class="app-menu__icon bx bx-package"></i>
            <span class="app-menu__label">Quản lý sản phẩm</span>
          </router-link>
        </li>

        <li>
          <router-link to="/variation" class="app-menu__item">
            <i class="app-menu__icon bx bx-package"></i>
            <span class="app-menu__label">Quản lý biến thể</span>
          </router-link>
        </li>

        <li>
          <router-link to="/posorder" class="app-menu__item">
            <i class="app-menu__icon bx bx-receipt"></i>
            <span class="app-menu__label">Quản lý đơn hàng</span>
          </router-link>
        </li>

        <li v-if="showEmployee">
          <router-link to="/employee" class="app-menu__item">
            <i class="app-menu__icon bx bx-id-card"></i>
            <span class="app-menu__label">Nhân viên</span>
          </router-link>
        </li>

        <li>
          <router-link to="/contact" class="app-menu__item">
            <i class="app-menu__icon bx bx-bell"></i>
            <span class="app-menu__label">Thông báo</span>
          </router-link>
        </li>

<!--        <li>-->
<!--          <router-link to="/login" class="app-menu__item">-->
<!--            <i class="app-menu__icon bx bx-log-in"></i>-->
<!--            <span class="app-menu__label">Đăng nhập</span>-->
<!--          </router-link>-->
<!--        </li>-->
        <li>
          <a class="app-menu__item" @click.prevent="logout" href="#">
            <i class="app-menu__icon bx bx-log-out"></i>
            <span class="app-menu__label">Đăng xuất</span>
          </a>
        </li>
      </ul>

    </aside>
  </div>
</template>

<script>
import Cookies from "js-cookie";

export default {
  data() {
    return {
      isSidebarVisible: true,
      admin: JSON.parse(Cookies.get("admin") || "{}"),
      roles : Cookies.get("roles"|| "[]"),
    };
  },
  computed: {
    adminName() {
      return this.admin ? this.admin.name : 'Người dùng'; // Lấy tên người dùng
    },
    isWarehouseDetailPage() {
      // Hide sidebar for /warehouse/warehouseDetails, /order, and /posorder
      return [ "/order"].includes(this.$route.path);
    },
    isOrderPage() {
      return this.$route.path === "/warehouse/warehouseDetails";
    },
    showDashboard() {
      // Hiển thị bảng điều khiển nếu là admin, ẩn nếu là USER
      return this.roles.includes('ADMIN');
    },
    showEmployee() {
      // Hiển thị nhân viên nếu là admin, ẩn nếu là USER
      return this.roles.includes('ADMIN');
    }
  },
  mounted() {
    if (!this.admin || Object.keys(this.admin).length === 0) {
      this.admin = 'Chưa đăng nhập'
      this.$router.push("/login"); // Chuyển hướng đến trang đăng nhập nếu admin null
    }
  },
  methods: {
    toggleSidebar() {
      this.isSidebarVisible = !this.isSidebarVisible;
    },
    logout() {
      // Xóa token khỏi cookies
      Cookies.remove("roles");
      Cookies.remove("token");
      Cookies.remove("authToken");
      Cookies.remove("admin");
      location.reload();
      // Chuyển hướng đến trang đăng nhập
      this.$router.push("/login"); // Hoặc trang bạn muốn chuyển hướng đến
    },
    navigateTo(route) {
      this.isSidebarVisible = false; // Ẩn sidebar
      this.$router.push(`/${route}`); // Chuyển hướng đến trang mới
    },
  },
};
</script>

<style scoped>
/* Thanh header với chiều cao giảm (padding giảm) */
.app-header {
  background-color: #322C2B;
  display: flex;
  align-items: center;
  padding: 0 5px; /* Giảm padding dọc để giảm chiều cao header */
  height: 40px; /* Đặt chiều cao cố định */
}

/* Nút icon trên header với kích thước nhỏ hơn */
.header-icon-button {
  font-size: 1.2rem; /* Giảm kích thước icon */
  padding: 5px 10px; /* Giảm padding của nút */
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Đặt màu nền mặc định cho nút trên header */
.header-icon-button {
  background-color: #FFC7ED; /* Màu nền hồng */
}

/* Đổi màu nền khi di chuột qua nút */
.header-icon-button:hover {
  background-color: #ffffff; /* Màu nền vàng */
}

/* Đổi màu icon thành đen khi di chuột qua nút */
.header-icon-button:hover i {
  color: black;
}

/* Thanh sidebar */
.app-sidebar {
  background-color: #FFC7ED;
  padding: 10px;
}

/* Các style cho menu nút chức năng */
.app-menu__item,
.app-menu__item .app-menu__icon,
.app-menu__item .app-menu__label {
  color: black;
}

.app-menu__item:hover {
  background-color: #ffffff;
}

/* Các style khác */
.tile-title {
  color: black;
}

.control-panel span {
  color: black;
}
</style>
