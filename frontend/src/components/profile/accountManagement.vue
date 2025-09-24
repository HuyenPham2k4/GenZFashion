<template>
  <section class="account spad">
    <div class="container">
      <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3 mb-4 mb-lg-0">
          <div class="account__sidebar">
            <h4>Tài khoản của tôi</h4>
            <ul>
              <li :class="{ active: activeTab === 'profile' }" @click="showProfile">
                <a><i class="fa fa-user"></i> Thông tin cá nhân</a>
              </li>
              <li :class="{ active: activeTab === 'orders' }" @click="showOrders">
                <a><i class="fa fa-history"></i> Lịch sử đơn hàng</a>
              </li>
              <li :class="{ active: activeTab === 'password' }" @click="showChangePassword">
                <a><i class="fa fa-lock"></i> Đổi mật khẩu</a>
              </li>

              <div class="logout-btn">
                <button type="button" @click="logout()">
                  <i class="fa fa-sign-out"></i> Đăng xuất
                </button>
              </div>
            </ul>
          </div>
        </div>

        <!-- Account Content -->
        <div class="col-lg-9">
          <div class="account__content card">
            <div class="card-body tab-content">

              <!-- Profile -->
              <div class="tab-pane fade" :class="{ 'show active': activeTab === 'profile' }">
                <h4 class="mb-4">Thông tin cá nhân</h4>
                <form>
                  <div class="row">
                    <div class="col-lg-6" v-for="field in profileFields" :key="field.name">
                      <div class="account__input">
                        <p>{{ field.label }} <span>*</span></p>
                        <input :type="field.type" v-model="user.userInfo[field.name]" :placeholder="field.placeholder"/>
                      </div>
                    </div>
                  </div>
                  <button type="button" class="site-btn" @click="saveProfile">Cập nhật thông tin</button>
                </form>
              </div>

              <!-- Orders -->
              <div class="tab-pane fade" :class="{ 'show active': activeTab === 'orders' }">
                <h4 class="mb-4">Lịch sử đơn hàng</h4>

                <!-- Tabs con -->
                <ul class="nav nav-tabs mb-3">
                  <li class="nav-item" v-for="(label, key) in orderTabs" :key="key">
                    <a class="nav-link"
                       :class="{ active: selectedStatus === key }"
                       @click="selectedStatus = key">
                      {{ label }}
                    </a>
                  </li>
                </ul>

                <!-- Danh sách đơn hàng -->
                <div v-if="paginatedOrdersFiltered.length > 0">
                  <table class="table table-bordered table-striped">
                    <thead class="table-light">
                    <tr>
                      <th>Địa chỉ</th>
                      <th>SĐT</th>
                      <th>Ngày</th>
                      <th>Tổng</th>
                      <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="item in paginatedOrdersFiltered" :key="item.id">
                      <td>{{ item.address }}</td>
                      <td>{{ item.customerID.phone }}</td>
                      <td>{{ formatDateTime(item.order_Time) }}</td>
                      <td>{{ formatCurrency(item.total_Payment) }}</td>
                      <td>
                        <span :class="statusClasses[item.status]">{{ statusLabels[item.status] }}</span>
                      </td>
                    </tr>
                    </tbody>
                  </table>
                </div>
                <div v-else>
                  <p>Không có đơn hàng nào.</p>
                </div>
              </div>


              <!-- Password -->
              <div class="tab-pane fade" :class="{ 'show active': activeTab === 'password' }">
                <h4 class="mb-4">Đổi mật khẩu</h4>
                <form>
                  <div class="account__input" v-for="(field) in passwordFields" :key="field.name">
                    <p>{{ field.label }} <span>*</span></p>
                    <input
                        :type="field.showPassword ? 'text' : 'password'"
                        v-model="field.value"
                        :placeholder="field.placeholder"
                    />
                  </div>
                  <button type="button" class="site-btn" @click="changePassword">Đổi mật khẩu</button>
                </form>
              </div>

            </div>
          </div>
        </div>
        <!-- End col-lg-9 -->
      </div>
    </div>
  </section>
</template>


