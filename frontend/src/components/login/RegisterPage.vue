<template>
  <div class="container">
    <div class="registration__form">
      <div class="row">
        <!-- Form đăng ký -->
        <div class="col-sm-12 col-lg-6">
          <form @submit.prevent="register" class="form" id="form-1">
            <h3 class="heading">Đăng Ký</h3>

            <!-- Username -->
            <div class="form-group">
              <label for="fullname" class="form-label">Tên đăng nhập</label>
              <input id="fullname" v-model="form.username" type="text" placeholder="VD: Nguyễn Văn A" class="form-control">
              <span class="form-message">{{ messages.username }}</span>
            </div>

            <!-- Email -->
            <div class="form-group">
              <label for="email" class="form-label">Email</label>
              <input id="email" v-model="form.email" type="email" placeholder="VD: email@gmail.com" class="form-control">
              <span class="form-message">{{ messages.email }}</span>
              <label for="email" class="form-label">Vui lòng ghi đúng email của bạn</label>
              <label for="email" class="form-label">Email để nhận thông báo về đơn hàng và sản phẩm</label>
            </div>

            <!-- Password -->
            <div class="form-group matkhau">
              <label for="password" class="form-label">Mật khẩu</label>
              <div class="input-wrapper">
                <input
                    id="password"
                    v-model="form.password"
                    :type="passwordVisibility.password ? 'text' : 'password'"
                    placeholder="Nhập mật khẩu"
                    class="form-control"
                >
                <span class="toggle-password" @click="togglePasswordVisibility('password')">
      <i :class="passwordVisibility.password ? 'fas fa-eye' : 'fas fa-eye-slash'"></i>
    </span>
              </div>
              <span class="form-message">{{ messages.password }}</span>
            </div>

            <!-- Confirm Password -->
            <div class="form-group nhaplaimatkhau">
              <label for="password_confirmation" class="form-label">Nhập lại mật khẩu</label>
              <div class="input-wrapper">
                <input
                    id="password_confirmation"
                    v-model="form.password_confirmation"
                    :type="passwordVisibility.password_confirmation ? 'text' : 'password'"
                    placeholder="Nhập lại mật khẩu"
                    class="form-control"
                >
                <span class="toggle-password" @click="togglePasswordVisibility('password_confirmation')">
      <i :class="passwordVisibility.password_confirmation ? 'fas fa-eye' : 'fas fa-eye-slash'"></i>
    </span>
              </div>
              <span class="form-message">{{ messages.password_confirmation }}</span>
            </div>
            <!-- Submit -->
            <button class="form-submit btn-blocker">Đăng ký
              <i class="fas fa-arrow-right" style="font-size: 16px;margin-left: 10px;"></i>
            </button>
            <p style="font-size: 16px;margin: 10px 0;">Bạn đã có tài khoản?
              <a href="/login" style="color: black; font-weight: bold">Đăng nhập</a>
            </p>
          </form>
        </div>

        <!-- Lợi ích -->
        <div class="col-sm-12 col-lg-6">
          <h3 class="heading">TẠO MỘT TÀI KHOẢN</h3>
          <p class="text-login">Đăng nhập bằng tài khoản sẽ giúp bạn truy cập:</p>
          <ul>
            <li class="text-login-item"><i class="fas fa-check"></i>
              <p class="text-login">Một lần đăng nhập chung duy nhất để tương tác với các sản phẩm và dịch vụ của Miniature Craft</p>
            </li>
            <li class="text-login-item"><i class="fas fa-check"></i>
              <p class="text-login">Thanh toán nhanh hơn</p>
            </li>
            <li class="text-login-item"><i class="fas fa-check"></i>
              <p class="text-login">Xem lịch sử đặt hàng riêng của bạn</p>
            </li>
            <li class="text-login-item"><i class="fas fa-check"></i>
              <p class="text-login">Thêm hoặc thay đổi tùy chọn email</p>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import axios from 'axios';

