<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex justify-content-between align-items-center mb-4 px-3">
    <!-- Tiêu đề trang -->
    <h3 class="mb-0 fw-bold text-primary">
        <c:choose>
            <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
            <c:otherwise>SPORTSHOES - Quản lý</c:otherwise>
        </c:choose>
    </h3>

    <!-- Thông tin người dùng + Dropdown -->
    <c:if test="${not empty sessionScope.nhanVienLogin}">
        <c:set var="nv" value="${sessionScope.nhanVienLogin}"/>
        <div class="dropdown">
            <a class="d-flex align-items-center text-decoration-none dropdown-toggle"
               href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="text-end me-3">
                    <div class="fw-bold text-dark">${nv.hoTen}</div>
                    <small class="text-muted">
                        <c:choose>
                            <c:when test="${nv.role != null}">${nv.role.ten}</c:when>
                            <c:otherwise>Nhân viên</c:otherwise>
                        </c:choose>
                    </small>
                </div>
                <i class="fas fa-user-circle fs-1 text-primary"></i>
            </a>

            <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                <li>
                    <a class="dropdown-item d-flex align-items-center" href="#">
                        <i class="fas fa-user me-2"></i> Hồ sơ
                    </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item text-danger d-flex align-items-center" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </c:if>
</div>