<script>
import {ref, onMounted, computed, watch} from 'vue';
import axios from 'axios';
import Cookies from 'js-cookie';
import dayjs from 'dayjs'
import {useRouter} from 'vue-router';
import {useUser} from '@/components/composables/useUser';
export default {
  setup() {
    const {logout} = useUser();
    const router = useRouter();
    const apiUrl = "http://localhost:8080/MiniatureCrafts/";
    const user = ref(JSON.parse(Cookies.get("customers") || '{}'));

    console.log("ten: " + user.value.userInfo.name);
    console.log("ten: " + user.value.userInfo.address);
    console.log("ten: " + user.value.userInfo.phone);
    console.log("ten: " + user.value.userInfo.note);
    const orders = ref([]);
    const selectedProduct = ref({});
    const activeTab = ref('orders');
    const selectedStatus = ref(""); // Giá trị lọc trạng thái
    const currentPage = ref(1);
    const itemsPerPage = 5; // Số đơn hàng mỗi trang
// Tab lọc trạng thái
    const orderTabs = ref({
      "": "Tất cả",
      "1": "Chờ xác nhận",
      "2": "Đang giao hàng",
      "3": "Giao thành công",
      "0": "Hủy đơn",
    });

    watch(activeTab, (newVal, oldVal) => {
      console.log(`🟢 activeTab changed: ${oldVal} -> ${newVal}`);
      console.log("🔍 Giá trị hiện tại của activeTab:", activeTab.value);
    });
    const paginatedOrdersFiltered = computed(() => {
      return paginatedOrders.value.filter(
          item => !item.note?.includes("Tr? hàng đơn #")
      );
    });
    const formatDateTime = (dateTime) => {
      if (!dateTime) {
        return 'Chưa thanh toán';
      }
      return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss');
    };

    const totalAmountByStatus = computed(() => {
      return filteredOrders.value.reduce((sum, order) =>
          sum + convertCurrencyToNumber(order.total_Payment), 0);
    });

    const convertCurrencyToNumber = (currencyString) => {
      if (!currencyString) return 0;

      // Chuẩn hóa chuỗi tiền tệ: Loại bỏ ký tự không cần thiết (đơn vị tiền)
      let cleanedString = currencyString.replace(/[^\d,.]/g, "");

      // Nếu có dấu chấm hoặc phẩy, kiểm tra và xử lý đúng định dạng
      if (cleanedString.includes(",")) {
        cleanedString = cleanedString.replace(/\./g, "").replace(",", ".");
      } else {
        cleanedString = cleanedString.replace(/,/g, ""); // Loại bỏ dấu phân tách hàng nghìn
      }

      return parseFloat(cleanedString);
    };
    // Nhãn trạng thái
    const statusLabels = ref({
      0: "Hủy đơn",
      1: "Chờ xác nhận",
      2: "Đang giao hàng",
      3: "Giao hàng thành công",
      4: "Trả hàng",
      5: "Chờ duyệt trả hàng"
    });
    // Lớp CSS cho trạng thái
    const statusClasses = ref({
      0: "red",
      1: "blue",
      2: "orange",
      3: "green",
      4: "black",
      5: "yellow"
    });
    const filteredOrders = computed(() => {
      if (!selectedStatus.value) return orders.value;
      return orders.value.filter(order => order.status === Number(selectedStatus.value));
    });
    // Chuyển trang
    const prevPage = () => {
      if (currentPage.value > 1) currentPage.value--;
    };

    const nextPage = () => {
      if (currentPage.value < totalPages.value) currentPage.value++;
    };

    // Tổng số trang
    const totalPages = computed(() => Math.ceil(filteredOrders.value.length / itemsPerPage));

    // Lấy danh sách đơn hàng của trang hiện tại
    const paginatedOrders = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage;
      return filteredOrders.value.slice(start, start + itemsPerPage);
    });

    const profileFields = ref([
      {name: 'name', label: 'Họ và tên', type: 'text', placeholder: 'Nhập họ và tên'},
      {name: 'address', label: 'Địa chỉ', type: 'text', placeholder: 'Nhập địa chỉ'},
      {name: 'phone', label: 'Số điện thoại', type: 'text', placeholder: 'Nhập số điện thoại'},
    ]);

    const passwordFields = ref([
      {name: 'oldPassword', label: 'Mật khẩu cũ', value: '', placeholder: 'Nhập mật khẩu cũ', showPassword: false},
      {name: 'newPassword', label: 'Mật khẩu mới', value: '', placeholder: 'Nhập mật khẩu mới', showPassword: false},
      {
        name: 'confirmPassword',
        label: 'Xác nhận mật khẩu mới',
        value: '',
        placeholder: 'Xác nhận mật khẩu mới',
        showPassword: false
      },
    ]);

