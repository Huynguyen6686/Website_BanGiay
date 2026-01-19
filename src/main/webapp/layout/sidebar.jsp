<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- LẤY NHÂN VIÊN ĐĂNG NHẬP -->
<c:set var="nv" value="${sessionScope.nhanVienLogin}"/>
<c:set var="isAdmin" value="${nv != null && nv.role != null && nv.role.ten eq 'Admin'}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Menu SportShoes</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

    <style>
        :root {
            --bg-body: #f3f4f6;
            --sidebar-bg: #1c1c21;
            --sidebar-width: 260px;
            --text-idle: #8e8ea0;
            --text-active: #ffffff;
            --accent-color: #6366f1;
            --hover-bg: rgba(255, 255, 255, 0.08);
        }

        html { background-color: var(--sidebar-bg); }
        body {
            margin: 0;
            font-family: 'Inter', "Segoe UI", Arial, sans-serif;
            background-color: var(--bg-body);
            min-height: 100vh;
            animation: smoothLoad 0.4s ease-out;
        }
        @keyframes smoothLoad { 0% { opacity: 0; transform: translateY(5px); } 100% { opacity: 1; transform: translateY(0); } }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--sidebar-bg);
            color: white;
            padding: 20px 0;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: 4px 0 15px rgba(0,0,0,0.2);
        }

        .logo {
            text-align: center;
            padding: 0 20px 30px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .logo h3 {
            margin: 0;
            font-weight: 700;
            font-size: 24px;
            color: #fff;
        }
        .logo small {
            color: #8e8ea0;
            font-size: 12px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 14px 24px;
            color: var(--text-idle);
            text-decoration: none;
            transition: all 0.3s ease;
            margin: 4px 12px;
            border-radius: 12px;
        }
        .nav-link i {
            font-size: 22px;
            width: 36px;
            text-align: center;
        }
        .nav-link span {
            margin-left: 12px;
            font-weight: 500;
        }
        .nav-link:hover {
            background: var(--hover-bg);
            color: white;
        }
        .nav-link.active {
            background: var(--accent-color);
            color: white;
            font-weight: 600;
        }

        .divider {
            height: 1px;
            background: rgba(255,255,255,0.1);
            margin: 20px 24px;
        }
        .section-title {
            color: #8e8ea0;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 20px 24px 10px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <!-- Logo -->
    <div class="logo">
        <h3>SPORTSHOES</h3>
        <small>Quản lý cửa hàng</small>
    </div>

    <!-- MENU CHUNG – CẢ ADMIN & NHÂN VIÊN ĐỀU THẤY -->
    <a href="${pageContext.request.contextPath}/ban-hang-tai-quay"
       class="nav-link ${pageContext.request.requestURI.contains('ban-hang-tai-quay') ? 'active' : ''}">
        <i class='bx bx-cart-alt'></i> <span>Bán tại quầy</span>
    </a>

    <a href="${pageContext.request.contextPath}/quan-ly-hoa-don"
       class="nav-link ${pageContext.request.requestURI.contains('hoa-don') ? 'active' : ''}">
        <i class='bx bx-receipt'></i> <span>Hóa đơn</span>
    </a>

    <a href="${pageContext.request.contextPath}/quan-ly-khach-hang"
       class="nav-link ${pageContext.request.requestURI.contains('khach-hang') ? 'active' : ''}">
        <i class='bx bx-user'></i> <span>Khách hàng</span>
    </a>

    <a href="${pageContext.request.contextPath}/quan-ly-san-pham"
       class="nav-link ${pageContext.request.requestURI.contains('san-pham') || pageContext.request.requestURI.contains('bien-the') ? 'active' : ''}">
        <i class='bx bx-package'></i> <span>Sản phẩm</span>
    </a>

    <!-- CHỈ ADMIN MỚI THẤY -->
    <c:if test="${isAdmin}">
        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/quan-ly-nhan-vien"
           class="nav-link ${pageContext.request.requestURI.contains('nhan-vien') ? 'active' : ''}">
            <i class='bx bx-id-card'></i> <span>Nhân viên</span>
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh"
           class="nav-link ${pageContext.request.requestURI.contains('thuoc-tinh') ? 'active' : ''}">
            <i class='bx bx-slider-alt'></i> <span>Thuộc tính</span>
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-phieu-giam-gia"
           class="nav-link ${pageContext.request.requestURI.contains('phieu-giam-gia') ? 'active' : ''}">
            <i class='bx bx-purchase-tag-alt'></i> <span>Phiếu giảm giá</span>
        </a>

        <a href="${pageContext.request.contextPath}/quan-ly-dot-giam-gia"
           class="nav-link ${pageContext.request.requestURI.contains('dot-giam-gia') ? 'active' : ''}">
            <i class='bx bx-calendar-event'></i> <span>Đợt giảm giá</span>
        </a>

        <a href="${pageContext.request.contextPath}/thong-ke"
           class="nav-link ${pageContext.request.requestURI.contains('thong-ke') ? 'active' : ''}">
            <i class='bx bx-bar-chart-alt-2'></i> <span>Thống kê</span>
        </a>
    </c:if>

    <!-- ĐĂNG XUẤT -->
    <div class="divider"></div>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
        <i class='bx bx-log-out'></i> <span>Đăng xuất</span>
    </a>
</div>

</body>
</html>