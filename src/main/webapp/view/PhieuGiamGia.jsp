<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="now" class="java.util.Date"/>
<html>
<head>
    <title>Quản lý phiếu giảm giá</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .content { margin-left: 260px; padding: 20px; }
        .search-box { border-radius: 12px; padding: 14px 20px; border: 1px solid #e2e8f0; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .search-box:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.25rem rgba(13,110,253,.25); }
        .stat-card { background: #fff; border-radius: 12px; padding: 16px 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); text-align: center; }
        .stat-number { font-size: 2rem; font-weight: 700; }
        .stat-label { font-size: 0.9rem; color: #64748b; margin-top: 4px; }
        .voucher-avatar { width: 48px; height: 48px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #64748b; }
        .badge-type { font-size: 0.75rem; padding: 0.35em 0.9em; border-radius: 50rem; font-weight: 600; }
        .badge-status { font-size: 0.75rem; padding: 0.35em 0.9em; border-radius: 50rem; font-weight: 600; }
        .action-icon { font-size: 1.2rem; color: #64748b; cursor: pointer; }
        .action-icon:hover { color: #0d6efd; }
        .table thead { background-color: #f8f9fa; }
        .toast-container { position: fixed; top: 20px; right: 20px; z-index: 9999; }
        .form-error { color: #dc3545; font-size: 0.875rem; margin-top: 4px; }
    </style>
</head>
<body>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content">
    <% request.setAttribute("pageTitle", "Quản lý phiếu giảm giá"); %>
    <%@ include file="/layout/header.jsp" %>

    <div class="mb-4">
        <p class="text-secondary">Tạo và quản lý các phiếu giảm giá cho khách hàng</p>
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
                <input type="text" class="form-control  search-box ps-5" placeholder="Tìm kiếm theo mã, tên phiếu..." id="searchInput">
            </div>
        </div>
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="filterLoai">
                <option value="">Tất cả loại</option>
                <option value="1">Phần trăm (%)</option>
                <option value="2">Số tiền</option>
                <option value="3">Miễn phí</option>
            </select>
            <button class="btn btn-dark rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalPhieu" onclick="resetForm()">
                + Tạo phiếu giảm giá
            </button>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3"><div class="stat-card d-flex align-items-center"><div class="me-4"><div class="stat-number text-primary">${totalPhieu}</div><div class="stat-label">Tổng phiếu</div></div><div class="voucher-avatar"><i class="bi bi-ticket-perforated"></i></div></div></div>
        <div class="col-md-3"><div class="stat-card d-flex align-items-center"><div class="me-4"><div class="stat-number text-success">${dangHoatDong}</div><div class="stat-label">Đang hoạt động</div></div><div class="voucher-avatar text-success"><i class="bi bi-check-circle"></i></div></div></div>
        <div class="col-md-3"><div class="stat-card d-flex align-items-center"><div class="me-4"><div class="stat-number text-danger">${hetHan}</div><div class="stat-label">Hết hạn</div></div><div class="voucher-avatar text-danger"><i class="bi bi-calendar-x"></i></div></div></div>
        <div class="col-md-3"><div class="stat-card d-flex align-items-center"><div class="me-4"><div class="stat-number text-warning">${hetSoLuong}</div><div class="stat-label">Hết số lượng</div></div><div class="voucher-avatar text-warning"><i class="bi bi-exclamation-triangle"></i></div></div></div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Mã phiếu</th>
                    <th>Tên phiếu</th>
                    <th>Loại</th>
                    <th>Giá trị</th>
                    <th>Đơn tối thiểu</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Số lượng</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageItems}" var="p">
                    <tr data-loai="${p.loai}">
                        <td><div class="fw-semibold text-primary">${p.ma}</div></td>
                        <td>${p.ten}</td>
                        <td>
                            <span class="badge ${p.loai == 1 ? 'bg-success' : p.loai == 2 ? 'bg-info' : 'bg-warning'} badge-type">
                                    ${p.loai == 1 ? 'Phần trăm (%)' : p.loai == 2 ? 'Số tiền' : 'Miễn phí'}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.loai == 1}">
                                    ${p.giaTri}%
                                    <c:if test="${p.giaTriToiDa > 0}">
                                        <div class="text-muted small">(Tối đa: <fmt:formatNumber value="${p.giaTriToiDa}" type="currency" currencySymbol="₫"/>)</div>
                                    </c:if>
                                </c:when>
                                <c:when test="${p.loai == 2}"><fmt:formatNumber value="${p.giaTri}" type="currency" currencySymbol="₫"/></c:when>
                                <c:otherwise>Miễn phí</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.dieuKien > 0}"><fmt:formatNumber value="${p.dieuKien}" type="currency" currencySymbol="₫"/></c:when>
                                <c:otherwise><span class="text-muted small">0₫</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${p.ngayBatDau}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${p.ngayKetThuc}" pattern="dd/MM/yyyy"/></td>
                        <td><span class="badge bg-dark">${p.soLuong}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.kichHoat == 1 && p.soLuong > 0 && p.ngayBatDau <= now && p.ngayKetThuc >= now}">
                                    <span class="badge bg-success badge-status">Đang hoạt động</span>
                                </c:when>
                                <c:when test="${p.soLuong <= 0}">
                                    <span class="badge bg-warning badge-status">Hết số lượng</span>
                                </c:when>
                                <c:when test="${p.ngayKetThuc < now}">
                                    <span class="badge bg-danger badge-status">Hết hạn</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary badge-status">Không hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <span class="action-icon me-3" title="Sửa"
                                  onclick="editPhieu('${p.id}', '${p.ma}', '${p.ten}', ${p.loai}, ${p.giaTri},
                                      ${p.dieuKien == null ? 0 : p.dieuKien},
                                      ${p.giaTriToiDa == null ? 0 : p.giaTriToiDa},
                                          '<fmt:formatDate value="${p.ngayBatDau}" pattern="yyyy-MM-dd"/>',
                                          '<fmt:formatDate value="${p.ngayKetThuc}" pattern="yyyy-MM-dd"/>',
                                      ${p.soLuong}, ${p.kichHoat})">
                                <i class="bi bi-pencil-square"></i>
                            </span>
                            <span class="action-icon text-danger" title="Xóa"
                                  onclick="if(confirm('Xóa phiếu giảm giá này?')) location.href='${contextPath}/quan-ly-phieu-giam-gia/delete?id=${p.id}'">
                                <i class="bi bi-trash"></i>
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
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}">Trước</a></li>
                    <c:forEach begin="1" end="${totalPages}" var="i"><li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="?page=${i}">${i}</a></li></c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}">Sau</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<div class="modal fade" id="modalPhieu" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="formPhieu" action="${contextPath}/quan-ly-phieu-giam-gia/add" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="id" id="phieuId">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="modalTitle">Tạo phiếu giảm giá mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã phiếu <span class="text-danger">*</span></label>
                            <input name="ma" id="phieuMa" class="form-control" onblur="checkMaTrung()">
                            <div class="form-error" id="maError"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên phiếu <span class="text-danger">*</span></label>
                            <input name="ten" id="phieuTen" class="form-control">
                            <div class="form-error" id="tenError"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Loại <span class="text-danger">*</span></label>
                            <select name="loai" id="phieuLoai" class="form-select" onchange="toggleGiaTriField()">
                                <option value="1">Phần trăm (%)</option>
                                <option value="2">Số tiền</option>
                                <option value="3">Miễn phí</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" id="labelGiaTri">Giá trị <span class="text-danger">*</span></label>
                            <input type="number" name="giaTri" id="phieuGiaTri" class="form-control" min="0">
                            <div class="form-error" id="giaTriError"></div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Đơn hàng tối thiểu (₫)</label>
                            <input type="number" name="dieuKien" id="phieuDieuKien" class="form-control" min="0" value="0">
                            <div class="form-text text-muted small">0 = Không yêu cầu.</div>
                            <div class="form-error" id="dieuKienError"></div>
                        </div>

                        <div class="col-md-6" id="divGiaTriToiDa" style="display: none;">
                            <label class="form-label">Giảm tối đa (₫) <span class="text-danger">*</span></label>
                            <input type="number" name="giaTriToiDa" id="phieuGiaTriToiDa" class="form-control" min="0" value="0">
                            <div class="form-text text-muted small">Áp dụng cho voucher %.</div>
                            <div class="form-error" id="giaTriToiDaError"></div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                            <input type="number" name="soLuong" id="phieuSoLuong" class="form-control" min="0">
                            <div class="form-error" id="soLuongError"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                            <input type="date" name="ngayBatDau" id="phieuNgayBatDau" class="form-control">
                            <div class="form-error" id="ngayBatDauError"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                            <input type="date" name="ngayKetThuc" id="phieuNgayKetThuc" class="form-control">
                            <div class="form-error" id="ngayKetThucError"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <select name="kichHoat" id="phieuKichHoat" class="form-select">
                                <option value="1">Hoạt động</option>
                                <option value="0">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-dark px-4">Lưu phiếu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${contextPath}';
    const maList = [<c:forEach items="${listPhieu}" var="p">"<c:out value='${p.ma}'/>",</c:forEach>""];
    let maTrung = false;

    function resetForm() {
        document.getElementById('modalTitle').textContent = 'Tạo phiếu giảm giá mới';
        document.getElementById('formPhieu').reset();
        document.getElementById('formPhieu').action = contextPath + '/quan-ly-phieu-giam-gia/add';
        document.getElementById('phieuId').value = '';
        document.getElementById('phieuDieuKien').value = 0;
        document.getElementById('phieuGiaTriToiDa').value = 0; // Reset
        document.querySelectorAll('.form-error').forEach(e => e.textContent = '');
        maTrung = false;
        toggleGiaTriField();
    }

    // [MỚI] Thêm tham số giaTriToiDa
    function editPhieu(id, ma, ten, loai, giaTri, dieuKien, giaTriToiDa, ngayBatDau, ngayKetThuc, soLuong, kichHoat) {
        document.getElementById('modalTitle').textContent = 'Cập nhật phiếu giảm giá';
        document.getElementById('phieuId').value = id;
        document.getElementById('phieuMa').value = ma;
        document.getElementById('phieuTen').value = ten;
        document.getElementById('phieuLoai').value = loai;
        document.getElementById('phieuGiaTri').value = giaTri;
        document.getElementById('phieuDieuKien').value = dieuKien;
        document.getElementById('phieuGiaTriToiDa').value = giaTriToiDa; // Set
        document.getElementById('phieuNgayBatDau').value = ngayBatDau;
        document.getElementById('phieuNgayKetThuc').value = ngayKetThuc;
        document.getElementById('phieuSoLuong').value = soLuong;
        document.getElementById('phieuKichHoat').value = kichHoat;
        document.getElementById('formPhieu').action = contextPath + '/quan-ly-phieu-giam-gia/update';
        document.querySelectorAll('.form-error').forEach(e => e.textContent = '');
        maTrung = false;
        toggleGiaTriField();
        new bootstrap.Modal(document.getElementById('modalPhieu')).show();
    }

    function toggleGiaTriField() {
        const loai = document.getElementById('phieuLoai').value;
        const giaTriField = document.getElementById('phieuGiaTri');
        const label = document.getElementById('labelGiaTri');

        // [MỚI] Điều khiển hiển thị ô Giá trị tối đa
        const divToiDa = document.getElementById('divGiaTriToiDa');
        const inputToiDa = document.getElementById('phieuGiaTriToiDa');

        if (loai == 3) { // Free
            giaTriField.disabled = true;
            giaTriField.value = 0;
            label.innerHTML = 'Giá trị (Không áp dụng)';
            divToiDa.style.display = 'none';
        } else {
            giaTriField.disabled = false;
            if (loai == 1) { // Phần trăm
                label.innerHTML = 'Giá trị (%) <span class="text-danger">*</span>';
                giaTriField.max = 100;
                divToiDa.style.display = 'block'; // Hiện tối đa
            } else { // Số tiền
                label.innerHTML = 'Giá trị (₫) <span class="text-danger">*</span>';
                giaTriField.removeAttribute('max');
                divToiDa.style.display = 'none'; // Ẩn tối đa
                inputToiDa.value = 0;
            }
        }
    }

    function checkMaTrung() {
        const ma = document.getElementById('phieuMa').value.trim().toUpperCase();
        const id = document.getElementById('phieuId').value;
        const error = document.getElementById('maError');
        if (ma === '') { error.textContent = ''; maTrung = false; return; }
        if (maList.includes(ma) && (id === '' || !maList.includes(ma))) {
            error.textContent = 'Mã phiếu đã tồn tại!';
            maTrung = true;
        } else { error.textContent = ''; maTrung = false; }
    }

    function validateForm() {
        let valid = true;
        document.querySelectorAll('.form-error').forEach(e => e.textContent = '');
        const ma = document.getElementById('phieuMa').value.trim();
        const ten = document.getElementById('phieuTen').value.trim();
        const loai = parseInt(document.getElementById('phieuLoai').value);
        const giaTri = parseFloat(document.getElementById('phieuGiaTri').value);
        const dieuKien = parseFloat(document.getElementById('phieuDieuKien').value) || 0;
        const giaTriToiDa = parseFloat(document.getElementById('phieuGiaTriToiDa').value) || 0;
        const ngayBatDau = document.getElementById('phieuNgayBatDau').value;
        const ngayKetThuc = document.getElementById('phieuNgayKetThuc').value;
        const soLuong = parseInt(document.getElementById('phieuSoLuong').value) || 0;

        if (ma === '') { document.getElementById('maError').textContent = 'Mã phiếu không được để trống'; valid = false; }
        if (ten === '') { document.getElementById('tenError').textContent = 'Tên phiếu không được để trống'; valid = false; }
        if (loai != 3 && giaTri <= 0) { document.getElementById('giaTriError').textContent = 'Giá trị phải lớn hơn 0'; valid = false; }
        if (ngayBatDau === '') { document.getElementById('ngayBatDauError').textContent = 'Chọn ngày bắt đầu'; valid = false; }
        if (ngayKetThuc === '') { document.getElementById('ngayKetThucError').textContent = 'Chọn ngày kết thúc'; valid = false; }
        if (new Date(ngayKetThuc) < new Date(ngayBatDau)) { document.getElementById('ngayKetThucError').textContent = 'Ngày kết thúc phải sau ngày bắt đầu'; valid = false; }
        if (soLuong < 0) { document.getElementById('soLuongError').textContent = 'Số lượng không được âm'; valid = false; }
        if (dieuKien < 0) { document.getElementById('dieuKienError').textContent = 'Điều kiện không được âm'; valid = false; }

        // Logic cũ: Tiền mặt thì Giá giảm <= Điều kiện
        if (loai == 2 && giaTri > dieuKien) {
            document.getElementById('giaTriError').textContent = 'Giá trị giảm không được lớn hơn đơn tối thiểu';
            valid = false;
        }

        // Logic MỚI: Phần trăm thì Tối đa > 0
        if (loai == 1 && giaTriToiDa <= 0) {
            document.getElementById('giaTriToiDaError').textContent = 'Voucher % phải có mức giảm tối đa > 0';
            valid = false;
        }

        if (maTrung) { valid = false; }
        return valid;
    }

    document.getElementById('searchInput')?.addEventListener('keyup', function () {
        const query = this.value.toLowerCase();
        document.querySelectorAll('tbody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    });
    document.getElementById('filterLoai')?.addEventListener('change', function () {
        const loai = this.value;
        document.querySelectorAll('tbody tr').forEach(row => {
            const rowLoai = row.dataset.loai;
            row.style.display = (loai === '' || rowLoai == loai) ? '' : 'none';
        });
    });
    document.querySelectorAll('.toast').forEach(toast => new bootstrap.Toast(toast).show());
</script>
</body>
</html>