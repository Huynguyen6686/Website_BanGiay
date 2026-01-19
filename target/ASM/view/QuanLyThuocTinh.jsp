<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý thuộc tính</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .content { margin-left: 260px; padding: 20px; }
        .nav-tabs .nav-link { border-radius: 0.5rem 0.5rem 0 0; }
        .nav-tabs .nav-link.active { background-color: #0d6efd; color: white; }
        .color-preview {
            width: 32px; height: 32px; border-radius: 0.35rem; border: 1px solid #ddd;
            display: inline-block; vertical-align: middle;
        }
        .badge-type { font-size: 0.7rem; padding: 0.35em 0.65em; }
        .action-btns .btn { font-size: 0.85rem; padding: 0.25rem 0.5rem; }
        .action-btns .btn + .btn { margin-left: 4px; }

        /* CSS Validation */
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
    <% request.setAttribute("pageTitle", "Quản lý thuộc tính"); %>
    <%@ include file="/layout/header.jsp" %>

    <p class="text-secondary mb-4">Quản lý màu sắc, kích cỡ và các thuộc tính của giày</p>
    <div class="mt-3"><hr></div>
    <h4 class="mb-3 mt-3 fw-semibold">Danh sách thuộc tính</h4>

    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#mauSac">Màu sắc</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#kichCo">Kích cỡ</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#thuocTinhKhac">Thuộc tính khác</button>
        </li>
    </ul>

    <div class="tab-content">

        <div class="tab-pane fade show active" id="mauSac">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Quản lý màu sắc sản phẩm</h5>
                <button class="btn btn-dark btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#modalMauSac" onclick="resetMauSac()">
                    + Thêm màu
                </button>
            </div>
            <div class="card border-0 shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>Mã màu</th>
                            <th>Tên màu</th>
                            <th>Mã hex</th>
                            <th>Xem trước</th>
                            <th width="130" class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listMauSac}" var="m">
                            <tr>
                                <td><strong>${m.ma}</strong></td>
                                <td>${m.ten}</td>
                                <td><code>${m.maMauHex}</code></td>
                                <td><div class="color-preview" style="background:${m.maMauHex};"></div></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editMauSac(${m.id}, '${m.ma}', '${m.ten}', '${m.maMauHex}')">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=mauSac&id=${m.id}"
                                       class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa màu này?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="kichCo">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Quản lý kích cỡ giày</h5>
                <button class="btn btn-dark btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#modalKichCo" onclick="resetKichCo()">
                    + Thêm kích cỡ
                </button>
            </div>
            <div class="card border-0 shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>Giá trị</th>
                            <th>Ghi chú</th>
                            <th width="130" class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listKichCo}" var="kc">
                            <tr>
                                <td><strong>${kc.giaTri}</strong></td>
                                <td>${kc.ghiChu != null ? kc.ghiChu : '-'}</td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editKichCo(${kc.id}, '${kc.giaTri}', '${kc.ghiChu}')">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=kichCo&id=${kc.id}"
                                       class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa kích cỡ này?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="tab-pane fade" id="thuocTinhKhac">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Quản lý các thuộc tính như kiểu giày, chất liệu, đế...</h5>
                <button class="btn btn-dark btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#modalThuocTinhGiay" onclick="resetThuocTinhGiay()">
                    + Thêm thuộc tính
                </button>
            </div>
            <div class="card border-0 shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>Loại</th>
                            <th>Mã</th>
                            <th>Tên</th>
                            <th>Mô tả</th>
                            <th width="110" class="text-center">Trạng thái</th>
                            <th width="130" class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listKieu}" var="tt">
                            <tr>
                                <td><span class="badge bg-info badge-type">Kiểu giày</span></td>
                                <td><strong>${tt.ma}</strong></td>
                                <td>${tt.ten}</td>
                                <td>${tt.moTa != null ? tt.moTa : '-'}</td>
                                <td class="text-center"><span class="badge ${tt.kichHoat == 1 ? 'bg-success' : 'bg-secondary'}">${tt.kichHoat == 1 ? 'Kích hoạt' : 'Dừng bán'}</span></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editThuocTinhGiay(${tt.id}, 1, '${tt.ma}', '${tt.ten}', '${tt.moTa}', ${tt.kichHoat})">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=ttg&id=${tt.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${listChatLieu}" var="tt">
                            <tr>
                                <td><span class="badge bg-warning badge-type">Chất liệu</span></td>
                                <td><strong>${tt.ma}</strong></td>
                                <td>${tt.ten}</td>
                                <td>${tt.moTa != null ? tt.moTa : '-'}</td>
                                <td class="text-center"><span class="badge ${tt.kichHoat == 1 ? 'bg-success' : 'bg-secondary'}">${tt.kichHoat == 1 ? 'Kích hoạt' : 'Dừng bán'}</span></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editThuocTinhGiay(${tt.id}, 2, '${tt.ma}', '${tt.ten}', '${tt.moTa}', ${tt.kichHoat})">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=ttg&id=${tt.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${listDay}" var="tt">
                            <tr>
                                <td><span class="badge bg-success badge-type">Dây giày</span></td>
                                <td><strong>${tt.ma}</strong></td>
                                <td>${tt.ten}</td>
                                <td>${tt.moTa != null ? tt.moTa : '-'}</td>
                                <td class="text-center"><span class="badge ${tt.kichHoat == 1 ? 'bg-success' : 'bg-secondary'}">${tt.kichHoat == 1 ? 'Kích hoạt' : 'Dừng bán'}</span></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editThuocTinhGiay(${tt.id}, 3, '${tt.ma}', '${tt.ten}', '${tt.moTa}', ${tt.kichHoat})">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=ttg&id=${tt.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${listCo}" var="tt">
                            <tr>
                                <td><span class="badge bg-primary badge-type">Cổ giày</span></td>
                                <td><strong>${tt.ma}</strong></td>
                                <td>${tt.ten}</td>
                                <td>${tt.moTa != null ? tt.moTa : '-'}</td>
                                <td class="text-center"><span class="badge ${tt.kichHoat == 1 ? 'bg-success' : 'bg-secondary'}">${tt.kichHoat == 1 ? 'Kích hoạt' : 'Dừng bán'}</span></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editThuocTinhGiay(${tt.id}, 4, '${tt.ma}', '${tt.ten}', '${tt.moTa}', ${tt.kichHoat})">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=ttg&id=${tt.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${listDe}" var="tt">
                            <tr>
                                <td><span class="badge bg-danger badge-type">Đế giày</span></td>
                                <td><strong>${tt.ma}</strong></td>
                                <td>${tt.ten}</td>
                                <td>${tt.moTa != null ? tt.moTa : '-'}</td>
                                <td class="text-center"><span class="badge ${tt.kichHoat == 1 ? 'bg-success' : 'bg-secondary'}">${tt.kichHoat == 1 ? 'Kích hoạt' : 'Dừng bán'}</span></td>
                                <td class="text-center action-btns">
                                    <button class="btn btn-outline-warning btn-sm" onclick="editThuocTinhGiay(${tt.id}, 5, '${tt.ma}', '${tt.ten}', '${tt.moTa}', ${tt.kichHoat})">Sửa</button>
                                    <a href="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/delete?type=ttg&id=${tt.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Xóa?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalMauSac">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add" method="post" onsubmit="return validateMauSac()">
                <input type="hidden" name="type" value="mauSac">
                <input type="hidden" name="id" id="mauId">
                <div class="modal-header"><h5 class="modal-title">Thêm / Sửa màu sắc</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Mã màu</label>
                        <input name="ma" id="mauMa" class="form-control">
                        <small id="errorMauMa" class="error-message"></small>
                    </div>
                    <div class="mb-3">
                        <label>Tên màu</label>
                        <input name="ten" id="mauTen" class="form-control">
                        <small id="errorMauTen" class="error-message"></small>
                    </div>
                    <div class="mb-3">
                        <label>Mã Hex</label>
                        <input name="maMauHex" id="mauHex" class="form-control" type="color">
                    </div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Lưu màu</button></div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalKichCo">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add" method="post" onsubmit="return validateKichCo()">
                <input type="hidden" name="type" value="kichCo">
                <input type="hidden" name="id" id="kcId">
                <div class="modal-header"><h5 class="modal-title">Thêm / Sửa kích cỡ</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Giá trị</label>
                        <input name="giaTri" id="kcGiaTri" class="form-control">
                        <small id="errorKcGiaTri" class="error-message"></small>
                    </div>
                    <div class="mb-3"><label>Ghi chú</label><input name="ghiChu" id="kcGhiChu" class="form-control"></div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Lưu kích cỡ</button></div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalThuocTinhGiay">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add" method="post" onsubmit="return validateThuocTinhGiay()">
                <input type="hidden" name="type" value="ttg">
                <input type="hidden" name="id" id="ttgId">
                <input type="hidden" name="loaiThuocTinh" id="ttgLoai">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm / Sửa thuộc tính</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label>Loại thuộc tính</label>
                            <select class="form-select" onchange="document.getElementById('ttgLoai').value=this.value">
                                <option value="1">Kiểu giày</option>
                                <option value="2">Chất liệu</option>
                                <option value="3">Dây</option>
                                <option value="4">Cổ</option>
                                <option value="5">Đế</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label>Mã</label>
                            <input name="ma" id="ttgMa" class="form-control">
                            <small id="errorTtgMa" class="error-message"></small>
                        </div>
                        <div class="col-12">
                            <label>Tên</label>
                            <input name="ten" id="ttgTen" class="form-control">
                            <small id="errorTtgTen" class="error-message"></small>
                        </div>
                        <div class="col-12">
                            <label>Mô tả</label>
                            <textarea name="moTa" id="ttgMoTa" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="kichHoat" id="ttgKichHoat" value="1" checked>
                                <label class="form-check-label" for="ttgKichHoat">Kích hoạt (bỏ chọn = Dừng bán)</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Lưu thuộc tính</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- UTILS ---
    function showError(elementId, message) {
        document.getElementById(elementId).innerText = message;
    }

    function resetErrors() {
        document.querySelectorAll('.error-message').forEach(el => el.innerText = '');
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('is-invalid-custom'));
    }

    // --- 1. VALIDATE MÀU SẮC ---
    function validateMauSac() {
        let isValid = true;
        resetErrors();

        const ma = document.getElementById('mauMa');
        const ten = document.getElementById('mauTen');

        if (ma.value.trim() === '') {
            showError('errorMauMa', 'Vui lòng nhập mã màu');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(ma.value.trim())) {
            showError('errorMauMa', 'Mã màu không được chứa khoảng trắng');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        }

        if (ten.value.trim() === '') {
            showError('errorMauTen', 'Vui lòng nhập tên màu');
            ten.classList.add('is-invalid-custom');
            isValid = false;
        }
        return isValid;
    }

    // --- 2. VALIDATE KÍCH CỠ ---
    function validateKichCo() {
        let isValid = true;
        resetErrors();

        const giaTri = document.getElementById('kcGiaTri');

        if (giaTri.value.trim() === '') {
            showError('errorKcGiaTri', 'Vui lòng nhập kích cỡ');
            giaTri.classList.add('is-invalid-custom');
            isValid = false;
        }
        return isValid;
    }

    // --- 3. VALIDATE THUỘC TÍNH KHÁC ---
    function validateThuocTinhGiay() {
        let isValid = true;
        resetErrors();

        const ma = document.getElementById('ttgMa');
        const ten = document.getElementById('ttgTen');

        if (ma.value.trim() === '') {
            showError('errorTtgMa', 'Vui lòng nhập mã');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(ma.value.trim())) {
            showError('errorTtgMa', 'Mã không được chứa khoảng trắng');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        }

        if (ten.value.trim() === '') {
            showError('errorTtgTen', 'Vui lòng nhập tên');
            ten.classList.add('is-invalid-custom');
            isValid = false;
        }
        return isValid;
    }


    // --- LOGIC CŨ (Đã thêm resetErrors) ---

    // Màu sắc
    function resetMauSac() {
        resetErrors(); // Reset lỗi
        const f = document.querySelector('#modalMauSac form');
        f.reset(); f.action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add';
        document.getElementById('mauId').value = '';
    }
    function editMauSac(id, ma, ten, hex) {
        resetErrors(); // Reset lỗi
        document.getElementById('mauId').value = id;
        document.getElementById('mauMa').value = ma;
        document.getElementById('mauTen').value = ten;
        document.getElementById('mauHex').value = hex;
        document.querySelector('#modalMauSac form').action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/update';
        new bootstrap.Modal(document.getElementById('modalMauSac')).show();
    }

    // Kích cỡ
    function resetKichCo() {
        resetErrors(); // Reset lỗi
        const f = document.querySelector('#modalKichCo form');
        f.reset(); f.action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add';
        document.getElementById('kcId').value = '';
    }
    function editKichCo(id, giaTri, ghiChu) {
        resetErrors(); // Reset lỗi
        document.getElementById('kcId').value = id;
        document.getElementById('kcGiaTri').value = giaTri;
        document.getElementById('kcGhiChu').value = ghiChu || '';
        document.querySelector('#modalKichCo form').action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/update';
        new bootstrap.Modal(document.getElementById('modalKichCo')).show();
    }

    // Thuộc tính giày
    function resetThuocTinhGiay() {
        resetErrors(); // Reset lỗi
        const f = document.querySelector('#modalThuocTinhGiay form');
        f.reset(); f.action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/add';
        document.getElementById('ttgId').value = '';
        document.getElementById('ttgLoai').value = '1';
        document.getElementById('ttgKichHoat').checked = true;
    }
    function editThuocTinhGiay(id, loai, ma, ten, moTa, kichHoat) {
        resetErrors(); // Reset lỗi
        document.getElementById('ttgId').value = id;
        document.getElementById('ttgLoai').value = loai;
        document.getElementById('ttgMa').value = ma;
        document.getElementById('ttgTen').value = ten;
        document.getElementById('ttgMoTa').value = moTa || '';
        document.getElementById('ttgKichHoat').checked = (kichHoat == 1);

        document.querySelector('#modalThuocTinhGiay form').action = '${pageContext.request.contextPath}/quan-ly-thuoc-tinh/update';
        new bootstrap.Modal(document.getElementById('modalThuocTinhGiay')).show();
    }
</script>
</body>
</html>