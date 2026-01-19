<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="now" class="java.util.Date"/>
<html>
<head>
    <title>Quản lý đợt giảm giá</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: #f8f9fc; font-family: 'Segoe UI', sans-serif; }
        .content { margin-left: 260px; padding: 20px; }
        .search-box { border-radius: 12px; padding: 14px 20px; border: 1px solid #e2e8f0; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .search-box:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.25rem rgba(13,110,253,.25); }
        .stat-card { background: #fff; border-radius: 12px; padding: 16px 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); text-align: center; }
        .stat-number { font-size: 2rem; font-weight: 700; }
        .stat-label { font-size: 0.9rem; color: #64748b; margin-top: 4px; }
        .promotion-avatar { width: 48px; height: 48px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #64748b; }
        .action-icon { font-size: 1.2rem; color: #64748b; cursor: pointer; }
        .action-icon:hover { color: #0d6efd; }
        .table thead { background-color: #f8f9fa; }
        .toast-container { position: fixed; top: 20px; right: 20px; z-index: 9999; }

        /* CSS Validation Error */
        .error-message {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }
        .is-invalid-custom {
            border-color: #dc3545 !important;
        }
    </style>
</head>
<body>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content">
    <% request.setAttribute("pageTitle", "Quản lý đợt giảm giá"); %>
    <%@ include file="/layout/header.jsp" %>

    <div class="mb-4">
        <p class="text-secondary">Tạo và quản lý các chương trình khuyến mãi cho sản phẩm</p>
    </div>
    <div class="mt-3"><hr></div>

    <div class="toast-container">
        <c:if test="${not empty sessionScope.message}">
            <div class="toast align-items-center text-white bg-success border-0" role="alert" data-bs-autohide="true" data-bs-delay="5000">
                <div class="d-flex">
                    <div class="toast-body"><i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="toast align-items-center text-white bg-danger border-0" role="alert" data-bs-autohide="true" data-bs-delay="5000">
                <div class="d-flex">
                    <div class="toast-body"><i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.error}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="flex-grow-1 me-3">
            <div class="position-relative">
                <i class="bi bi-search position-absolute ms-3 top-50 start-3 translate-middle-y text-muted"></i>
                <input type="text" class="form-control  search-box ps-5" placeholder="Tìm kiếm theo mã, tên đợt..." id="searchInput">
            </div>
        </div>
        <button class="btn btn-dark rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalDotGiamGia" onclick="resetForm()">
            + Tạo đợt giảm giá
        </button>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4"><div class="stat-number text-primary">${totalDot}</div><div class="stat-label">Tổng đợt</div></div>
                <div class="promotion-avatar"><i class="bi bi-tags"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4"><div class="stat-number text-success">${dangDienRa}</div><div class="stat-label">Đang diễn ra</div></div>
                <div class="promotion-avatar text-success"><i class="bi bi-play-circle"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4"><div class="stat-number text-warning">${sapDienRa}</div><div class="stat-label">Sắp diễn ra</div></div>
                <div class="promotion-avatar text-warning"><i class="bi bi-clock"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4"><div class="stat-number text-danger">${daKetThuc}</div><div class="stat-label">Đã kết thúc</div></div>
                <div class="promotion-avatar text-danger"><i class="bi bi-stop-circle"></i></div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Mã đợt</th>
                    <th>Tên đợt giảm giá</th>
                    <th>Giảm giá</th>
                    <th>Thời gian</th>
                    <th>Sản phẩm áp dụng</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageItems}" var="d">
                    <tr>
                        <td><div class="fw-semibold text-primary">${d.ma}</div></td>
                        <td>${d.ten}</td>
                        <td>
                            <c:choose>
                                <c:when test="${d.phanTram > 0}">
                                    <span class="badge bg-danger">- ${d.phanTram}%</span>
                                </c:when>
                                <c:when test="${d.soTienGiam > 0}">
                                    <span class="badge bg-info">- <fmt:formatNumber value="${d.soTienGiam}" type="currency" currencySymbol="₫"/></span>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <fmt:formatDate value="${d.ngayBatDau}" pattern="dd/MM/yyyy"/> -
                            <fmt:formatDate value="${d.ngayKetThuc}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>${d.giays.size()} sản phẩm</td>
                        <td>
                            <c:choose>
                                <c:when test="${d.ngayKetThuc.before(now)}"><span class="badge bg-secondary">Đã kết thúc</span></c:when>
                                <c:when test="${d.ngayBatDau.after(now)}"><span class="badge bg-warning text-dark">Sắp diễn ra</span></c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${d.kichHoat == 1}"><span class="badge bg-success">Đang diễn ra</span></c:when>
                                        <c:otherwise><span class="badge bg-dark">Tạm dừng</span></c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <span class="action-icon" title="Sửa" onclick='editDot(${d.id},"${d.ma}","${d.ten.replace("'", "\\'")}","${d.moTa != null ? d.moTa.replace("'", "\\'") : ''}",${d.phanTram != null ? d.phanTram : "null"},${d.soTienGiam != null ? d.soTienGiam : "null"},"<fmt:formatDate value="${d.ngayBatDau}" pattern="yyyy-MM-dd"/>","<fmt:formatDate value="${d.ngayKetThuc}" pattern="yyyy-MM-dd"/>",${d.kichHoat},[<c:forEach items="${d.giays}" var="link" varStatus="st">${link.giayChiTiet.giay.id}<c:if test="${!st.last}">,</c:if></c:forEach>])'>
                                <i class="bi bi-pencil-square"></i>
                            </span>
                            <span class="action-icon ms-3" title="${d.kichHoat == 1 ? 'Tắt hoạt động' : 'Bật lại hoạt động'}" onclick="toggleStatus(${d.id}, ${d.kichHoat})">
                                <i class="bi ${d.kichHoat == 1 ? 'bi-toggle-on text-success' : 'bi-toggle-off text-muted'} fs-4"></i>
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="card-footer bg-white border-top-0 py-4">
            <nav class="d-flex justify-content-center">
                <ul class="pagination mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}">Trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}">Sau</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDotGiamGia" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="formDot" action="${contextPath}/quan-ly-dot-giam-gia/add" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="id" id="dotId">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="modalTitle">Tạo đợt giảm giá mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã đợt <span class="text-danger">*</span></label>
                            <input name="ma" id="dotMa" class="form-control">
                            <small id="errorDotMa" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên đợt giảm giá <span class="text-danger">*</span></label>
                            <input name="ten" id="dotTen" class="form-control">
                            <small id="errorDotTen" class="error-message"></small>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="moTa" id="dotMoTa" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phần trăm giảm (%)</label>
                            <input type="number" name="phanTram" id="dotPhanTram" class="form-control">
                            <small id="errorDotPhanTram" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số tiền giảm (₫)</label>
                            <input type="number" name="soTienGiam" id="dotSoTienGiam" class="form-control">
                            <small id="errorDotSoTienGiam" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                            <input type="date" name="ngayBatDau" id="dotNgayBatDau" class="form-control">
                            <small id="errorDotNgayBatDau" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                            <input type="date" name="ngayKetThuc" id="dotNgayKetThuc" class="form-control">
                            <small id="errorDotNgayKetThuc" class="error-message"></small>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Áp dụng cho sản phẩm</label>
                            <select name="giayIds" id="giaySelect" class="form-select" multiple size="8">
                                <c:forEach items="${listGiay}" var="g">
                                    <option value="${g.id}">${g.ten} (${g.thuongHieu})</option>
                                </c:forEach>
                            </select>
                            <div class="mt-2">
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="selectAllGiay()">Chọn tất cả</button>
                                <button type="button" class="btn btn-outline-secondary btn-sm ms-2" onclick="clearAllGiay()">Bỏ chọn tất cả</button>
                            </div>
                            <small class="text-muted">Giữ Ctrl/Cmd để chọn nhiều</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <select name="kichHoat" id="dotKichHoat" class="form-select">
                                <option value="1">Hoạt động</option>
                                <option value="0">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-dark px-4">Lưu đợt giảm giá</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${contextPath}';

    // 1. Validate Form
    function validateForm() {
        let isValid = true;
        resetErrors();

        const ma = document.getElementById('dotMa');
        const ten = document.getElementById('dotTen');
        const ngayBatDau = document.getElementById('dotNgayBatDau');
        const ngayKetThuc = document.getElementById('dotNgayKetThuc');
        const phanTram = document.getElementById('dotPhanTram');
        const soTienGiam = document.getElementById('dotSoTienGiam');

        // Validate Mã
        if (ma.value.trim() === '') {
            showError('errorDotMa', 'Vui lòng nhập mã đợt');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(ma.value.trim())) {
            showError('errorDotMa', 'Mã đợt không được chứa khoảng trắng');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Tên
        if (ten.value.trim() === '') {
            showError('errorDotTen', 'Vui lòng nhập tên đợt');
            ten.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Ngày tháng
        let validDates = true;
        if (ngayBatDau.value === '') {
            showError('errorDotNgayBatDau', 'Vui lòng chọn ngày bắt đầu');
            ngayBatDau.classList.add('is-invalid-custom');
            isValid = false;
            validDates = false;
        }
        if (ngayKetThuc.value === '') {
            showError('errorDotNgayKetThuc', 'Vui lòng chọn ngày kết thúc');
            ngayKetThuc.classList.add('is-invalid-custom');
            isValid = false;
            validDates = false;
        }

        // Logic ngày: Kết thúc phải >= Bắt đầu
        if (validDates) {
            const start = new Date(ngayBatDau.value);
            const end = new Date(ngayKetThuc.value);
            if (end < start) {
                showError('errorDotNgayKetThuc', 'Ngày kết thúc phải sau hoặc bằng ngày bắt đầu');
                ngayKetThuc.classList.add('is-invalid-custom');
                isValid = false;
            }
        }

        // Validate Mức giảm giá (Phải có ít nhất 1 cái, và phải hợp lệ)
        const ptVal = parseFloat(phanTram.value) || 0;
        const tienVal = parseFloat(soTienGiam.value) || 0;

        if (phanTram.value.trim() === '' && soTienGiam.value.trim() === '') {
            showError('errorDotPhanTram', 'Vui lòng nhập phần trăm hoặc số tiền giảm');
            // Không set invalid class để tránh đỏ cả 2 ô gây rối
            isValid = false;
        } else {
            // Check Phần trăm
            if (phanTram.value.trim() !== '') {
                if (ptVal < 0 || ptVal > 100) {
                    showError('errorDotPhanTram', 'Phần trăm giảm phải từ 0 đến 100');
                    phanTram.classList.add('is-invalid-custom');
                    isValid = false;
                }
            }
            // Check Tiền giảm
            if (soTienGiam.value.trim() !== '') {
                if (tienVal < 0) {
                    showError('errorDotSoTienGiam', 'Số tiền giảm không được âm');
                    soTienGiam.classList.add('is-invalid-custom');
                    isValid = false;
                }
            }
        }

        return isValid;
    }

    function showError(elementId, message) {
        document.getElementById(elementId).innerText = message;
    }

    function resetErrors() {
        document.querySelectorAll('.error-message').forEach(el => el.innerText = '');
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('is-invalid-custom'));
    }

    // 2. Logic Form
    function resetForm() {
        resetErrors(); // Xóa lỗi cũ
        document.getElementById('modalTitle').textContent = 'Tạo đợt giảm giá mới';
        document.getElementById('formDot').reset();
        document.getElementById('formDot').action = contextPath + '/quan-ly-dot-giam-gia/add';
        document.getElementById('dotId').value = '';
        const select = document.getElementById('giaySelect');
        for (let opt of select.options) opt.selected = false;
    }

    function editDot(id, ma, ten, moTa, phanTram, soTienGiam, ngayBatDau, ngayKetThuc, kichHoat, selectedGiayIds) {
        resetErrors(); // Xóa lỗi cũ
        document.getElementById('modalTitle').textContent = 'Cập nhật đợt giảm giá';
        document.getElementById('dotId').value = id;
        document.getElementById('dotMa').value = ma;
        document.getElementById('dotTen').value = ten;
        document.getElementById('dotMoTa').value = moTa || '';
        document.getElementById('dotPhanTram').value = phanTram === 'null' ? '' : phanTram;
        document.getElementById('dotSoTienGiam').value = soTienGiam === 'null' ? '' : soTienGiam;
        document.getElementById('dotNgayBatDau').value = ngayBatDau;
        document.getElementById('dotNgayKetThuc').value = ngayKetThuc;
        document.getElementById('dotKichHoat').value = kichHoat;

        const select = document.getElementById('giaySelect');
        for (let option of select.options) {
            option.selected = selectedGiayIds.includes(parseInt(option.value));
        }

        document.getElementById('formDot').action = contextPath + '/quan-ly-dot-giam-gia/update';
        const modal = new bootstrap.Modal(document.getElementById('modalDotGiamGia'));
        modal.show();
    }

    function selectAllGiay() {
        document.querySelectorAll('#giaySelect option').forEach(opt => opt.selected = true);
    }

    function clearAllGiay() {
        document.querySelectorAll('#giaySelect option').forEach(opt => opt.selected = false);
    }

    function toggleStatus(id, currentStatus) {
        if (!confirm(currentStatus == 1
            ? 'Bạn có chắc muốn tắt đợt giảm giá này?'
            : 'Bạn có chắc muốn bật lại đợt giảm giá này?')) {
            return;
        }
        fetch(contextPath + '/quan-ly-dot-giam-gia/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'id=' + id
        })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Lỗi: ' + (data.message || 'Không thể thay đổi trạng thái'));
                }
            })
            .catch(() => alert('Lỗi kết nối!'));
    }

    document.querySelectorAll('.toast').forEach(toast => new bootstrap.Toast(toast).show());
</script>
</body>
</html>