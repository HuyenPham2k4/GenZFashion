// src/main.js
import { createApp } from 'vue';
import App from './App.vue';
import VueCookies from 'vue-cookies';
import router from './router';
import '@/assets/css/auth.css';
import '@/assets/css/bootstrap.min.css';
import '@/assets/css/elegant-icons.css';
import '@/assets/css/style.css';
import '@/assets/css/magnific-popup.css';
import '@/assets/css/font-awesome.min.css';
import '@/assets/css/nice-select.css';
import '@/assets/css/owl.carousel.min.css';
import '@/assets/css/slicknav.min.css';

const app = createApp(App);
app.use(router);
app.use(VueCookies);
app.mount('#app');