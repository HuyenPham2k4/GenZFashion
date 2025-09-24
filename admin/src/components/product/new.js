import axios from 'axios';
import Cookies from 'js-cookie';
import router from './router'; // Đảm bảo bạn đã import router

// Tạo một instance của axios
const apiClient = axios.create({    cd D:\RaTruong\GenZFashionHuyen\DATN_HP_20\DoAnTotNghiep_GenZFashion
    .\gradlew.bat bootRun

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
export default apiClient;

