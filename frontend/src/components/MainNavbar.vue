<template>
  <!-- Offcanvas Menu Begin -->
  <div class="offcanvas-menu-overlay"></div>
  <div class="offcanvas-menu-wrapper">
    <div class="offcanvas__option">
      <div class="offcanvas__links">
        <router-link to="/login">Sign in</router-link>
        <router-link to="/createinfo">Sign up</router-link>
      </div>
    </div>
    <div class="offcanvas__nav__option" style="display: flex; align-items: center; gap: 20px;">
      <a href="#" class="search-switch"><img src="img/icon/search.png" alt="" class="header-icon"></a>
      <a href="#"><img src="img/icon/heart.png" alt="" class="header-icon"></a>
      <router-link to="/cart"><img src="img/icon/cart.png" alt="" class="header-icon"> <span>{{ cart || 0 }}</span></router-link>
      <router-link to="/profile"><img src="img/icon/user.png" alt="" class="header-icon"></router-link>
    </div>
    <div id="mobile-menu-wrap"></div>
    <div class="offcanvas__text">
      <p>Free shipping, 30-day return or refund guarantee.</p>
    </div>
  </div>
  <!-- Offcanvas Menu End -->

  <!-- Header Section Begin -->
  <header class="header">
    <div class="header__top">
      <div class="container">
        <div class="row">
          <div class="col-lg-6 col-md-7">
            <div class="header__top__left">
              <p>Free shipping, 30-day return or refund guarantee.</p>
            </div>
          </div>
          <div class="col-lg-6 col-md-5">
            <div class="header__top__right">
              <div class="header__top__links">
                <router-link to="/login">Sign in</router-link>
                <router-link to="/createinfo">Sign up</router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="row">
        <div class="col-lg-3 col-md-3">
          <div class="header__logo">
            <router-link to="/"><img src="../assets/img/logo.png" alt=""></router-link>
          </div>
        </div>
        <div class="col-lg-6 col-md-6">
          <nav class="header__menu mobile-menu">
            <ul>
              <li class="active"><router-link to="/">Home</router-link></li>
              <li><router-link to="/product">Shop</router-link></li>
              <li><router-link to="/variations">Biến thể</router-link></li>
              <li>
                <a href="#">Pages</a>
                <ul class="dropdown">
                  <li><router-link to="/about">About Us</router-link></li>
                  <li><router-link to="/shop-details">Shop Details</router-link></li>
                  <li><router-link to="/cart">Shopping Cart</router-link></li>
                  <li><router-link to="/checkout">Check Out</router-link></li>
                  <li><router-link to="/blog-details">Blog Details</router-link></li>
                  <li><router-link to="/admin-account">Admin Account</router-link></li>
                  <li><router-link to="/admin/dashboard">Admin</router-link></li>
                </ul>
              </li>
              <li><router-link to="/contact">Contacts</router-link></li>
            </ul>
          </nav>
        </div>
        <div class="col-lg-3 col-md-3">
          <div class="header__nav__option" style="display: flex; align-items: center; gap: 20px;">
<!--            <a href="#" class="search-switch"><img src="../assets/img/icon/search.png" alt="" class="header-icon"></a>-->
<!--            <a href="#"><img src="../assets/img/icon/heart.png" alt="" class="header-icon"></a>-->
            <router-link to="/cart"><img src="../assets/img/icon/cart.png" alt="" class="header-icon"> <span>{{ cart || '' }}</span></router-link>
            <router-link to="/profile"><img src="../assets/img/icon/member.png" alt="" class="header-icon"></router-link>
            <!-- <router-link to="/admin-account"><img src="img/icon/member.png" alt="" class="header-icon"></router-link> -->
          </div>
        </div>
      </div>
      <div class="canvas__open"><i class="fa fa-bars"></i></div>
    </div>
  </header>
</template>

<script>
import { useUser } from '@/components/composables/useUser';
export default {
  setup() {
    const {
      user,
      cart,
      searchKeyword,
      getUserInfo,
      getCart,
      logout,
    } = useUser();

    getUserInfo();

    return {
      user,
      cart,
      searchKeyword,
      getUserInfo,
      getCart,
      logout,
    };
  },
};
</script>

<style scoped>
/* ...existing code... */
</style>