<template>
  <!-- Footer Section Begin -->
  <footer class="footer">
    <div class="container">
      <div class="row">
        <div class="col-lg-3 col-md-6 col-sm-6">
          <div class="footer__about">
            <div class="footer__logo">
              <a href="#"><img src="../assets/img/footer-logo.png" alt="" /></a>
            </div>
            <p>The customer is at the heart of our unique business model, which includes design.</p>
            <a href="#"><img src="../assets/img/payment.png" alt="" /></a>
          </div>
        </div>
        <div class="col-lg-2 offset-lg-1 col-md-3 col-sm-6">
          <div class="footer__widget">
            <h6>Shopping</h6>
            <ul>
              <li><a href="#">Clothing Store</a></li>
              <li><a href="#">Trending Shoes</a></li>
              <li><a href="#">Accessories</a></li>
              <li><a href="#">Sale</a></li>
            </ul>
          </div>
        </div>
        <div class="col-lg-2 col-md-3 col-sm-6">
          <div class="footer__widget">
            <h6>Shopping</h6>
            <ul>
              <li><a href="#">Contact Us</a></li>
              <li><a href="#">Payment Methods</a></li>
              <li><a href="#">Delivary</a></li>
              <li><a href="#">Return & Exchanges</a></li>
            </ul>
          </div>
        </div>
        <div class="col-lg-3 offset-lg-1 col-md-6 col-sm-6">
          <div class="footer__widget">
            <h6>NewLetter</h6>
            <div class="footer__newslatter">
              <p>Be the first to know about new arrivals, look books, sales & promos!</p>
              <form action="#">
                <input type="text" placeholder="Your email" />
                <button type="submit"><span class="icon_mail_alt"></span></button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
  <!-- Footer Section End -->
</template>

<script>
export default {
  name: "MainFooter",
};
</script>

<style scoped>
.footer {
  background: #ffffff;
  color: #000000;
  padding: 50px 0 20px;
  font-size: 15px;
  line-height: 1.8;
  margin-top: auto;           /* quan trọng: đẩy footer xu��ng cuối */
  border-top: 1px solid #e0e0e0;  /* vạch mờ phân chia */
}


.footer__logo {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  border: 2px solid #fff;
  margin-bottom: 15px;
}

.footer__desc {
  margin-bottom: 15px;
  color: #000000;
}

.footer__contact li {
  margin-bottom: 8px;
}

.footer__social a {
  display: inline-block;
  margin-right: 12px;
  font-size: 18px;
  color: #000000;
  transition: 0.3s;
}


.footer__heading {
  color: #fff;
  font-size: 16px;
  margin-bottom: 15px;
  font-weight: bold;
}

.footer__list {
  padding: 0;
  list-style: none;
}

.footer__list li {
  margin-bottom: 8px;
}

.footer__list a {
  color: #000000;
  text-decoration: none;
  transition: 0.3s;
}

.footer__list a:hover {
  padding-left: 5px;
}

.footer__bottom {
  border-top: 1px solid #333;
  margin-top: 30px;
  padding-top: 15px;
  text-align: center;
  font-size: 14px;
  color: #888;
}

.footer__bottom span {
  font-weight: 600;
}
</style>