export default {
  setup() {
    const form = ref({
      username: '',
      email: '',
      password: '',
      password_confirmation: '',
    });

    const messages = ref({
      username: '',
      email: '',
      password: '',
      password_confirmation: '',
    });

    const passwordVisibility = ref({
      password: false,
      password_confirmation: false
    });

    const togglePasswordVisibility = (field) => {
      passwordVisibility.value[field] = !passwordVisibility.value[field];
    };

    const validateForm = () => {
      let isValid = true;
      messages.value = {
        username: '',
        email: '',
        password: '',
        password_confirmation: '',
      };

      if (!form.value.username) {
        messages.value.username = 'Tên đăng nhập không được để trống.';
        isValid = false;
      }

      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!form.value.email) {
        messages.value.email = 'Email không được để trống.';
        isValid = false;
      } else if (!emailRegex.test(form.value.email)) {
        messages.value.email = 'Email không hợp lệ.';
        isValid = false;
      }

      if (!form.value.password) {
        messages.value.password = 'Mật khẩu không được để trống.';
        isValid = false;
      } else if (form.value.password.length < 8) {
        messages.value.password = 'Mật khẩu phải có ít nhất 8 ký tự.';
        isValid = false;
      }

      if (form.value.password !== form.value.password_confirmation) {
        messages.value.password_confirmation = 'Mật khẩu không khớp!';
        isValid = false;
      }

      return isValid;
    };

    const register = async () => {
      if (!validateForm()) return;

      const usersid = sessionStorage.getItem("userid");
      try {
        await axios.post('http://localhost:8080/MiniatureCrafts/signup', {
          usersid: usersid,
          username: form.value.username,
          email: form.value.email,
          password: form.value.password
        });
        alert('Đăng ký thành công!');
        window.location.href = '/login';
      } catch (error) {
        console.error('Lỗi khi đăng ký:', error);
        alert('Tên người dùng hoặc email đã tồn tại.');
      }
    };

    return {
      form,
      messages,
      passwordVisibility,
      togglePasswordVisibility,
      register
    };
  }
};
</script>

<style>
/* Container */
.login__form,
.registration__form {
  margin-top: 20px;
}

/* Heading */
.heading {
  text-align: start;
  font-weight: 600;
  font-size: 34px;
  margin: 15px 0;
}

/* Form */
.form-group {
  margin: 20px 0;
}
.form-label {
  text-align: left;
  font-size: 16px;
  font-weight: 700;
  line-height: 1.8rem;
  padding-bottom: 6px;
}
.form-control {
  height: 50px;
  padding: 8px 12px;
  border: 1px solid #b3b3b3;
  border-radius: 4px;
  outline: none !important;
  font-size: 1.4rem;
  width: 100%;
}
.form-control:focus {
  border: 1px solid #1dbfaf !important;
}
.form-control:hover {
  border-color: #1dbfaf;
}
.form-message {
  font-size: 14px;
  color: #f33a58;
}

/* Password field */
.password-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}
.password-wrapper input {
  padding-right: 40px;
}
.show-hide {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #666;
}
.show-hide:hover {
  color: #1dbfaf;
}
.show-hide i {
  font-size: 20px;
}
.input-wrapper {
  position: relative;
  width: 100%;
}

.input-wrapper .form-control {
  padding-right: 40px; /* chừa chỗ cho icon */
}

.toggle-password {
  position: absolute;
  top: 50%;
  right: 12px;
  transform: translateY(-50%);
  cursor: pointer;
  color: #555;
}

.toggle-password i {
  font-size: 18px;
}


/* Submit button */
.form-submit {
  padding: 20px 50px;
  background-color: #FFC7ED;
  font-weight: 500;
  font-size: 18px;
  position: relative;
  overflow: hidden;
  transition: 0.8s;
  border-radius: 4px;
  border: none;
}
.form-submit:hover {
  opacity: 0.9;
}

/* Extra */
.text-login {
  font-size: 16px;
  color: #101920;
  margin: unset;
}
ul {
  list-style: none;
}
.text-login-item {
  display: flex;
  margin: 19px;
  align-items: center;
}
.fa-check {
  font-size: 16px;
  margin-right: 10px;
}
</style>