// Hàm toggle trạng thái hiển thị mật khẩu của từng trường
    const togglePasswordVisibility = (index) => {
      passwordFields.value[index].showPassword = !passwordFields.value[index].showPassword;
    };

    const isModalVisible = ref(false);
    const selectedOrder = ref({});
    const itemsPerOrderDetailPage = 3; // Number of products per page in order details
    const currentOrderDetailPage = ref(1);

    const totalOrderDetailPages = computed(() => {
      return Math.ceil(selectedOrder.value.orderLine.length / itemsPerOrderDetailPage);
    });

    const paginatedOrderDetails = computed(() => {
      const start = (currentOrderDetailPage.value - 1) * itemsPerOrderDetailPage;
      const end = start + itemsPerOrderDetailPage;
      return selectedOrder.value.orderLine.slice(start, end);
    });

    const prevOrderDetailPage = () => {
      if (currentOrderDetailPage.value > 1) currentOrderDetailPage.value--;
    };

    const nextOrderDetailPage = () => {
      if (currentOrderDetailPage.value < totalOrderDetailPages.value) currentOrderDetailPage.value++;
    };

    const viewOrderDetails = async (orderId) => {
      const token = Cookies.get("token");
      try {
        const response = await axios.get(`${apiUrl}order/${orderId}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        selectedOrder.value = response.data;
        console.log("selectedOrder.value:", selectedOrder.value);
        if (activeTab.value !== "orderline") {
          activeTab.value = "orderline"; // Chỉ cập nhật nếu chưa là orderline
        }
      } catch (error) {
        console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
      }
    };

    const viewProductDetail = (id) => {
      sessionStorage.setItem("idvariation", id);
      router.push(`/product/${id}`);
    };

    const closeModal = () => {
      isModalVisible.value = false;
    };

    const showProfile = () => {
      activeTab.value = 'profile';
    };

    const showOrders = () => {
      console.log("Chuyển về danh sách đơn hàng, trước khi đổi tab:", activeTab.value);

      if (activeTab.value !== "orders") {
        activeTab.value = "orders";
        console.log("Sau khi đổi tab:", activeTab.value);
      }
    };


    const showOrdersLine = (orderID) => {
      viewOrderDetails(orderID).then(() => {
        activeTab.value = 'orderline';
      });
    };

    const showChangePassword = () => {
      activeTab.value = 'password';
    };

    const cancelOrder = async (orderid) => {
      const token = Cookies.get("authToken");
      const apiCancel = `${apiUrl}cancelOrder/${orderid}`;
      try {
        await axios.get(apiCancel, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        alert("Đơn hàng đã được hủy thành công!");
        alert("Quý khách vui lòng liên hệ với cửa hàng để được hoàn tiền (nếu có)!");
        window.location.reload();

      } catch (error) {
        console.error("Lỗi khi hủy đơn hàng:", error);
      }
    };


    const completeOrder = async (orderid) => {
      const token = Cookies.get("authToken");
      const apicomplete = `${apiUrl}completeOrder/${orderid}`;
      if (confirm("Bạn đã nhận được hàng?")) {
        try {
          await axios.get(apicomplete, {
            headers: {
              Authorization: `Bearer ${token}`
            }
          });
          alert("Đơn hàng đã được giao thành công!");
          window.location.reload();

        } catch (error) {
          console.error("Lỗi khi hủy đơn hàng:", error);
        }
      }
    };


    const getOrder = async () => {
      const customer = JSON.parse(Cookies.get('customers') || '{}');
      if (!customer || !customer.id) {
        console.error("Người dùng chưa đăng nhập.");
        return;
      }
      const idCustomer = customer.id;
      const token = customer.token;
      const apiUrls = `${apiUrl}history/${idCustomer}`;
      try {
        const response = await axios.get(apiUrls, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        orders.value = response.data.content;
        console.log(orders.value);
      } catch (error) {
        console.error("Lỗi khi lấy dữ liệu đơn hàng:", error);
      }
    };

    const formatCurrency = (value) => {
      if (!value) return '';
      return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
      }).format(value);
    };

    const changePassword = async () => {
      if (passwordFields.value[1].value !== passwordFields.value[2].value) {
        alert("Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
        return;
      }

      const token = Cookies.get("authToken");
      const apiCheckPassword = `${apiUrl}check-password`;
      const apiChangePassword = `${apiUrl}changepassword/` + user.value.username;

      const payload = {
        oldPassword: passwordFields.value[0].value,
        newPassword: passwordFields.value[1].value,
      };

      const loginRequest = {
        username: user.value.username,
        password: passwordFields.value[0].value,
      };

      const data = {
        username: user.value.username,
        password: payload.newPassword
      };

      console.log("loginRequest: " + loginRequest.username);
      console.log("loginRequest: " + loginRequest.password);
      try {
        // Xác minh mật khẩu cũ
        const checkResponse = await axios.post(apiCheckPassword, loginRequest, {
          headers: {Authorization: `Bearer ${token}`}
        });

        if (checkResponse.data != null) {
          // Nếu mật khẩu cũ đúng, gửi yêu cầu đổi mật khẩu
          await axios.post(apiChangePassword, data, {
            headers: {Authorization: `Bearer ${token}`}
          });
          alert("Đổi mật khẩu thành công!");
          passwordFields.value.forEach(field => field.value = ''); // Xóa dữ liệu nhập
        } else {
          alert("Mật khẩu cũ không đúng, vui lòng thử lại!");
        }
      } catch (error) {
        if (error.response && error.response.status === 401) {
          alert("Mật khẩu cũ không chính xác!"); // Hiển thị lỗi rõ ràng
          console.log("Lỗi xác thực:", error);
        } else {
          console.error("Lỗi không xác định:", error);
        }
      }
    };

    const isOver30Days = (dateString) => {
      if (!dateString) return false;

      const createdDate = dayjs(dateString, "YYYY-MM-DD HH:mm:ss"); // Parse đúng format
      const today = dayjs();
      const diffDays = today.diff(createdDate, 'day');
      console.log("created:", createdDate.format(), "now:", today.format(), "diff:", diffDays);

      return diffDays > 30;
    }

    const saveProfile = async () => {
      const token = Cookies.get("authToken");
      console.log("token: " + token);
      const apiUpdateProfile = `${apiUrl}updateInfo/${user.value.id}`;
      const {name, address, phone} = user.value.userInfo;

      // Input validation
      if (!name || !address || !phone) {
        alert("Vui lòng điền đầy đủ thông tin!");
        return;
      }
      if (!/^\d{10,11}$/.test(phone)) {
        alert("Số điện thoại không hợp lệ!");
        return;
      }

      const payload = {
        id: user.value.id,
        name,
        address,
        phone
      };

      try {
        await axios.post(apiUpdateProfile, payload, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        alert("Cập nhật hồ sơ thành công!");

        Cookies.set('Token', token);
        const apiUrls = `${apiUrl}user`;
        try {
          await axios.get(apiUrls, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }).then((response) => {
            const rawData = response.data;
            Cookies.set("customers", JSON.stringify(rawData));
          })
        } catch (error) {
          console.error("Lỗi khi lấy lại hồ sơ:", error);
          alert("Đã xảy ra lỗi, vui lòng thử lại.");
        }
        location.reload();
      } catch (error) {
        console.error("Lỗi khi cập nhật hồ sơ:", error);
        alert("Đã xảy ra lỗi, vui lòng thử lại.");
      }
    };


    onMounted(() => {
      getOrder();
    });

    return {
      logout,
      isOver30Days,
      orderTabs,
      viewProductDetail,
      selectedStatus,
      currentPage,
      itemsPerPage,
      totalPages,
      paginatedOrders,
      statusLabels,
      statusClasses,
      prevPage,
      nextPage,
      user,
      orders,
      selectedProduct,
      saveProfile,
      changePassword,
      cancelOrder,
      completeOrder,
      showProfile,
      showOrders,
      showOrdersLine,
      showChangePassword,
      activeTab,
      profileFields,
      passwordFields,
      viewOrderDetails,
      closeModal,
      formatCurrency,
      isModalVisible,
      selectedOrder,
      togglePasswordVisibility,
      formatDateTime,
      totalAmountByStatus,
      paginatedOrdersFiltered,
      itemsPerOrderDetailPage,
      currentOrderDetailPage,
      totalOrderDetailPages,
      paginatedOrderDetails,
      prevOrderDetailPage,
      nextOrderDetailPage,
    };
  },
};
</script>


