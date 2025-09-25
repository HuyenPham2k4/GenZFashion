<template>
  <!-- Sign In Section Begin -->
  <section class="login spad">
    <div class="container">
      <div class="row">
        <div class="col-lg-6">
          <div class="login__form" >
            <h3 style="text-align: center;">Đăng Nhập</h3><br>
            <form id="signin-form" @submit.prevent="login">
              <div class="input__item">
                <input
                  type="text"
                  id="login-email"
                  placeholder="Email"
                  v-model="username"
                  required
                />
              </div>
              <div class="input__item">
                <input
                  :type="showPassword ? 'text' : 'password'"
                  id="login-password"
                  placeholder="Mật khẩu"
                  v-model="password"
                  required
                />
                <i
                  :class="showPassword ? 'fas fa-eye' : 'fas fa-eye-slash'"
                  class="show-hide"
                  @click="togglePasswordVisibility"
                  style="right: 30px; top: 50%; transform: translateY(-50%); position: absolute; cursor: pointer;"
                ></i>
              </div>
              <div style="text-align: center;">
                <button type="submit" class="site-btn" style="background-color: #FFC7ED; color: #322C2B">Đăng Nhập</button>
              </div>
            </form>

            <h5 style="text-align: center; margin-top: 20px;">
              Chưa có tài khoản? <a href="/createinfo">Đăng ký ngay</a>
            </h5>
            <h5 style="text-align: center;">
              <a href="/forgot-password">Quên mật khẩu?</a>
            </h5>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="login__register">
            <h3>Chào Mừng Trở Lại!</h3>
            <div class="benefits">
              <div class="benefit-item">
                <i class="fas fa-user-shield" STYLE="color: #FFC7ED"></i>
                <h4>Bảo Mật Tối Ưu</h4>
                <p>Thông tin của bạn được bảo vệ an toàn tuyệt đối</p>
              </div>
              <div class="benefit-item">
                <i class="fas fa-gift" STYLE="color: #FFC7ED"></i>
                <h4>Ưu Đãi Thành Viên</h4>
                <p>Nhận quà tặng và giảm giá đặc biệt</p>
              </div>
              <div class="benefit-item">
                <i class="fas fa-history" STYLE="color: #FFC7ED"></i>
                <h4>Lịch Sử Mua Hàng</h4>
                <p>Dễ dàng theo dõi đơn hàng của bạn</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- Sign In Section End -->
</template>

<script setup>
import { ref } from 'vue';
import Cookies from 'js-cookie';

const username = ref('');
const password = ref('');
const showPassword = ref(false);
const apiUrl = 'http://localhost:8080/MiniatureCrafts/signin';

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

const validatePassword = (password) => {
  // Check if password is longer than 7 characters and contains no spaces
  const isValid = password.length > 7 && !/\s/.test(password);
  return isValid;
};

const login = async () => {
  if (!username.value || !password.value) {
    alert('Vui lòng nhập đầy đủ email và mật khẩu!');
    return;
  }

  if (!validatePassword(password.value)) {
    alert('Mật khẩu phải dài hơn 7 ký tự và không chứa khoảng trắng!');
    return;
  }

  const credentials = {
    username: username.value,
    password: password.value,
  };

  try {
    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(credentials),
    });

    const data = await response.json();

    if (response.ok) {
      alert('Đăng nhập thành công!');
      Cookies.set('authToken', data.token);
      Cookies.set('customers', JSON.stringify(data));
      window.location.href = '/';
    } else {
      throw new Error(data.message || 'Đăng nhập thất bại');
    }
  } catch (error) {
    alert('Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại!');
  }
};

</script>

<style scoped>
.login.spad {
  padding: 40px 0;
}
.login__form {
  background: #fff;
  border-radius: 10px;
  padding: 40px 30px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.07);
  margin-bottom: 30px;
}
.input__item {
  position: relative;
  margin-bottom: 20px;
}
.input__item input {
  width: 100%;
  padding: 12px 40px 12px 15px;
  border: 1px solid #e1e1e1;
  border-radius: 5px;
  font-size: 16px;
  outline: none;
}
.site-btn {
  background: #222;
  color: #fff;
  border: none;
  padding: 12px 40px;
  border-radius: 5px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}
.site-btn:hover {
  background: #444;
}
.login__social .social-buttons button {
  border: none;
  padding: 10px 24px;
  border-radius: 4px;
  font-size: 16px;
  margin: 0 5px;
  cursor: pointer;
  color: #fff;
  display: flex;
  align-items: center;
  gap: 8px;
}
.btn-google {
  background: #db4437;
}
.btn-facebook {
  background: #1877f3;
}
.login__register {
  background: #f7f7f7;
  border-radius: 10px;
  padding: 40px 30px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.04);
  margin-bottom: 30px;
}
.benefits {
  margin-top: 30px;
}
.benefit-item {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
}
.benefit-item i {
  font-size: 32px;
  margin-right: 18px;
  color: #1dbfaf;
}
.benefit-item h4 {
  margin: 0 0 4px 0;
  font-size: 20px;
  font-weight: 600;
}
.benefit-item p {
  margin: 0;
  color: #555;
  font-size: 15px;
}
.show-hide {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  color: #888;
  cursor: pointer;
}
@media (max-width: 991px) {
  .login__form, .login__register {
    padding: 30px 10px;
  }
}
@media (max-width: 767px) {
  .login__form, .login__register {
    margin-bottom: 20px;
  }
}
</style>