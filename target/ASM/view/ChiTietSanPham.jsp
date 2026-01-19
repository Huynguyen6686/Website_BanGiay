<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${sp.giay.ten} - Chi tiết</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            background-color: #f9fafb;
            font-family: 'Inter', sans-serif;
            color: #1f2937;
        }

        /* --- BREADCRUMB --- */
        .breadcrumb-item a { color: #6b7280; text-decoration: none; font-size: 14px; }
        .breadcrumb-item.active { color: #111827; font-weight: 600; font-size: 14px; }

        /* --- PRODUCT IMAGE --- */
        .main-image-box {
            background: #fff;
            border-radius: 16px;
            padding: 60px;
            text-align: center;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .main-image-box i {
            font-size: 180px;
            color: #e5e7eb;
        }

        /* --- PRODUCT INFO --- */
        .product-brand { font-size: 13px; font-weight: 700; color: #6b7280; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 8px; }
        .product-title { font-size: 32px; font-weight: 800; letter-spacing: -0.025em; margin-bottom: 16px; line-height: 1.2; color: #111827; }
        .price-tag { font-size: 36px; color: #ef4444; font-weight: 700; letter-spacing: -1px; }

        /* --- VARIANT BUTTONS --- */
        .variant-group-label { font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 10px; text-transform: uppercase; }
        .variant-btn {
            min-width: 48px;
            height: 48px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-right: 10px;
            margin-bottom: 10px;
            color: #374151;
            text-decoration: none;
            font-weight: 500;
            background: #fff;
            transition: all 0.2s;
            padding: 0 16px;
        }
        .variant-btn:hover { border-color: #111827; background: #f9fafb; color: #111827; }
        .variant-btn.active { background: #111827; color: #fff; border-color: #111827; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }

        /* --- TABS --- */
        .custom-tabs .nav-link {
            border: none;
            color: #6b7280;
            font-weight: 600;
            padding: 16px 24px;
            background: transparent;
            border-bottom: 2px solid transparent;
        }
        .custom-tabs .nav-link.active {
            color: #2563eb;
            border-bottom-color: #2563eb;
        }
        .custom-tabs .nav-link:hover { color: #111827; }
        .tab-content { background: #fff; padding: 40px; border-radius: 0 0 16px 16px; border: 1px solid #e5e7eb; border-top: none; }
        .tab-header { background: #fff; border-radius: 16px 16px 0 0; border: 1px solid #e5e7eb; padding: 0 10px; }

        /* --- ACTION BOX --- */
        .action-box { background: #fff; border: 1px solid #e5e7eb; border-radius: 16px; padding: 24px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); }
        .btn-add-cart {
            background: #111827; color: #fff; padding: 14px; font-weight: 600; border-radius: 8px; border: none; width: 100%; transition: 0.2s;
        }
        .btn-add-cart:hover { background: #000; transform: translateY(-1px); }

        .btn-warning-custom {
            background-color: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; width: 100%; padding: 14px; font-weight: 600; border-radius: 8px; text-decoration: none; display: block; text-align: center;
        }
        .btn-warning-custom:hover { background-color: #ffedd5; color: #9a3412; }
    </style>
</head>
<body>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content" style="margin-left: 260px; padding: 40px;">

    <div class="d-flex justify-content-between align-items-center mb-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/ban-hang-tai-quay">Bán hàng</a></li>
                <li class="breadcrumb-item active" aria-current="page">Chi tiết sản phẩm</li>
            </ol>
        </nav>
        <a href="${pageContext.request.contextPath}/ban-hang-tai-quay" class="btn btn-white border shadow-sm rounded-pill px-4 fw-medium text-secondary">
            <i class="fas fa-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <div class="row g-5 mb-5">
        <div class="col-lg-6">
            <div class="main-image-box">
                <i class="fas fa-shoe-prints"></i>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="h-100 d-flex flex-column justify-content-center">
                <div class="product-brand">${sp.giay.thuongHieu}</div>
                <h1 class="product-title">${sp.giay.ten}</h1>

                <div class="d-flex align-items-center gap-3 mb-4">
                    <span class="price-tag"><fmt:formatNumber value="${giaHienTai}" pattern="#,###"/>₫</span>
                    <span class="badge bg-green-100 text-green-800 border border-green-200 px-3 py-1 rounded-pill"
                          style="background:#dcfce7; color:#166534;">
                        Kho: ${sp.soLuong}
                    </span>
                </div>

                <hr class="text-secondary opacity-25 my-4">

                <div class="mb-4">
                    <div class="variant-group-label">Màu sắc: <span class="text-dark">${sp.mauSac.ten}</span></div>
                    <div class="d-flex flex-wrap">
                        <c:forEach items="${relatedVariants}" var="v">
                            <c:if test="${v.kichCo.id == sp.kichCo.id}">
                                <a href="?id=${v.id}" class="variant-btn ${v.id == sp.id ? 'active' : ''}">
                                        ${v.mauSac.ten}
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="variant-group-label">Kích cỡ: <span class="text-dark">${sp.kichCo.giaTri}</span></div>
                    <div class="d-flex flex-wrap">
                        <c:forEach items="${relatedVariants}" var="v">
                            <c:if test="${v.mauSac.id == sp.mauSac.id}">
                                <a href="?id=${v.id}" class="variant-btn ${v.id == sp.id ? 'active' : ''}">
                                        ${v.kichCo.giaTri}
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="action-box mt-2">
                    <form action="${pageContext.request.contextPath}/ban-hang-tai-quay/them-san-pham" method="post">

                        <input type="hidden" name="hoaDonId" value="${sessionScope.currentHdId}">
                        <input type="hidden" name="sanPhamId" value="${sp.id}">

                        <div class="row g-3">
                            <div class="col-3">
                                <label class="small text-muted fw-bold mb-1 d-block">Số lượng</label>
                                <input type="number" name="soLuong" class="form-control form-control-lg text-center fw-bold border-secondary bg-white" value="1" min="1" max="${sp.soLuong}">
                            </div>
                            <div class="col-9">
                                <label class="small text-muted fw-bold mb-1 d-block">&nbsp;</label>

                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentHdId}">
                                        <button type="submit" class="btn-add-cart shadow-sm">
                                            <i class="fas fa-cart-plus me-2"></i> THÊM VÀO HÓA ĐƠN
                                        </button>
                                        <div class="text-center mt-2">
                                            <small class="text-muted">Đang thêm vào hóa đơn: <strong>#${sessionScope.currentHdId}</strong></small>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/ban-hang-tai-quay" class="btn-warning-custom">
                                            <i class="fas fa-exclamation-triangle me-2"></i> VUI LÒNG CHỌN HÓA ĐƠN TRƯỚC
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-5">
        <div class="tab-header">
            <ul class="nav nav-tabs custom-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" id="desc-tab" data-bs-toggle="tab" data-bs-target="#desc" type="button">Mô tả sản phẩm</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="specs-tab" data-bs-toggle="tab" data-bs-target="#specs" type="button">Thông số kỹ thuật</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" id="policy-tab" data-bs-toggle="tab" data-bs-target="#policy" type="button">Chính sách bảo hành</button>
                </li>
            </ul>
        </div>

        <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show active" id="desc">
                <h5 class="fw-bold mb-3">Giới thiệu sản phẩm</h5>
                <p class="text-secondary" style="line-height: 1.8;">
                    ${sp.giay.moTa != null ? sp.giay.moTa : 'Đang cập nhật mô tả chi tiết cho sản phẩm này...'}
                </p>
                <p class="text-secondary" style="line-height: 1.8;">
                    Sản phẩm <strong>${sp.giay.ten}</strong> thuộc thương hiệu <strong>${sp.giay.thuongHieu}</strong>
                    được thiết kế với phong cách hiện đại, trẻ trung. Chất liệu cao cấp mang lại cảm giác thoải mái tối đa khi sử dụng.
                </p>
            </div>

            <div class="tab-pane fade" id="specs">
                <div class="table-responsive">
                    <table class="table table-bordered" style="max-width: 600px;">
                        <tbody>
                        <tr>
                            <th class="bg-light w-25">Mã sản phẩm</th>
                            <td>${sp.giay.ma}</td>
                        </tr>
                        <tr>
                            <th class="bg-light">Thương hiệu</th>
                            <td>${sp.giay.thuongHieu}</td>
                        </tr>
                        <tr>
                            <th class="bg-light">Xuất xứ</th>
                            <td>Việt Nam</td>
                        </tr>
                        <tr>
                            <th class="bg-light">Năm sản xuất</th>
                            <td>2024</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="tab-pane fade" id="policy">
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-unstyled">
                            <li class="mb-3 d-flex align-items-start">
                                <i class="fas fa-check-circle text-success me-3 mt-1"></i>
                                <div>
                                    <strong>Bảo hành chính hãng 12 tháng</strong>
                                    <p class="text-muted small mb-0">Áp dụng cho các lỗi bong keo, sứt chỉ.</p>
                                </div>
                            </li>
                            <li class="mb-3 d-flex align-items-start">
                                <i class="fas fa-sync-alt text-primary me-3 mt-1"></i>
                                <div>
                                    <strong>Đổi trả trong vòng 7 ngày</strong>
                                    <p class="text-muted small mb-0">Nếu sản phẩm chưa qua sử dụng và còn nguyên tem mác.</p>
                                </div>
                            </li>
                            <li class="d-flex align-items-start">
                                <i class="fas fa-tools text-secondary me-3 mt-1"></i>
                                <div>
                                    <strong>Hỗ trợ vệ sinh giày miễn phí</strong>
                                    <p class="text-muted small mb-0">Trọn đời sản phẩm tại tất cả các chi nhánh.</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>