<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${param.mode != 'ajax'}">
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <title>Quản lý hóa đơn</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body { background-color: #f3f4f6; }
            .content { margin-left: 260px; padding: 24px; }
            .card-table { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: none; }
            .modal-content { background: transparent; border: none; }
        </style>
    </head>
    <body>

    <%@ include file="/layout/sidebar.jsp" %>

    <div class="content">
    <% request.setAttribute("pageTitle", "Quản lý hóa đơn"); %>
    <%@ include file="/layout/header.jsp" %>


    <div class="mt-3"><hr></div>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.message}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("message"); %>
    </c:if>

    <div class="card p-3 mb-4 border-0 shadow-sm">
        <form id="searchForm" onsubmit="return false;" class="row g-3">
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                    <input type="text" id="keywordInput" class="form-control border-start-0 ps-0"
                           placeholder="Tìm kiếm..." value="${param.keyword}" oninput="searchWithDelay()">
                </div>
            </div>
            <div class="col-md-4">
                <select id="trangThaiSelect" class="form-select" onchange="loadData(1)">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="0" ${param.trangThai == '0' ? 'selected' : ''}>Chờ thanh toán</option>
                    <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Chờ giao hàng</option>
                    <option value="2" ${param.trangThai == '2' ? 'selected' : ''}>Đang giao</option>
                    <option value="3" ${param.trangThai == '3' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="4" ${param.trangThai == '4' ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="-1" ${param.trangThai == '-1' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
        </form>
    </div>

    <div id="tableContent">
</c:if>

<div class="card card-table p-0 overflow-hidden">
    <table class="table table-hover mb-0 align-middle">
        <thead class="table-light">
        <tr>
            <th class="ps-4">Mã HĐ</th>
            <th>Khách hàng</th>
            <th>Nhân viên</th>
            <th>Ngày lập</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
            <th class="text-center">Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty listHoaDon}">
            <tr><td colspan="7" class="text-center py-5 text-muted">Không tìm thấy dữ liệu.</td></tr>
        </c:if>
        <c:forEach items="${listHoaDon}" var="hd">
            <tr>
                <td class="ps-4 fw-bold text-primary">#${hd.ma}</td>
                <td>
                    <div class="fw-bold">${hd.khachHang != null ? hd.khachHang.hoTen : 'Khách lẻ'}</div>
                    <div class="small text-muted" style="font-size: 0.8em">${hd.khachHang != null ? hd.khachHang.sdt : ''}</div>
                </td>
                <td>${hd.nhanVien != null ? hd.nhanVien.hoTen : '---'}</td>
                <td><fmt:formatDate value="${hd.ngayLap}" pattern="dd/MM/yyyy"/></td>
                <td class="fw-bold text-danger"><fmt:formatNumber value="${hd.tongTien}" pattern="#,###"/>₫</td>
                <td>
                    <c:choose>
                        <c:when test="${hd.trangThai == 0}"><span class="badge bg-warning text-dark bg-opacity-25 border border-warning">Chờ thanh toán</span></c:when>
                        <c:when test="${hd.trangThai == 1}"><span class="badge bg-info text-dark bg-opacity-25 border border-info">Chờ giao hàng</span></c:when>
                        <c:when test="${hd.trangThai == 2}"><span class="badge bg-primary text-primary bg-opacity-10 border border-primary">Đang giao</span></c:when>
                        <c:when test="${hd.trangThai == 3}"><span class="badge bg-success text-success bg-opacity-10 border border-success">Hoàn thành</span></c:when>
                        <c:when test="${hd.trangThai == 4}"><span class="badge bg-success text-success bg-opacity-10 border border-success">Đã thanh toán</span></c:when>
                        <c:otherwise><span class="badge bg-danger text-danger bg-opacity-10 border border-danger">Hủy</span></c:otherwise>
                    </c:choose>
                </td>
                <td class="text-center">
                    <button class="btn btn-sm btn-light border" onclick="openDetailModal(${hd.id})">
                        <i class="bi bi-eye-fill text-primary"></i>
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="card-footer bg-white border-top-0 py-3">
        <nav>
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <button class="page-link" onclick="loadData(${currentPage - 1})">Trước</button>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <button class="page-link" onclick="loadData(${i})">${i}</button>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages || totalPages == 0 ? 'disabled' : ''}">
                    <button class="page-link" onclick="loadData(${currentPage + 1})">Sau</button>
                </li>
            </ul>
        </nav>
    </div>
</div>

<c:if test="${param.mode != 'ajax'}">
    </div> </div> <div class="modal fade" id="modalChiTietHoaDon" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div id="modalContentArea"></div>
        </div>
    </div>
</div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        // --- 1. AJAX LOAD BẢNG ---
        function loadData(page) {
            const keyword = document.getElementById('keywordInput').value;
            const trangThai = document.getElementById('trangThaiSelect').value;
            const container = document.getElementById('tableContent');

            container.style.opacity = '0.5';

            const url = '${pageContext.request.contextPath}/quan-ly-hoa-don?mode=ajax&page=' + page +
                '&keyword=' + encodeURIComponent(keyword) +
                '&trangThai=' + trangThai;

            fetch(url)
                .then(response => response.text())
                .then(html => {
                    container.innerHTML = html;
                    container.style.opacity = '1';

                })
                .catch(err => {
                    console.error(err);
                    alert("Lỗi tải dữ liệu");
                    container.style.opacity = '1';
                });
        }

        // --- 2. DEBOUNCE TÌM KIẾM ---
        let searchTimeout = null;
        function searchWithDelay() {
            if (searchTimeout != null) clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                loadData(1);
            }, 500);
        }

        // --- 3. MODAL CHI TIẾT ---
        function openDetailModal(id) {
            const modalElement = document.getElementById('modalChiTietHoaDon');
            const contentArea = document.getElementById('modalContentArea');
            const modal = new bootstrap.Modal(modalElement);

            contentArea.innerHTML = '<div class="text-center p-5"><div class="spinner-border text-primary"></div></div>';
            modal.show();

            fetch('${pageContext.request.contextPath}/chi-tiet-hoa-don?id=' + id)
                .then(res => res.text())
                .then(html => contentArea.innerHTML = html);
        }
        function exportPDF(fileName) {
            // Tìm vùng cần in
            const element = document.getElementById('invoiceContent');
            if (!element) {
                alert("Không tìm thấy nội dung hóa đơn!");
                return;
            }

            // Cấu hình in
            const opt = {
                margin:       10,
                filename:     fileName, // Tên file được truyền vào
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            // Hiệu ứng nút bấm (Tìm nút đang được bấm)
            // Lưu ý: event là biến toàn cục trong onclick
            const btn = event.target.closest('button');
            const oldText = btn.innerHTML;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> Đang tạo...';
            btn.disabled = true;

            // Thực hiện in
            html2pdf().set(opt).from(element).save().then(function(){
                btn.innerHTML = oldText;
                btn.disabled = false;
            }).catch(err => {
                console.error(err);
                alert("Lỗi khi tạo PDF");
                btn.innerHTML = oldText;
                btn.disabled = false;
            });
        }
    </script>
    </body>
    </html>
</c:if>