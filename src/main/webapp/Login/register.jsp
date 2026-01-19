<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký - SPORTSHOES</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); font-family: 'Inter', sans-serif; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .register-card { background: white; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); overflow: hidden; width: 100%; max-width: 480px; }
        .register-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px 40px; text-align: center; }
        .register-body { padding: 40px; }
        .form-control { border-radius: 12px; padding: 12px 16px; font-size: 15px; }
        .btn-register { background: #111; color: white; border-radius: 12px; padding: 12px; font-weight: 600; }
        .btn-register:hover { background: #000; color: white; }
    </style>
</head>
<body>

<div class="register-card">
    <div class="register-header">
        <h3 class="mb-0 fw-bold">SPORTSHOES</h3>
        <p class="mb-0 mt-2 opacity-90">Tạo tài khoản khách hàng</p>
    </div>

    <div class="register-body">
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger py-2">${sessionScope.error}</div>
            <% session.removeAttribute("error"); %>
        </c:if>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success py-2">${sessionScope.message}</div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="row g-3">
                <div class="col-12"><label class="form-label">Họ và tên</label><input type="text" name="hoTen" class="form-control" required></div>
                <div class="col-12"><label class="form-label">Số điện thoại</label><input type="text" name="sdt" class="form-control" required></div>
                <div class="col-12"><label class="form-label">Email</label><input type="email" name="email" class="form-control" required></div>
                <div class="col-12"><label class="form-label">Tên đăng nhập</label><input type="text" name="tenDangNhap" class="form-control" required></div>
                <div class="col-12"><label class="form-label">Mật khẩu</label><input type="password" name="matKhau" class="form-control" required></div>
                <div class="col-12"><label class="form-label">Nhập lại mật khẩu</label><input type="password" name="matKhau2" class="form-control" required></div>
            </div>
            <button type="submit" class="btn btn-register w-100 mt-4">Đăng ký tài khoản</button>
        </form>

        <div class="text-center mt-4">
            <small class="text-muted">Đã có tài khoản? <a href="${pageContext.request.contextPath}/Login/login.jsp" class="fw-bold">Đăng nhập</a></small>
        </div>
    </div>
</div>

</body>
</html>