<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - SPORTSHOES</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
            max-width: 420px;
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            text-align: center;
        }
        .login-body {
            padding: 40px;
        }
        .form-control {
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 15px;
        }
        .btn-login {
            background: #111;
            color: white;
            border-radius: 12px;
            padding: 12px;
            font-weight: 600;
        }
        .btn-login:hover {
            background: #000;
            color: white;
        }
        .role-btn {
            border-radius: 12px;
            padding: 10px 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <h3 class="mb-0 fw-bold">SPORTSHOES</h3>
        <p class="mb-0 mt-2 opacity-90">Chào mừng quay lại!</p>
    </div>

    <div class="login-body">
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger py-2">
                    ${sessionScope.error}
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success py-2">
                    ${sessionScope.message}
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-4">
                <label class="form-label fw-bold">Bạn là?</label>
                <div class="d-flex gap-3">
                    <div class="flex-fill">
                        <input type="radio" class="btn-check" name="role" id="roleNhanVien" value="nhanvien" checked>
                        <label class="btn btn-outline-primary role-btn w-100" for="roleNhanVien">
                            Nhân viên
                        </label>
                    </div>
                    <div class="flex-fill">
                        <input type="radio" class="btn-check" name="role" id="roleKhachHang" value="khachhang">
                        <label class="btn btn-outline-secondary role-btn w-100" for="roleKhachHang">
                            Khách hàng
                        </label>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="tenDangNhap" class="form-control" required placeholder="Nhập tên đăng nhập">
            </div>

            <div class="mb-4">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="matKhau" class="form-control" required placeholder="Nhập mật khẩu">
            </div>

            <button type="submit" class="btn btn-login w-100">
                Đăng nhập
            </button>
        </form>

        <div class="text-center mt-4">
            <small class="text-muted">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/Login/register.jsp" class="text-decoration-none fw-bold">Đăng ký ngay</a>
            </small>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>