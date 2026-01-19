<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bán hàng tại quầy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f3f4f6;
            font-family: 'Inter', sans-serif;
            color: #1f2937;
        }

        .invoice-tabs-container {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 20px;
            padding-left: 5px;
            overflow-x: auto;
            white-space: nowrap;
        }

        .invoice-tab {
            cursor: pointer;
            padding: 10px 20px;
            background: #e5e7eb;
            border-radius: 12px 12px 0 0;
            margin-right: 6px;
            font-size: 14px;
            font-weight: 600;
            color: #6b7280;
            transition: all 0.2s ease;
            border: 1px solid transparent;
        }

        .invoice-tab:hover {
            background: #d1d5db;
            color: #374151;
        }

        .invoice-tab.active {
            background: #fff;
            color: #2563eb;
            border-bottom: 3px solid #2563eb;
            box-shadow: 0 -4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .product-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            border-color: #2563eb;
        }

        .product-icon-wrapper {
            height: 140px;
            background: #f9fafb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #9ca3af;
            transition: color 0.3s;
        }

        .product-card:hover .product-icon-wrapper {
            color: #2563eb;
        }

        .view-detail-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #4b5563;
            transition: 0.2s;
            border: 1px solid #e5e7eb;
            z-index: 10;
        }

        .view-detail-btn:hover {
            background: #2563eb;
            color: #fff;
            border-color: #2563eb;
        }

        .cart-sidebar {
            background: #fff;
            height: calc(100vh - 40px);
            border-radius: 16px;
            box-shadow: -4px 0 15px rgba(0, 0, 0, 0.03);
            display: flex;
            flex-direction: column;
            border: 1px solid #e5e7eb;
        }

        .cart-header {
            padding: 20px;
            border-bottom: 1px solid #f3f4f6;
            background-color: #fff;
            border-radius: 16px 16px 0 0;
        }

        .cart-items {
            flex: 1;
            overflow-y: auto;
            padding: 15px;
            background-color: #f9fafb;
        }

        .cart-footer {
            padding: 20px;
            border-top: 1px solid #e5e7eb;
            background-color: #fff;
            border-radius: 0 0 16px 16px;
        }

        .cart-item-card {
            background: #fff;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 10px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .option-btn {
            min-width: 48px;
            margin: 0 8px 8px 0;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #374151;
            background: #fff;
            padding: 6px 12px;
        }

        .option-btn:hover {
            background-color: #f3f4f6;
        }

        .option-btn.selected {
            background-color: #111827;
            color: #fff;
            border-color: #111827;
        }

        .voucher-tag.disabled-voucher {
            opacity: 0.4; /* Làm mờ đi */
            pointer-events: none; /* QUAN TRỌNG: Chặn không cho click chuột */
            background-color: #f3f4f6; /* Màu nền xám */
            border-color: #e5e7eb; /* Viền nhạt */
            cursor: not-allowed;
        }

        /* CSS VOUCHER */
        .voucher-tag {
            transition: all 0.2s;
            border: 1px solid #dee2e6;
        }

        .voucher-tag:hover {
            border-color: #2563eb !important;
            background-color: #eff6ff !important;
            transform: translateY(-2px);
        }

        /* Active style */
        .voucher-tag.active {
            background-color: #2563eb !important;
            color: white !important;
            border-color: #2563eb !important;
        }

        .voucher-tag.active .text-primary,
        .voucher-tag.active .text-dark,
        .voucher-tag.active .text-muted,
        .voucher-tag.active .fw-bold {
            color: white !important;
        }
    </style>
