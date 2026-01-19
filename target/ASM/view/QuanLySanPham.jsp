<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>Quản lý sản phẩm</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .content { margin-left: 260px; padding: 20px; }
        .pagination .page-link {
            border-radius: 0.5rem;
            margin: 0 4px;
            padding: 0.5rem 1rem;
            min-width: 42px;
            text-align: center;
        }
        .pagination .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            pointer-events: none;
        }

        /* CSS cho validation lỗi */
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
    <% request.setAttribute("pageTitle", "Quản lý sản phẩm"); %>
    <%@ include file="/layout/header.jsp" %>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <p class="text-secondary mb-2">Quản lý sản phẩm giày và biến thể (màu sắc, kích cỡ)</p>
    <div class="mt-3"><hr></div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-semibold">Danh sách sản phẩm</h4>
        <button class="btn btn-dark rounded-pill px-4 shadow-sm" id="btnAdd">
            Thêm sản phẩm
        </button>
    </div>

    <div class="bg-white rounded-3 shadow-sm p-4 mb-4">
        <div class="row g-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0">Tìm kiếm</span>
                    <input type="text" class="form-control border-start-0 ps-0" placeholder="Tìm kiếm theo tên, mã..." id="searchInput">
                </div>
            </div>
            <div class="col-md-3">
                <select class="form-select" id="filterBrand">
                    <option value="">Tất cả thương hiệu</option>
                    <option>Nike</option>
                    <option>Adidas</option>
                    <option>Puma</option>
                    <option>New Balance</option>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select" id="filterStatus">
                    <option value="">Tất cả trạng thái</option>
                    <option value="1">Kích hoạt</option>
                    <option value="0">Ngừng bán</option>
                </select>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle" id="productTable">
                <thead class="table-light">
                <tr>
                    <th class="ps-4">Sản phẩm</th>
                    <th>Mã sản phẩm</th>
                    <th>Thương hiệu</th>
                    <th>Biến thể</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageItems}" var="g">
                    <tr data-brand="${g.thuongHieu}" data-status="${g.trangThai}">
                        <td>
                            <p class="ps-4 fw-semibold">${g.ten}</p>
                            <small class="ps-4 text-muted">
                                <c:set var="totalQty" value="0"/>
                                <c:forEach items="${g.chiTiets}" var="ct">
                                    <c:set var="totalQty" value="${totalQty + ct.soLuong}"/>
                                </c:forEach>
                                Tồn kho: ${totalQty} đôi
                            </small>
                        </td>
                        <td class="text-muted font-monospace">${g.ma}</td>
                        <td>${g.thuongHieu}</td>
                        <td>
                            <c:set var="activeVariants" value="0"/>
                            <c:forEach items="${g.chiTiets}" var="ct">
                                <c:if test="${ct.kichHoat == true}">
                                    <c:set var="activeVariants" value="${activeVariants + 1}"/>
                                </c:if>
                            </c:forEach>
                            <span class="badge bg-secondary rounded-pill">
                                ${activeVariants} biến thể
                            </span>
                        </td>
                        <td>
                            <span class="badge rounded-pill px-3 ${g.trangThai == 1 ? 'bg-success' : 'bg-secondary'}">
                                    ${g.trangThai == 1 ? 'Kích hoạt' : 'Ngừng bán'}
                            </span>
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-sm btn-outline-warning" title="Sửa"
                                    onclick="editGiay(${g.id}, '${g.ma}', '${g.ten}', '${g.thuongHieu}', '${g.moTa}', ${g.trangThai})">
                                Sửa
                            </button>
                            <a href="${contextPath}/quan-ly-bien-the?giayId=${g.id}" class="btn btn-sm btn-outline-info" title="Biến thể">
                                Biến thể
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa"
                                    onclick="if(confirm('Xóa sản phẩm này?')) location.href='${contextPath}/quan-ly-san-pham/delete?id=${g.id}'">
                                Xóa
                            </button>
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
                        <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                            <span aria-hidden="true">Trước</span>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                            <span aria-hidden="true">Sau</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<div class="modal fade" id="modalAddEdit" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <form id="formGiay" action="" method="post" class="modal-content" onsubmit="return validateForm()">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="modalTitle">Thêm sản phẩm mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="editId" value="${giayError.id}">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã sản phẩm <span class="text-danger">*</span></label>
                        <input name="ma" id="editMa"
                               class="form-control ${not empty errorMa ? 'is-invalid-custom' : ''}"
                               value="${giayError.ma}">
                        <small id="errorMa" class="error-message">${errorMa}</small>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                        <input name="ten" id="editTen" class="form-control" value="${giayError.ten}">
                        <small id="errorTen" class="error-message"></small>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu <span class="text-danger">*</span></label>
                        <input name="thuongHieu" id="editThuongHieu" class="form-control" value="${giayError.thuongHieu}">
                        <small id="errorThuongHieu" class="error-message"></small>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select name="trangThai" id="editTrangThai" class="form-select">
                            <option value="1" ${giayError.trangThai == 1 ? 'selected' : ''}>Kích hoạt</option>
                            <option value="0" ${giayError.trangThai == 0 ? 'selected' : ''}>Ngừng bán</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả</label>
                        <textarea name="moTa" id="editMoTa" class="form-control" rows="3">${giayError.moTa}</textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-dark px-4">Lưu sản phẩm</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${contextPath}';

    // 1. Tự động mở Modal nếu có lỗi từ Server (Validation)
    document.addEventListener("DOMContentLoaded", function() {
        const shouldOpenModal = '${modalOpen}';

        if (shouldOpenModal === 'true') {
            const idVal = document.getElementById('editId').value;
            const isEdit = idVal !== '' && idVal !== '0';

            // Cập nhật tiêu đề
            document.getElementById('modalTitle').textContent = isEdit ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới';

            // Cập nhật Action Form
            const actionUrl = isEdit ? '/quan-ly-san-pham/update' : '/quan-ly-san-pham/add';
            document.getElementById('formGiay').action = contextPath + actionUrl;

            // Hiển thị modal
            new bootstrap.Modal(document.getElementById('modalAddEdit')).show();
        }
    });

    // 2. Validate Form Client-side (Validation cơ bản)
    function validateForm() {
        let isValid = true;

        // Chỉ reset các lỗi client-side, giữ lại lỗi server nếu user chưa sửa
        const ma = document.getElementById('editMa');
        const ten = document.getElementById('editTen');
        const thuongHieu = document.getElementById('editThuongHieu');

        // Nếu user bắt đầu gõ lại, xóa class lỗi cũ đi
        if (ma.classList.contains('is-invalid-custom') && ma.value.trim() !== '') {
            // Logic nhỏ để clear lỗi khi user sửa (có thể bỏ qua nếu muốn đơn giản)
        }

        resetErrors();

        // Validate Mã
        if (ma.value.trim() === '') {
            showError('errorMa', 'Vui lòng nhập mã sản phẩm');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        } else if (/\s/.test(ma.value.trim())) {
            showError('errorMa', 'Mã sản phẩm không được chứa khoảng trắng');
            ma.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Tên
        if (ten.value.trim() === '') {
            showError('errorTen', 'Vui lòng nhập tên sản phẩm');
            ten.classList.add('is-invalid-custom');
            isValid = false;
        }

        // Validate Thương hiệu
        if (thuongHieu.value.trim() === '') {
            showError('errorThuongHieu', 'Vui lòng nhập thương hiệu');
            thuongHieu.classList.add('is-invalid-custom');
            isValid = false;
        }

        return isValid;
    }

    function showError(elementId, message) {
        document.getElementById(elementId).innerText = message;
    }

    function resetErrors() {
        // Chỉ xóa text lỗi nếu nó không phải là lỗi từ server (để tránh xóa mất dòng "Mã đã tồn tại" khi chưa submit lại)
        // Tuy nhiên để đơn giản, ta cứ xóa hết, nếu validate JS fail thì nó hiện lại.
        // Lỗi Server chỉ hiện khi load trang, nếu bấm submit thì JS sẽ validate lại từ đầu.
        document.querySelectorAll('.error-message').forEach(el => el.innerText = '');
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('is-invalid-custom'));
    }

    // 3. Sự kiện nút Thêm mới
    document.getElementById('btnAdd').addEventListener('click', () => {
        resetErrors();
        document.getElementById('modalTitle').textContent = 'Thêm sản phẩm mới';
        document.getElementById('formGiay').reset(); // Xóa dữ liệu cũ

        // Reset value của các input (quan trọng vì value="" trong HTML có thể đang giữ data cũ)
        document.getElementById('editId').value = '';
        document.getElementById('editMa').value = '';
        document.getElementById('editTen').value = '';
        document.getElementById('editThuongHieu').value = '';
        document.getElementById('editMoTa').value = '';

        document.getElementById('formGiay').action = contextPath + '/quan-ly-san-pham/add';
        new bootstrap.Modal(document.getElementById('modalAddEdit')).show();
    });

    // 4. Sự kiện nút Sửa (từ bảng)
    function editGiay(id, ma, ten, thuongHieu, moTa, trangThai) {
        resetErrors();
        document.getElementById('modalTitle').textContent = 'Cập nhật sản phẩm';

        document.getElementById('editId').value = id;
        document.getElementById('editMa').value = ma;
        document.getElementById('editTen').value = ten;
        document.getElementById('editThuongHieu').value = thuongHieu || '';
        document.getElementById('editMoTa').value = moTa || '';
        document.getElementById('editTrangThai').value = trangThai;

        document.getElementById('formGiay').action = contextPath + '/quan-ly-san-pham/update';
        new bootstrap.Modal(document.getElementById('modalAddEdit')).show();
    }

    // 5. Filter & Search Client-side
    ['searchInput', 'filterBrand', 'filterStatus'].forEach(id => {
        document.getElementById(id)?.addEventListener('input', filterTable);
        document.getElementById(id)?.addEventListener('change', filterTable);
    });

    function filterTable() {
        const search = (document.getElementById('searchInput')?.value || '').toLowerCase();
        const brand = document.getElementById('filterBrand')?.value || '';
        const status = document.getElementById('filterStatus')?.value || '';

        document.querySelectorAll('#productTable tbody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            const matchSearch = text.includes(search);
            const matchBrand = !brand || row.dataset.brand === brand;
            const matchStatus = status === '' || row.dataset.status == status;
            row.style.display = (matchSearch && matchBrand && matchStatus) ? '' : 'none';
        });
    }
</script>
</body>
</html>