<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>Quản lý khách hàng</title>
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
        .customer-avatar { width: 48px; height: 48px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #64748b; }
        .badge-status { font-size: 0.75rem; padding: 0.35em 0.9em; border-radius: 50rem; font-weight: 600; }
        .action-icon { font-size: 1.2rem; color: #64748b; cursor: pointer; }
        .action-icon:hover { color: #0d6efd; }
        .pagination .page-link { border-radius: 0.5rem; padding: 0.5rem 1rem; margin: 0 4px; }
        .pagination .page-item.active .page-link { background-color: #0d6efd; border-color: #0d6efd; }
        #modalChiTietKH label { font-size: 0.8rem; }
        #modalChiTietKH .fw-semibold { color: #2c2c2c; }

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
    <% request.setAttribute("pageTitle", "Quản lý khách hàng"); %>
    <%@ include file="/layout/header.jsp" %>

    <div class="mb-4">
        <p class="text-secondary">Quản lý thông tin và tài khoản khách hàng</p>
    </div>
    <div class="mt-3"><hr></div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="flex-grow-1 me-3">
            <div class="position-relative">
                <i class="bi bi-search position-absolute ms-2 top-50 start-3 translate-middle-y text-muted"></i>
                <input type="text" class="form-control search-box ps-5" placeholder="Tìm kiếm theo tên, email, số điện thoại..." id="searchInput">
            </div>
        </div>
        <button class="btn btn-dark rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalKhachHang" onclick="resetForm()">
            + Thêm khách hàng
        </button>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-primary">${totalKhachHang}</div>
                    <div class="stat-label">Tổng khách hàng</div>
                </div>
                <div class="customer-avatar"><i class="bi bi-people"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-success">${khachHangHoatDong}</div>
                    <div class="stat-label">Khách hàng hoạt động</div>
                </div>
                <div class="customer-avatar text-success"><i class="bi bi-person-check"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-danger">${khachHangTamKhoa}</div>
                    <div class="stat-label">Khách hàng tạm khóa</div>
                </div>
                <div class="customer-avatar text-danger"><i class="bi bi-person-x"></i></div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm p-2">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Khách hàng</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Địa chỉ</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageItems}" var="kh">
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="customer-avatar me-3"><i class="bi bi-person"></i></div>
                                <div>
                                    <div class="fw-semibold">${kh.hoTen}</div>
                                    <small class="text-muted">ID: ${kh.id}</small>
                                </div>
                            </div>
                        </td>
                        <td>${kh.email != null ? kh.email : '—'}</td>
                        <td>${kh.sdt}</td>
                        <td>${kh.diaChi != null ? kh.diaChi : '—'}</td>
                        <td>
                            <span class="badge ${kh.trangThai == 1 ? 'bg-success' : 'bg-danger'} badge-status">
                                    ${kh.trangThai == 1 ? 'Hoạt động' : 'Tạm khóa'}
                            </span>
                        </td>
                        <td class="text-center">
                            <span class="action-icon me-3" title="Xem chi tiết" onclick="showChiTiet('${kh.id}', '${kh.hoTen}', '${kh.email}', '${kh.sdt}', '${kh.diaChi}', '${kh.tenDangNhap}', ${kh.trangThai})">
                                <i class="bi bi-eye"></i>
                            </span>
                            <span class="action-icon me-3" title="Sửa"
                                  onclick="editKhachHang('${kh.id}', '${kh.hoTen}', '${kh.email}', '${kh.sdt}', '${kh.diaChi}', '${kh.tenDangNhap}', '${kh.matKhau}', ${kh.trangThai})">
                                <i class="bi bi-pencil-square"></i>
                            </span>
                            <c:choose>
                                <c:when test="${kh.trangThai == 1}">
                                    <span class="action-icon text-danger" title="Khóa tài khoản"
                                          onclick="if(confirm('Khóa tài khoản này?')) location.href='${contextPath}/quan-ly-khach-hang/delete?id=${kh.id}'">
                                        <i class="bi bi-lock"></i>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="action-icon text-success" title="Mở khóa tài khoản"
                                          onclick="if(confirm('Mở khóa tài khoản này?')) location.href='${contextPath}/quan-ly-khach-hang/unlock?id=${kh.id}'">
                                        <i class="bi bi-unlock"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>
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

<div class="modal fade" id="modalKhachHang" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <form id="formKH" action="${contextPath}/quan-ly-khach-hang/add" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="id" id="khId">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="modalTitleKH">Thêm khách hàng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                            <input name="hoTen" id="khHoTen" class="form-control">
                            <small id="errorHoTen" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input name="sdt" id="khSdt" class="form-control">
                            <small id="errorSdt" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input name="email" id="khEmail" type="text" class="form-control">
                            <small id="errorEmail" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input name="tenDangNhap" id="khTenDangNhap" class="form-control">
                            <small id="errorTenDangNhap" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="matKhau" id="khMatKhau" class="form-control">
                            <small id="errorMatKhau" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <select name="trangThai" id="khTrangThai" class="form-select">
                                <option value="1">Hoạt động</option>
                                <option value="0">Tạm khóa</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="diaChi" id="khDiaChi" class="form-control" rows="2"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-dark px-4">Lưu khách hàng</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalChiTietKH" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content rounded-4 shadow border-0">
            <div class="modal-header border-0 pb-0">
                <h4 class="modal-title fw-bold">Chi tiết khách hàng</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="p-4 bg-light rounded-4 shadow-sm">
                            <div class="mb-3"><label class="text-muted small">Mã khách hàng</label><div class="fw-semibold fs-6" id="detailId"></div></div>
                            <div class="mb-3"><label class="text-muted small">Họ tên</label><div class="fw-semibold fs-6" id="detailHoTen"></div></div>
                            <div class="mb-3"><label class="text-muted small">Số điện thoại</label><div class="fw-semibold fs-6" id="detailSdt"></div></div>
                            <div class="mb-3"><label class="text-muted small">Email</label><div class="fw-semibold fs-6" id="detailEmail"></div></div>
                            <div class="mb-3"><label class="text-muted small">Địa chỉ</label><div class="fw-semibold fs-6" id="detailDiaChi"></div></div>
                            <div class="mb-3"><label class="text-muted small">Tên đăng nhập</label><div class="fw-semibold fs-6" id="detailTenDangNhap"></div></div>
                            <div class=""><label class="text-muted small">Trạng thái</label><div class="fw-semibold fs-6" id="detailTrangThai"></div></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h6 class="fw-bold mb-2">Lịch sử mua hàng</h6>
                        <div class="bg-light rounded-4 p-5 text-center text-muted shadow-sm">
                            <i class="bi bi-receipt fs-1"></i>
                            <p class="mt-3">Chưa có đơn hàng</p>
                        </div>
                    </div>
                </div>
            </div>
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

        const hoTen = document.getElementById('khHoTen');
        const sdt = document.getElementById('khSdt');
        const email = document.getElementById('khEmail');
        const tenDangNhap = document.getElementById('khTenDangNhap');
        const matKhau = document.getElementById('khMatKhau');
        const id = document.getElementById('khId').value;

        // Validate Họ tên
        if (hoTen.value.trim() === '') {
            showError('errorHoTen', 'Vui lòng nhập họ tên');
            hoTen.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate SĐT (10 số, bắt đầu bằng 0)
        if (sdt.value.trim() === '') {
            showError('errorSdt', 'Vui lòng nhập số điện thoại');
            sdt.classList.add('is-invalid-custom');
            isValid = false;
        } else if (!/^0\d{9}$/.test(sdt.value.trim())) {
            showError('errorSdt', 'Số điện thoại không hợp lệ (10 số, bắt đầu là 0)');
            sdt.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Tên đăng nhập
        if (tenDangNhap.value.trim() === '') {
            showError('errorTenDangNhap', 'Vui lòng nhập tên đăng nhập');
            tenDangNhap.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(tenDangNhap.value.trim())) {
            showError('errorTenDangNhap', 'Tên đăng nhập không được chứa khoảng trắng');
            tenDangNhap.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Mật khẩu
        // Nếu là Thêm mới (id rỗng) -> Bắt buộc
        if (id === '' && matKhau.value.trim() === '') {
            showError('errorMatKhau', 'Vui lòng nhập mật khẩu');
            matKhau.classList.add('is-invalid-custom');
            isValid = false;
        }
        // Nếu nhập mật khẩu (cả thêm mới và sửa) thì phải >= 6 ký tự (tuỳ chọn thêm)
        if (matKhau.value.trim() !== '' && matKhau.value.length < 6) {
            showError('errorMatKhau', 'Mật khẩu phải có ít nhất 6 ký tự');
            matKhau.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Email (Không bắt buộc, nhưng nếu nhập thì phải đúng)
        if (email.value.trim() !== '') {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email.value.trim())) {
                showError('errorEmail', 'Email không đúng định dạng');
                email.classList.add('is-invalid-custom');
                isValid = false;
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
        document.getElementById('modalTitleKH').textContent = 'Thêm khách hàng mới';
        document.getElementById('formKH').reset();
        document.getElementById('formKH').action = contextPath + '/quan-ly-khach-hang/add';
        document.getElementById('khId').value = '';
        document.getElementById('khMatKhau').type = 'password';
        // document.getElementById('khMatKhau').required = true; // Đã bỏ required HTML
    }

    function editKhachHang(id, hoTen, email, sdt, diaChi, tenDangNhap, matKhau, trangThai) {
        resetErrors(); // Xóa lỗi cũ
        document.getElementById('modalTitleKH').textContent = 'Cập nhật khách hàng';
        document.getElementById('khId').value = id;
        document.getElementById('khHoTen').value = hoTen;
        document.getElementById('khEmail').value = email || '';
        document.getElementById('khSdt').value = sdt;
        document.getElementById('khDiaChi').value = diaChi || '';
        document.getElementById('khTenDangNhap').value = tenDangNhap || '';

        document.getElementById('khMatKhau').value = matKhau || '';
        document.getElementById('khMatKhau').type = 'text'; // Hiện text để dễ sửa

        document.getElementById('khTrangThai').value = trangThai;
        document.getElementById('formKH').action = contextPath + '/quan-ly-khach-hang/update';
        new bootstrap.Modal(document.getElementById('modalKhachHang')).show();
    }

    function showChiTiet(id, hoTen, email, sdt, diaChi, tenDangNhap, trangThai) {
        document.getElementById('detailId').textContent = id;
        document.getElementById('detailHoTen').textContent = hoTen;
        document.getElementById('detailEmail').textContent = email || '—';
        document.getElementById('detailSdt').textContent = sdt;
        document.getElementById('detailDiaChi').textContent = diaChi || '—';
        document.getElementById('detailTenDangNhap').textContent = tenDangNhap || '—';
        document.getElementById('detailTrangThai').innerHTML = trangThai == 1
            ? '<span class="badge bg-success">Hoạt động</span>'
            : '<span class="badge bg-danger">Tạm khóa</span>';
        new bootstrap.Modal(document.getElementById('modalChiTietKH')).show();
    }

    // Tìm kiếm realtime
    document.getElementById('searchInput')?.addEventListener('keyup', function () {
        const query = this.value.toLowerCase();
        document.querySelectorAll('tbody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    });
</script>
</body>
</html>