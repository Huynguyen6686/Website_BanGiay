<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>

        .content {
            margin-left: 260px;
            padding: 20px;
        }
    </style>
</head>
<body>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content">
    <%@ include file="/layout/header.jsp" %>
    <div class="mt-3"><hr></div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="${contextPath}/quan-ly-san-pham" class="btn btn-secondary me-3">
                Trở về
            </a>
            <h4>Quản lý biến thể: ${giayHienTai.ten} (${giayHienTai.ma})</h4>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddEdit" onclick="resetForm()">
            Thêm biến thể mới
        </button>
    </div>

    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger alert-dismissible fade show">
                ${requestScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty requestScope.message}">
        <div class="alert alert-success alert-dismissible fade show">
                ${requestScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>SKU</th>
                    <th>Màu</th>
                    <th>Kích cỡ</th>
                    <th>Kiểu</th>
                    <th>Chất liệu</th>
                    <th>Đế</th>
                    <th>Dây</th>
                    <th>Cổ</th>
                    <th>Giá gốc</th>
                    <th>Giá bán</th>
                    <th>Tồn kho</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listGiayChiTiet}" var="bt">
                    <tr data-id="${bt.id}"
                        data-ma="${bt.maBienThe}"
                        data-sku="${bt.sku}"
                        data-mausacid="${bt.mauSac.id}"
                        data-kichcoid="${bt.kichCo.id}"
                        data-kieuid="${bt.kieu != null ? bt.kieu.id : ''}"
                        data-chatlieuid="${bt.chatLieu != null ? bt.chatLieu.id : ''}"
                        data-dayid="${bt.day != null ? bt.day.id : ''}"
                        data-coid="${bt.co != null ? bt.co.id : ''}"
                        data-deid="${bt.de != null ? bt.de.id : ''}"
                        data-giagoc="${bt.giaGoc}"
                        data-giaban="${bt.giaBan}"
                        data-soluong="${bt.soLuong}"
                        data-kichhoat="${bt.kichHoat}">

                        <td>${bt.sku != null ? bt.sku : 'Chưa có'}</td>
                        <td>
                            <span class="badge" style="background:${bt.mauSac.maMauHex}; color:white;">
                                    ${bt.mauSac.ten}
                            </span>
                        </td>
                        <td>${bt.kichCo.giaTri}</td>
                        <td>${bt.kieu != null ? bt.kieu.ten : '-'}</td>
                        <td>${bt.chatLieu != null ? bt.chatLieu.ten : '-'}</td>
                        <td>${bt.de != null ? bt.de.ten : '-'}</td>
                        <td>${bt.day != null ? bt.day.ten : '-'}</td>
                        <td>${bt.co != null ? bt.co.ten : '-'}</td>
                        <td><fmt:formatNumber value="${bt.giaGoc}" type="currency" currencySymbol="₫"/></td>
                        <td><fmt:formatNumber value="${bt.giaBan}" type="currency" currencySymbol="₫"/></td>
                        <td>${bt.soLuong}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bt.kichHoat}">
                                    <span class="badge bg-success">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Dừng bán</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <!-- NÚT SỬA - DÙNG this ĐỂ TRÁNH LỖI NULL -->
                            <button type="button"
                                    class="btn btn-sm btn-warning"
                                    onclick="editVariant(this)">
                                Sửa
                            </button>

                            <!-- NÚT XÓA -->
                            <form action="${contextPath}/quan-ly-bien-the/delete" method="post" class="d-inline">
                                <input type="hidden" name="giayId" value="${giayHienTai.id}">
                                <input type="hidden" name="id" value="${bt.id}">
                                <button type="submit" class="btn btn-sm btn-danger"
                                        onclick="return confirm('Xóa biến thể này? Không thể hoàn tác!')">
                                    Xóa
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL THÊM / SỬA BIẾN THỂ -->
<div class="modal fade" id="modalAddEdit" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <form id="formVariant" method="post">
                <input type="hidden" name="giayId" value="${giayHienTai.id}">
                <input type="hidden" name="id" id="editId">

                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Thêm biến thể mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã biến thể <span class="text-danger">*</span></label>
                            <input name="ma" id="editMa" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SKU (tự động nếu bỏ trống)</label>
                            <input name="sku" id="editSku" class="form-control">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Màu sắc <span class="text-danger">*</span></label>
                            <select name="mauSac" id="editMauSac" class="form-select" required>
                                <option value="">-- Chọn màu --</option>
                                <c:forEach items="${listMauSac}" var="m">
                                    <option value="${m.id}">${m.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Kích cỡ <span class="text-danger">*</span></label>
                            <select name="kichCo" id="editKichCo" class="form-select" required>
                                <option value="">-- Chọn kích cỡ --</option>
                                <c:forEach items="${listKichCo}" var="kc">
                                    <option value="${kc.id}">${kc.giaTri}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Tabs thuộc tính mở rộng -->
                        <ul class="nav nav-tabs mt-4">
                            <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#tabKieu">Kiểu</a></li>
                            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tabChatLieu">Chất liệu</a></li>
                            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tabDe">Đế</a></li>
                            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tabDay">Dây</a></li>
                            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tabCo">Cổ</a></li>
                        </ul>

                        <div class="tab-content mt-3">
                            <div id="tabKieu" class="tab-pane fade show active">
                                <select name="kieu" id="editKieu" class="form-select">
                                    <option value="">-- Không chọn --</option>
                                    <c:forEach items="${listKieu}" var="k">
                                        <option value="${k.id}">${k.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div id="tabChatLieu" class="tab-pane fade">
                                <select name="chatLieu" id="editChatLieu" class="form-select">
                                    <option value="">-- Không chọn --</option>
                                    <c:forEach items="${listChatLieu}" var="cl">
                                        <option value="${cl.id}">${cl.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div id="tabDe" class="tab-pane fade">
                                <select name="de" id="editDe" class="form-select">
                                    <option value="">-- Không chọn --</option>
                                    <c:forEach items="${listDe}" var="d">
                                        <option value="${d.id}">${d.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div id="tabDay" class="tab-pane fade">
                                <select name="day" id="editDay" class="form-select">
                                    <option value="">-- Không chọn --</option>
                                    <c:forEach items="${listDay}" var="d">
                                        <option value="${d.id}">${d.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div id="tabCo" class="tab-pane fade">
                                <select name="co" id="editCo" class="form-select">
                                    <option value="">-- Không chọn --</option>
                                    <c:forEach items="${listCo}" var="c">
                                        <option value="${c.id}">${c.ten}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-4 mt-3">
                            <label class="form-label">Giá gốc</label>
                            <input name="giaGoc" id="editGiaGoc" class="form-control" placeholder="Để trống = giá bán">
                        </div>
                        <div class="col-md-4 mt-3">
                            <label class="form-label">Giá bán <span class="text-danger">*</span></label>
                            <input name="giaBan" id="editGiaBan" class="form-control" required>
                        </div>
                        <div class="col-md-4 mt-3">
                            <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                            <input name="soLuong" id="editSoLuong" type="number" class="form-control" required min="0">
                        </div>

                        <div class="col-md-6 mt-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="kichHoat" id="editKichHoat" class="form-select">
                                <option value="true">Hoạt động</option>
                                <option value="false">Dừng bán</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu biến thể</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${contextPath}";

    function resetForm() {
        document.getElementById('formVariant').reset();
        document.getElementById('editId').value = '';
        document.getElementById('modalLabel').innerText = 'Thêm biến thể mới';
        document.getElementById('formVariant').action = contextPath + '/quan-ly-bien-the/add';
        document.getElementById('editKichHoat').value = 'true';
    }

    // HÀM SỬA - AN TOÀN TUYỆT ĐỐI
    function editVariant(button) {
        const row = button.closest('tr');
        if (!row || !row.dataset.id) {
            alert("Không tìm thấy dữ liệu biến thể!");
            return;
        }

        const id = row.dataset.id;

        document.getElementById('editId').value = id;
        document.getElementById('editMa').value = row.dataset.ma || '';
        document.getElementById('editSku').value = row.dataset.sku || '';
        document.getElementById('editMauSac').value = row.dataset.mausacid || '';
        document.getElementById('editKichCo').value = row.dataset.kichcoid || '';
        document.getElementById('editKieu').value = row.dataset.kieuid || '';
        document.getElementById('editChatLieu').value = row.dataset.chatlieuid || '';
        document.getElementById('editDe').value = row.dataset.deid || '';
        document.getElementById('editDay').value = row.dataset.dayid || '';
        document.getElementById('editCo').value = row.dataset.coid || '';
        document.getElementById('editGiaGoc').value = row.dataset.giagoc || '';
        document.getElementById('editGiaBan').value = row.dataset.giaban || '';
        document.getElementById('editSoLuong').value = row.dataset.soluong || '0';

        const kichHoat = row.dataset.kichhoat;
        document.getElementById('editKichHoat').value = (kichHoat === 'true' || kichHoat === true) ? 'true' : 'false';

        document.getElementById('modalLabel').innerText = 'Sửa biến thể: ' + (row.dataset.ma || 'ID ' + id);
        document.getElementById('formVariant').action = contextPath + '/quan-ly-bien-the/update';

        new bootstrap.Modal(document.getElementById('modalAddEdit')).show();
    }
</script>
</body>
</html>