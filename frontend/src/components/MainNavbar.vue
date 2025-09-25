<template>
  <!-- Header Section Begin -->
  <header class="header" style="background-color: #ffffff">
    <div class="header__top" v-if="!user">
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
              <li class="active">
                <router-link to="/">Home</router-link>
              </li>
              <li class="active">
                <router-link to="/product">Shop</router-link>
              </li>
              <li class="active">
                <router-link to="/variations">Biến thể</router-link>
              </li>
              <li class="active">
                <router-link to="/contact">Contacts</router-link>
              </li>
            </ul>
          </nav>
        </div>
        <div class="col-lg-3 col-md-3">
          <div class="header__nav__option" style="display: flex; align-items: center; gap: 20px;">
            <router-link
                v-if="!loading"
                :to="user ? `/cart?userId=${user.userInfo.id}` : '/cart'"
            >
              <img src="../assets/img/icon/cart.png" alt="" class="header-icon"/>
              <span v-if="cart !== null && cart > 0" id="header__second__cart--notice"
                    class="header__second__cart--notice">
                  {{ cart }}
                </span>
            </router-link>
            <router-link v-if="user" to="/history"><img src="../assets/img/icon/avt_user.png" alt="" class="header-icon">
            </router-link>
          </div>
        </div>
      </div>
      <div class="canvas__open"><i class="fa fa-bars"></i></div>
    </div>
  </header>
</template>

<script>
import {ref, onMounted} from 'vue';
import {useUser} from '@/components/composables/useUser';

export default {
  setup() {
    const {user, cart, getUserInfo, logout} = useUser();
    const loading = ref(true);

    onMounted(async () => {
      await getUserInfo();
      loading.value = false;
      console.log(cart.value)
    });

    return {user, cart, loading, logout};
  },
};
</script>

<style scoped>
/* ...existing code... */
</style>