</head>
<body>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content" style="margin-left: 260px; padding: 24px;">
    <% request.setAttribute("pageTitle", "Bán hàng tại quầy"); %>
    <%@ include file="/layout/header.jsp" %>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 border-start border-danger border-4">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("error"); %>
    </c:if>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 border-start border-success border-4">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.message}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("message"); %>
    </c:if>

    <div class="d-flex align-items-center mb-2">
        <div class="invoice-tabs-container flex-grow-1">
            <c:forEach items="${listHDCho}" var="hd">
                <div class="invoice-tab ${currentHD.id == hd.id ? 'active' : ''}"
                     onclick="location.href='${pageContext.request.contextPath}/ban-hang-tai-quay/chon-hoa-don?id=${hd.id}'">
                    <i class="fas fa-receipt me-2"></i>${hd.ma}
                </div>
            </c:forEach>
        </div>
        <a href="${pageContext.request.contextPath}/ban-hang-tai-quay/tao-hoa-don"
           class="btn btn-dark rounded-pill px-4 shadow-sm mb-3 ms-2 text-nowrap">
            <i class="fas fa-plus me-1"></i> Tạo mới
        </a>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="input-group mb-4 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                <span class="input-group-text bg-white border-0 ps-3"><i class="fas fa-search text-muted"></i></span>
                <input type="text" id="searchBox" class="form-control border-0 py-3"
                       placeholder="Tìm kiếm sản phẩm theo tên..." onkeyup="filterProduct()">
            </div>
            <div class="row g-3" id="productGrid">
                <c:forEach items="${listGiay}" var="item">
                    <c:set var="g" value="${item[0]}"/>
                    <div class="col-md-3 col-6 product-item" data-name="${g.ten}">
                        <div class="product-card h-100">

                            <div onclick="openModal(${g.id}, '${g.ten}')">
                                <div class="product-icon-wrapper"><i class="fas fa-shoe-prints"></i></div>
                                <div class="p-3">
                                    <h6 class="fw-bold text-truncate mb-1 text-dark" title="${g.ten}">${g.ten}</h6>
                                    <p class="small text-muted mb-2">${g.thuongHieu}</p>
                                    <div class="d-flex justify-content-between align-items-end">
                                        <div class="text-danger fw-bold fs-5">
                                            <fmt:formatNumber value="${item[2]}" pattern="#,###"/>₫
                                        </div>
                                        <span class="badge bg-light text-dark border">Sẵn: ${item[1]}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="cart-sidebar">
                <div class="cart-header">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Hóa đơn</h5>
                        <c:choose>
                            <c:when test="${not empty currentHD}">
                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-3 py-2 rounded-pill">${currentHD.ma}</span>
                                <span class="badge bg-warning text-dark border ms-2">Chờ xác nhận</span>
                            </c:when>
                            <c:otherwise><span class="badge bg-secondary">Chưa chọn</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="d-flex align-items-center p-2 bg-light rounded border">
                        <div class="bg-white p-2 rounded-circle border me-2 text-center"
                             style="width: 40px; height: 40px;">
                            <i class="fas fa-user text-secondary"></i>
                        </div>
                        <div class="flex-grow-1 overflow-hidden">
                            <div class="fw-bold text-truncate text-dark small">${currentHD.khachHang != null ? currentHD.khachHang.hoTen : 'Khách lẻ'}</div>
                            <div class="small text-muted"
                                 style="font-size: 11px;">${currentHD.khachHang != null ? currentHD.khachHang.sdt : 'Khách vãng lai'}</div>
                        </div>
                        <button class="btn btn-sm btn-white text-primary border shadow-sm"
                                onclick="openCustomerModal()"><i class="fas fa-search me-1"></i>Chọn
                        </button>
                    </div>
                </div>

                <div class="cart-items">
                    <c:if test="${empty cartItems}">
                        <div class="d-flex flex-column align-items-center justify-content-center h-100 text-muted opacity-50">
                            <i class="fas fa-shopping-basket fa-4x mb-3"></i>
                            <p class="small">Chưa có sản phẩm nào</p>
                        </div>
                    </c:if>
                    <c:forEach items="${cartItems}" var="ct">
                        <div class="cart-item-card position-relative">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <div class="fw-bold text-dark text-truncate"
                                         style="max-width: 180px;">${ct.giayChiTiet.giay.ten}</div>
                                    <div class="small text-muted">
                                        <span class="badge bg-light text-dark border me-1">${ct.giayChiTiet.mauSac.ten}</span>
                                        <span class="badge bg-light text-dark border">Size ${ct.giayChiTiet.kichCo.giaTri}</span>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold text-danger small"><fmt:formatNumber
                                            value="${ct.giaDonVi * ct.soLuong}" pattern="#,###"/>₫
                                    </div>
                                    <div class="small text-muted" style="font-size: 10px;"><fmt:formatNumber
                                            value="${ct.giaDonVi}" pattern="#,###"/> x ${ct.soLuong}</div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center bg-light rounded p-1">
                                <div class="d-flex align-items-center">
                                    <form action="${pageContext.request.contextPath}/ban-hang-tai-quay/them-san-pham"
                                          method="post" class="m-0">
                                        <input type="hidden" name="hoaDonId" value="${currentHD.id}">
                                        <input type="hidden" name="sanPhamId" value="${ct.giayChiTiet.id}">
                                        <button name="soLuong" value="-1" class="btn btn-sm btn-white border px-2 py-0"
                                                style="height: 24px;">-
                                        </button>
                                    </form>
                                    <span class="mx-2 fw-bold small">${ct.soLuong}</span>
                                    <form action="${pageContext.request.contextPath}/ban-hang-tai-quay/them-san-pham"
                                          method="post" class="m-0">
                                        <input type="hidden" name="hoaDonId" value="${currentHD.id}">
                                        <input type="hidden" name="sanPhamId" value="${ct.giayChiTiet.id}">
                                        <button name="soLuong" value="1" class="btn btn-sm btn-white border px-2 py-0"
                                                style="height: 24px;">+
                                        </button>
                                    </form>
                                </div>
                                <a href="${pageContext.request.contextPath}/ban-hang-tai-quay/xoa-san-pham?idHDCT=${ct.id}&hdId=${currentHD.id}"
                                   class="text-secondary small text-decoration-none px-2 hover-danger"><i
                                        class="fas fa-trash-alt"></i> Xóa</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="cart-footer">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-muted small">Tạm tính</span>
                        <span class="fw-bold"><fmt:formatNumber value="${currentHD.tongTien}" pattern="#,###"/>₫</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="fw-bold text-dark">Tổng cộng</span>
                        <span class="fs-4 fw-bold text-primary"><fmt:formatNumber value="${currentHD.tongTien}"
                                                                                  pattern="#,###"/>₫</span>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-danger py-3 fw-bold flex-grow-0"
                                onclick="confirmCancel(${currentHD.id})" ${empty currentHD ? 'disabled' : ''}
                                title="Hủy hóa đơn"><i class="fas fa-trash-alt"></i> Hủy
                        </button>
                        <button class="btn btn-dark w-100 py-3 fw-bold rounded-3 shadow-sm flex-grow-1"
                                data-bs-toggle="modal" data-bs-target="#modalPay" ${empty cartItems ? 'disabled' : ''}>
                            <i class="fas fa-money-bill-wave me-2"></i> THANH TOÁN
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalSelect" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="mName">Tên sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div id="mLoading" class="text-center py-4">
                    <div class="spinner-border text-dark" role="status"></div>
                    <p class="mt-2 text-muted small">Đang tải biến thể...</p>
                </div>
                <div id="mContent" style="display:none">
                    <div class="mb-4">
                        <p class="mb-2 fw-bold small text-muted text-uppercase ls-1">Màu sắc</p>
                        <div id="colorArea" class="d-flex flex-wrap"></div>
                    </div>
                    <div class="mb-4">
                        <p class="mb-2 fw-bold small text-muted text-uppercase ls-1">Kích cỡ</p>
                        <div id="sizeArea" class="d-flex flex-wrap"></div>
                    </div>
                    <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded-3 mb-4 border">
                        <div>
                            <div class="small text-muted">Đơn giá</div>
                            <div id="mPrice" class="fw-bold fs-4 text-danger">--</div>
                        </div>
                        <div class="text-end">
                            <div class="small text-muted">Tồn kho</div>
                            <div id="mStock" class="fw-bold text-dark">--</div>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/ban-hang-tai-quay/them-san-pham" method="post">
                        <input type="hidden" name="hoaDonId" value="${currentHD.id}">
                        <input type="hidden" name="sanPhamId" id="mId">
                        <div class="d-flex gap-3">
                            <div class="input-group" style="width: 120px;">
                                <button type="button" class="btn btn-outline-secondary" onclick="updateQty(-1)">-
                                </button>
                                <input type="number" name="soLuong" id="inputQty" value="1"
                                       class="form-control text-center fw-bold" min="1" readonly>
                                <button type="button" class="btn btn-outline-secondary" onclick="updateQty(1)">+
                                </button>
                            </div>
                            <button id="mBtnAdd" class="btn btn-dark flex-grow-1 fw-bold" disabled>THÊM VÀO GIỎ</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalCustomer" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Tìm kiếm khách hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="input-group mb-3">
                    <input type="text" id="keywordKhach" class="form-control form-control-lg"
                           placeholder="Nhập tên hoặc số điện thoại...">
                    <button class="btn btn-primary" onclick="searchCustomer()"><i class="fas fa-search"></i></button>
                </div>
                <div id="customerList" class="list-group mb-4" style="max-height: 250px; overflow-y: auto;">
                    <div class="text-center text-muted py-3 small">Nhập từ khóa để tìm kiếm...</div>
                </div>
                <form id="formSetKhach" action="${pageContext.request.contextPath}/ban-hang-tai-quay/chon-khach-hang"
                      method="post">
                    <input type="hidden" name="hoaDonId" value="${currentHD.id}">
                    <input type="hidden" name="khachHangId" id="selectedKhachId">
                    <button type="button" class="btn btn-outline-secondary w-100 py-2 fw-bold border-2"
                            onclick="setKhachLe()">
                        <i class="fas fa-user-secret me-2"></i> Chọn Khách lẻ (Vãng lai)
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalPay" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 bg-light rounded-top-4">
                <h5 class="modal-title fw-bold">Xác nhận thanh toán</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/ban-hang-tai-quay/thanh-toan-chot" method="post">
                <input type="hidden" name="hoaDonId" value="${currentHD.id}">
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <p class="text-muted mb-1">Tổng tiền cần thanh toán</p>
                        <h1 class="text-primary fw-bold display-5" id="finalTotalDisplay">
                            <fmt:formatNumber value="${currentHD.tongTien}" pattern="#,###"/>₫
                        </h1>
                        <input type="hidden" id="hiddenTongTien" value="${currentHD.tongTien}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">MÃ GIẢM GIÁ / VOUCHER</label>
                        <div class="input-group mb-2">
                            <input type="text" id="voucherInput" class="form-control"
                                   placeholder="Nhập mã hoặc chọn bên dưới...">
                            <button type="button" class="btn btn-dark" onclick="applyVoucher()">Áp dụng</button>
                        </div>
                        <div id="voucherMessage" class="small mb-2"></div>

                        <div class="border rounded p-2 bg-light" style="max-height: 150px; overflow-y: auto;">
                            <c:if test="${empty listVoucher}">
                                <div class="text-center text-muted small py-2">Không có mã giảm giá nào khả dụng</div>
                            </c:if>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach items="${listVoucher}" var="v">
                                    <div class="voucher-tag border bg-white rounded px-2 py-1 shadow-sm position-relative"
                                         style="cursor: pointer; min-width: 120px;"
                                         onclick="selectVoucher('${v.ma}')">

                                        <div class="fw-bold text-primary small"><i
                                                class="fas fa-ticket-alt me-1"></i>${v.ma}</div>

                                        <div class="text-dark" style="font-size: 11px;">
                                            Giảm: <span class="fw-bold text-danger">
                                           <c:if test="${v.loai == 1}">${v.giaTri}%</c:if>
                                           <c:if test="${v.loai != 1}"><fmt:formatNumber value="${v.giaTri}" pattern="#,###"/></c:if>
                                              </span>
                                        </div>

                                        <div class="text-muted fst-italic" style="font-size: 10px;">
                                            Đơn tối thiểu:
                                            <c:choose>
                                                <c:when test="${v.dieuKien > 0}">
                                                    <fmt:formatNumber value="${v.dieuKien}" pattern="#,###"/>đ
                                                </c:when>
                                                <c:otherwise>0đ</c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="text-muted" style="font-size: 10px;">SL: ${v.soLuong}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mb-4 px-2 border-bottom pb-2">
                        <span class="text-muted">Đã giảm:</span>
                        <span class="fw-bold text-success" id="discountDisplay">0₫</span>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">TIỀN KHÁCH ĐƯA</label>
                        <input type="number" name="tienKhachDua" id="tienKhachDua"
                               class="form-control form-control-lg fw-bold" required oninput="calcChange()">
                        <div class="d-flex gap-2 mt-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="setMoney('full')">
                                Đủ
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="setMoney(100000)">
                                100k
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="setMoney(200000)">
                                200k
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="setMoney(500000)">
                                500k
                            </button>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold small text-muted">TIỀN THỪA TRẢ KHÁCH</label>
                        <div id="tienThuaDisplay"
                             class="form-control form-control-lg bg-light text-success fw-bold border-0">0₫
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">HÌNH THỨC</label>
                        <select name="hinhThuc" class="form-select form-select-lg">
                            <option value="1">Tiền mặt</option>
                            <option value="2">Chuyển khoản</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary px-5 fw-bold">HOÀN TẤT ĐƠN HÀNG</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let variants = [], selColor = null, selSize = null;
    let currentVoucherCode = null; // Biến theo dõi mã voucher hiện tại
    const formatCurrency = (amount) => new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);

    function filterProduct() {
        let val = document.getElementById('searchBox').value.toLowerCase().trim();
        document.querySelectorAll('.product-item').forEach(el => {
            let name = el.getAttribute('data-name').toLowerCase();
            el.style.display = name.includes(val) ? 'block' : 'none';
        });
    }

    function openModal(id, name) {
        if (!'${currentHD.id}') {
            alert("Vui lòng chọn hoặc tạo hóa đơn trước!");
            return;
        }
        document.getElementById('mName').innerText = name;
        document.getElementById('inputQty').value = 1;
        selColor = null;
        selSize = null;
        const modal = new bootstrap.Modal(document.getElementById('modalSelect'));
        modal.show();
        document.getElementById('mLoading').style.display = 'block';
        document.getElementById('mContent').style.display = 'none';

        fetch('${pageContext.request.contextPath}/ban-hang-tai-quay/lay-chi-tiet-san-pham?idGiay=' + id)
            .then(r => r.json())
            .then(data => {
                variants = data;
                renderOptions();
                document.getElementById('mLoading').style.display = 'none';
                document.getElementById('mContent').style.display = 'block';
            })
            .catch(err => {
                console.error(err);
                alert("Lỗi tải dữ liệu!");
                modal.hide();
            });
    }

    function renderOptions() {
        const colors = [...new Set(variants.map(v => v.mauSac))];
        document.getElementById('colorArea').innerHTML = colors.map(c => `<button type="button" class="btn option-btn \${selColor===c?'selected':''}" onclick="pickColor('\${c}')">\${c}</button>`).join('');
        let sizes = selColor ? variants.filter(v => v.mauSac === selColor).map(v => v.kichCo) : [...new Set(variants.map(v => v.kichCo))];
        sizes.sort();
        document.getElementById('sizeArea').innerHTML = sizes.map(s => `<button type="button" class="btn option-btn \${selSize===s?'selected':''}" onclick="pickSize('\${s}')">\${s}</button>`).join('');
        updateInfo();
    }

    function pickColor(c) {
        selColor = c;
        if (selSize && !variants.find(v => v.mauSac === c && v.kichCo === selSize)) selSize = null;
        renderOptions();
    }

    function pickSize(s) {
        selSize = s;
        renderOptions();
    }

    function updateInfo() {
        const v = variants.find(v => v.mauSac === selColor && v.kichCo === selSize);
        if (v) {
            document.getElementById('mId').value = v.id;
            document.getElementById('mPrice').innerText = formatCurrency(v.giaBan);
            document.getElementById('mStock').innerText = v.soLuong;
            document.getElementById('mBtnAdd').disabled = false;
        } else {
            document.getElementById('mId').value = "";
            document.getElementById('mPrice').innerText = "--";
            document.getElementById('mStock').innerText = "--";
            document.getElementById('mBtnAdd').disabled = true;
        }
    }

    function updateQty(delta) {
        let input = document.getElementById('inputQty');
        let newVal = parseInt(input.value) + delta;
        if (newVal >= 1) input.value = newVal;
    }

    function openCustomerModal() {
        if (!'${currentHD.id}') {
            alert("Vui lòng chọn hóa đơn trước!");
            return;
        }
        new bootstrap.Modal(document.getElementById('modalCustomer')).show();
    }

    function searchCustomer() {
        let key = document.getElementById('keywordKhach').value;
        if (!key) return;
        let list = document.getElementById('customerList');
        list.innerHTML = '<div class="text-center py-2"><div class="spinner-border spinner-border-sm text-primary"></div></div>';
        fetch('${pageContext.request.contextPath}/ban-hang-tai-quay/tim-khach-hang?keyword=' + key)
            .then(res => res.json())
            .then(data => {
                list.innerHTML = '';
                if (data.length === 0) {
                    list.innerHTML = '<div class="text-center text-muted py-2">Không tìm thấy khách hàng nào</div>';
                    return;
                }
                data.forEach(kh => {
                    let item = document.createElement('a');
                    item.className = 'list-group-item list-group-item-action d-flex justify-content-between align-items-center';
                    item.href = '#';
                    item.innerHTML = `<div><div class="fw-bold">\${kh.hoTen}</div><div class="small text-muted"><i class="fas fa-phone me-1"></i>\${kh.sdt}</div></div><i class="fas fa-chevron-right text-muted small"></i>`;
                    item.onclick = function (e) {
                        e.preventDefault();
                        selectCustomer(kh.id);
                    };
                    list.appendChild(item);
                });
            }).catch(err => console.error(err));
    }

    function selectCustomer(uuid) {
        document.getElementById('selectedKhachId').value = uuid;
        document.getElementById('formSetKhach').submit();
    }

    function setKhachLe() {
        document.getElementById('selectedKhachId').value = "";
        document.getElementById('formSetKhach').submit();
    }

    function confirmCancel(id) {
        if (!id) return;
        if (confirm("Bạn có chắc chắn muốn HỦY hóa đơn này không?")) window.location.href = "${pageContext.request.contextPath}/ban-hang-tai-quay/huy-hoa-don?id=" + id;
    }

    // --- VOUCHER LOGIC (NEW: TOGGLE SELECT) ---
    function selectVoucher(code) {
        // Nếu click lại vào mã đang dùng -> Hủy
        if (currentVoucherCode === code) {
            cancelVoucher();
        } else {
            // Nếu chọn mã mới
            document.getElementById('voucherInput').value = code;
            applyVoucher();
        }
    }

    function applyVoucher() {
        let code = document.getElementById('voucherInput').value.trim();
        let hdId = '${currentHD.id}';
        let msgBox = document.getElementById('voucherMessage');

        if (!code) {
            msgBox.innerHTML = '<span class="text-danger">Vui lòng nhập mã!</span>';
            return;
        }
        msgBox.innerHTML = '<span class="text-primary"><i class="fas fa-spinner fa-spin"></i> Đang xử lý...</span>';

        fetch('${pageContext.request.contextPath}/ban-hang-tai-quay/ap-dung-voucher', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'hoaDonId=' + hdId + '&voucherCode=' + code
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    msgBox.innerHTML = `<span class="text-success"><i class="fas fa-check-circle"></i> \${data.message}</span>`;
                    document.getElementById('discountDisplay').innerText = formatCurrency(data.tienGiam);
                    document.getElementById('finalTotalDisplay').innerText = formatCurrency(data.tongTienMoi);
                    document.getElementById('hiddenTongTien').value = data.tongTienMoi;
                    calcChange();

                    // Cập nhật trạng thái
                    currentVoucherCode = code;
                    document.getElementById('voucherInput').disabled = true;
                    updateVoucherStyles();
                } else {
                    msgBox.innerHTML = `<span class="text-danger"><i class="fas fa-exclamation-triangle"></i> \${data.message}</span>`;
                }
            })
            .catch(err => {
                console.error(err);
                msgBox.innerHTML = '<span class="text-danger">Lỗi kết nối server!</span>';
            });
    }

    function cancelVoucher() {
        let hdId = '${currentHD.id}';
        let msgBox = document.getElementById('voucherMessage');
        msgBox.innerHTML = '<span class="text-primary"><i class="fas fa-spinner fa-spin"></i> Đang hủy...</span>';

        fetch('${pageContext.request.contextPath}/ban-hang-tai-quay/huy-voucher', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'hoaDonId=' + hdId
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    msgBox.innerHTML = `<span class="text-secondary">Đã hủy mã giảm giá.</span>`;

                    // Reset giá
                    document.getElementById('discountDisplay').innerText = "0₫";
                    document.getElementById('finalTotalDisplay').innerText = formatCurrency(data.tongTienMoi);
                    document.getElementById('hiddenTongTien').value = data.tongTienMoi;
                    calcChange();

                    // Reset UI
                    currentVoucherCode = null;
                    document.getElementById('voucherInput').value = "";
                    document.getElementById('voucherInput').disabled = false;
                    updateVoucherStyles();
                }
            })
            .catch(err => console.error(err));
    }

    function updateVoucherStyles() {
        let vouchers = document.querySelectorAll('.voucher-tag');
        vouchers.forEach(el => {
            // Lấy mã từ thuộc tính onclick. Định dạng: selectVoucher('CODE')
            let code = el.getAttribute('onclick').match(/'([^']+)'/)[1];
            if (code === currentVoucherCode) {
                el.classList.add('active');
            } else {
                el.classList.remove('active');
            }
        });
    }

    function calcChange() {
        let total = parseFloat(document.getElementById('hiddenTongTien').value) || 0;
        let given = parseFloat(document.getElementById('tienKhachDua').value) || 0;
        let change = given - total;
        document.getElementById('tienThuaDisplay').innerText = formatCurrency(change > 0 ? change : 0);
    }

    // Thay thế hàm updateVoucherStyles cũ bằng hàm này:

    function updateVoucherStyles() {
        let vouchers = document.querySelectorAll('.voucher-tag');

        vouchers.forEach(el => {
            // Lấy mã từ thuộc tính onclick="selectVoucher('CODE')"
            // Regex này lấy chuỗi nằm giữa 2 dấu nháy đơn
            let code = el.getAttribute('onclick').match(/'([^']+)'/)[1];

            // Bước 1: Reset trạng thái (xóa hết class cũ)
            el.classList.remove('active', 'disabled-voucher');

            // Bước 2: Kiểm tra nếu đang có mã nào đó được chọn
            if (currentVoucherCode) {
                if (code === currentVoucherCode) {
                    // Nếu là mã đang chọn -> Hiển thị Active (Xanh)
                    el.classList.add('active');
                } else {
                    // Nếu là các mã khác -> Disable (Mờ + Không click được)
                    el.classList.add('disabled-voucher');
                }
            }
            // Nếu currentVoucherCode là null (chưa chọn gì) thì không làm gì cả (để mặc định)
        });
    }

    function setMoney(amount) {
        if (amount === 'full') {
            document.getElementById('tienKhachDua').value = parseFloat(document.getElementById('hiddenTongTien').value) || 0;
        } else {
            document.getElementById('tienKhachDua').value = amount;
        }
        calcChange();
    }
</script>
</body>
</html>