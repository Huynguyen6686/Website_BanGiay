<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>Quản lý nhân viên</title>
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
        .employee-avatar { width: 48px; height: 48px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #64748b; }
        .badge-role { font-size: 0.75rem; padding: 0.35em 0.9em; border-radius: 50rem; font-weight: 600; }
        .badge-status { font-size: 0.75rem; padding: 0.35em 0.9em; border-radius: 50rem; font-weight: 600; }
        .action-icon { font-size: 1.2rem; color: #64748b; cursor: pointer; }
        .action-icon:hover { color: #0d6efd; }
        .pagination .page-link { border-radius: 0.5rem; padding: 0.5rem 1rem; margin: 0 4px; }
        .pagination .page-item.active .page-link { background-color: #0d6efd; border-color: #0d6efd; }
        #modalChiTietNV label { font-size: 0.8rem; }
        #modalChiTietNV .fw-semibold { color: #2c2c2c; }

        /* CSS cho thông báo lỗi validation */
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
    <% request.setAttribute("pageTitle", "Quản lý nhân viên"); %>
    <%@ include file="/layout/header.jsp" %>

    <div class="mb-4">
        <p class="text-secondary">Quản lý thông tin và phân quyền nhân viên</p>
    </div>
    <div class="mt-3"><hr></div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="flex-grow-1 me-3">
            <div class="position-relative">
                <i class="bi bi-search position-absolute top-50 ms-3 start-3 translate-middle-y text-muted"></i>
                <input type="text" class="form-control search-box ps-5" placeholder="Tìm kiếm theo tên, email, số điện thoại..." id="searchInput">
            </div>
        </div>
        <button class="btn btn-dark rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#modalNhanVien" onclick="resetForm()">
            + Thêm nhân viên
        </button>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-primary">${totalNhanVien}</div>
                    <div class="stat-label">Tổng nhân viên</div>
                </div>
                <div class="employee-avatar"><i class="bi bi-people"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-purple">${soQuanLy}</div>
                    <div class="stat-label">Quản lý</div>
                </div>
                <div class="employee-avatar text-purple"><i class="bi bi-person-badge"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card d-flex align-items-center">
                <div class="me-4">
                    <div class="stat-number text-success">${nhanVienHoatDong}</div>
                    <div class="stat-label">Đang hoạt động</div>
                </div>
                <div class="employee-avatar text-success"><i class="bi bi-person-check"></i></div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Nhân viên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageItems}" var="nv">
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="employee-avatar me-3"><i class="bi bi-person"></i></div>
                                <div>
                                    <div class="fw-semibold">${nv.hoTen}</div>
                                    <small class="text-muted">@${nv.tenDangNhap}</small>
                                </div>
                            </div>
                        </td>
                        <td>${nv.email}</td>
                        <td>${nv.sdt}</td>
                        <td>
                            <span class="badge ${nv.role.ten == 'Admin' ? 'bg-danger' : 'bg-info'} badge-role">
                                    ${nv.role.ten}
                            </span>
                        </td>
                        <td>
                            <span class="badge ${nv.trangThai == 1 ? 'bg-success' : 'bg-secondary'} badge-status">
                                    ${nv.trangThai == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                            </span>
                        </td>
                        <td class="text-center">
                            <span class="action-icon me-3" title="Xem chi tiết" onclick="showChiTiet('${nv.id}', '${nv.hoTen}', '${nv.email}', '${nv.sdt}', '${nv.diaChi}', '${nv.tenDangNhap}', '${nv.role.ten}', ${nv.trangThai})">
                                <i class="bi bi-eye"></i>
                            </span>
                            <span class="action-icon me-3" title="Sửa"
                                  onclick="editNhanVien('${nv.id}', '${nv.hoTen}', '${nv.email}', '${nv.sdt}', '${nv.diaChi}', '${nv.tenDangNhap}', '${nv.matKhau}', '${nv.role.id}', ${nv.trangThai})">
                                <i class="bi bi-pencil-square"></i>
                            </span>
                            <c:choose>
                                <c:when test="${nv.trangThai == 1}">
                                    <span class="action-icon text-danger" title="Ngừng hoạt động"
                                          onclick="if(confirm('Ngừng hoạt động nhân viên này?')) location.href='${contextPath}/quan-ly-nhan-vien/delete?id=${nv.id}'">
                                        <i class="bi bi-person-x"></i>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="action-icon text-success" title="Kích hoạt lại"
                                          onclick="if(confirm('Kích hoạt lại nhân viên này?')) location.href='${contextPath}/quan-ly-nhan-vien/unlock?id=${nv.id}'">
                                        <i class="bi bi-person-check"></i>
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

<div class="modal fade" id="modalNhanVien" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <form id="formNV" action="${contextPath}/quan-ly-nhan-vien/add" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="id" id="nvId">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="modalTitleNV">Thêm nhân viên mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input name="hoTen" id="nvHoTen" class="form-control">
                            <small id="errorHoTen" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input name="sdt" id="nvSdt" class="form-control">
                            <small id="errorSdt" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input name="email" id="nvEmail" type="text" class="form-control">
                            <small id="errorEmail" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input name="tenDangNhap" id="nvTenDangNhap" class="form-control">
                            <small id="errorTenDangNhap" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="matKhau" id="nvMatKhau" class="form-control">
                            <small id="errorMatKhau" class="error-message"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                            <select name="roleId" id="nvRoleId" class="form-select">
                                <c:forEach items="${listRole}" var="r">
                                    <option value="${r.id}">${r.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="diaChi" id="nvDiaChi" class="form-control" rows="2"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-dark px-4">Lưu nhân viên</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalChiTietNV" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow rounded-4">
            <div class="modal-header border-0 pb-0">
                <h4 class="modal-title fw-bold">Chi tiết nhân viên</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4 align-items-start">
                    <div class="col-md-4 text-center">
                        <div class="p-3 d-flex flex-column align-items-center">
                            <div class="rounded-circle bg-secondary bg-opacity-25 d-flex align-items-center justify-content-center shadow-sm" style="width: 130px; height: 130px;">
                                <i class="bi bi-person fs-1 text-secondary"></i>
                            </div>
                            <p class="fw-semibold mt-3 mb-0" id="detailHoTenAvatar"></p>
                            <span class="text-muted small" id="detailMaAvatar"></span>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="row g-3">
                            <div class="col-6"><label class="text-muted small">Họ tên</label><div class="fw-semibold fs-6" id="detailHoTen"></div></div>
                            <div class="col-6"><label class="text-muted small">Mã nhân viên</label><div class="fw-semibold fs-6" id="detailMa"></div></div>
                            <div class="col-6"><label class="text-muted small">Số điện thoại</label><div class="fw-semibold fs-6" id="detailSdt"></div></div>
                            <div class="col-6"><label class="text-muted small">Email</label><div class="fw-semibold fs-6" id="detailEmail"></div></div>
                            <div class="col-12"><label class="text-muted small">Địa chỉ</label><div class="fw-semibold fs-6" id="detailDiaChi"></div></div>
                            <div class="col-6"><label class="text-muted small">Tên đăng nhập</label><div class="fw-semibold fs-6" id="detailTenDangNhap"></div></div>
                            <div class="col-6"><label class="text-muted small">Vai trò</label><div class="fw-semibold fs-6" id="detailVaiTro"></div></div>
                            <div class="col-6"><label class="text-muted small">Trạng thái</label><div class="fw-semibold fs-6" id="detailTrangThai"></div></div>
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

    // 1. Hàm Validate Form
    function validateForm() {
        let isValid = true;

        // Lấy giá trị các trường
        const hoTen = document.getElementById('nvHoTen');
        const sdt = document.getElementById('nvSdt');
        const email = document.getElementById('nvEmail');
        const tenDangNhap = document.getElementById('nvTenDangNhap');
        const matKhau = document.getElementById('nvMatKhau');

        // Reset lỗi cũ
        resetErrors();

        // 1. Validate Họ tên (Không được để trống)
        if (hoTen.value.trim() === '') {
            showError('errorHoTen', 'Vui lòng nhập họ và tên');
            hoTen.classList.add('is-invalid-custom');
            isValid = false;
        }

        // 2. Validate Số điện thoại (Không trống, định dạng số VN 10 số)
        const phoneRegex = /(84|0[3|5|7|8|9])+([0-9]{8})\b/; // Regex đơn giản cho VN
        // Hoặc đơn giản hơn: /^0\d{9}$/ (bắt đầu bằng 0 và có 10 số)
        if (sdt.value.trim() === '') {
            showError('errorSdt', 'Vui lòng nhập số điện thoại');
            sdt.classList.add('is-invalid-custom');
            isValid = false;
        } else if (!/^0\d{9}$/.test(sdt.value.trim())) {
            showError('errorSdt', 'Số điện thoại không hợp lệ (cần 10 số, bắt đầu bằng 0)');
            sdt.classList.add('is-invalid-custom');
            isValid = false;
        }

        // 3. Validate Email (Không trống, đúng định dạng)
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email.value.trim() === '') {
            showError('errorEmail', 'Vui lòng nhập địa chỉ email');
            email.classList.add('is-invalid-custom');
            isValid = false;
        } else if (!emailRegex.test(email.value.trim())) {
            showError('errorEmail', 'Email không đúng định dạng');
            email.classList.add('is-invalid-custom');
            isValid = false;
        }

        // 4. Validate Tên đăng nhập (Không trống, không chứa khoảng trắng - tùy chọn)
        if (tenDangNhap.value.trim() === '') {
            showError('errorTenDangNhap', 'Vui lòng nhập tên đăng nhập');
            tenDangNhap.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(tenDangNhap.value.trim())) {
            showError('errorTenDangNhap', 'Tên đăng nhập không được chứa khoảng trắng');
            tenDangNhap.classList.add('is-invalid-custom');
            isValid = false;
        }

        // 5. Validate Mật khẩu (Chỉ bắt buộc khi Thêm mới hoặc nếu người dùng nhập vào khi Sửa)
        // Nếu là Thêm mới (id rỗng) -> Bắt buộc
        // Nếu là Sửa (id có) -> Nếu để trống thì giữ nguyên pass cũ, nếu nhập thì validate
        const isEditMode = document.getElementById('nvId').value !== '';

        if (!isEditMode && matKhau.value.trim() === '') {
            showError('errorMatKhau', 'Vui lòng nhập mật khẩu');
            matKhau.classList.add('is-invalid-custom');
            isValid = false;
        }
        // Nếu muốn check độ dài mật khẩu > 6 ký tự
        if (matKhau.value.trim() !== '' && matKhau.value.length < 6) {
            showError('errorMatKhau', 'Mật khẩu phải từ 6 ký tự trở lên');
            matKhau.classList.add('is-invalid-custom');
            isValid = false;
        }

        return isValid;
    }

    // Hàm hiển thị lỗi
    function showError(elementId, message) {
        document.getElementById(elementId).innerText = message;
    }

    // Hàm xóa lỗi
    function resetErrors() {
        const errors = document.querySelectorAll('.error-message');
        errors.forEach(el => el.innerText = '');

        const inputs = document.querySelectorAll('.form-control');
        inputs.forEach(el => el.classList.remove('is-invalid-custom'));
    }

    // 2. Reset Form
    function resetForm() {
        document.getElementById('modalTitleNV').textContent = 'Thêm nhân viên mới';
        document.getElementById('formNV').reset();
        document.getElementById('formNV').action = contextPath + '/quan-ly-nhan-vien/add';
        document.getElementById('nvId').value = '';
        document.getElementById('nvMatKhau').type = 'password';

        // Quan trọng: Xóa các thông báo lỗi cũ
        resetErrors();
    }

    function editNhanVien(id, hoTen, email, sdt, diaChi, tenDangNhap, matKhau, roleId, trangThai) {
        // Xóa lỗi cũ trước khi load dữ liệu lên
        resetErrors();

        document.getElementById('modalTitleNV').textContent = 'Cập nhật nhân viên';
        document.getElementById('nvId').value = id;
        document.getElementById('nvHoTen').value = hoTen;
        document.getElementById('nvEmail').value = email || '';
        document.getElementById('nvSdt').value = sdt;
        document.getElementById('nvDiaChi').value = diaChi || '';
        document.getElementById('nvTenDangNhap').value = tenDangNhap || '';

        // Khi sửa, mật khẩu có thể để trống (nghĩa là không đổi)
        // Tuy nhiên code cũ của bạn đang gán thẳng mật khẩu cũ vào input text.
        // Tốt hơn là nên để trống ô mật khẩu khi sửa để bảo mật, chỉ nhập khi muốn đổi.
        // Nhưng tôi sẽ giữ nguyên logic gán của bạn, chỉ đổi type về text
        document.getElementById('nvMatKhau').value = matKhau || '';
        document.getElementById('nvMatKhau').type = 'text';

        document.getElementById('nvRoleId').value = roleId;
        document.getElementById('formNV').action = contextPath + '/quan-ly-nhan-vien/update';
        new bootstrap.Modal(document.getElementById('modalNhanVien')).show();
    }

    function showChiTiet(id, hoTen, email, sdt, diaChi, tenDangNhap, vaiTro, trangThai) {
        document.getElementById('detailMa').textContent = id;
        document.getElementById('detailHoTen').textContent = hoTen;
        document.getElementById('detailEmail').textContent = email || '—';
        document.getElementById('detailSdt').textContent = sdt;
        document.getElementById('detailDiaChi').textContent = diaChi || '—';
        document.getElementById('detailTenDangNhap').textContent = tenDangNhap || '—';
        document.getElementById('detailVaiTro').innerHTML = '<span class="badge bg-info">' + vaiTro + '</span>';
        document.getElementById('detailTrangThai').innerHTML = trangThai == 1
            ? '<span class="badge bg-success">Hoạt động</span>'
            : '<span class="badge bg-secondary">Ngừng hoạt động</span>';
        new bootstrap.Modal(document.getElementById('modalChiTietNV')).show();
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