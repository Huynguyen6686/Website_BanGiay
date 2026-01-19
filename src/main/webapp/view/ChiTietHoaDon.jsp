<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* CSS cho Modal Hóa đơn */
    .invoice-card { background: #fff; border-radius: 12px; overflow: hidden; position: relative; }
    .invoice-header { background: #fff; padding: 20px 30px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
    .invoice-body { padding: 30px; }
    .info-group { margin-bottom: 20px; }
    .info-label { font-weight: 600; color: #6c757d; font-size: 0.9rem; margin-bottom: 5px; }
    .info-value { font-weight: 500; color: #212529; }
    .table-custom th { background-color: #f8f9fa; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; color: #495057; }
    .status-badge { padding: 8px 16px; border-radius: 50px; font-weight: 600; font-size: 0.9rem; }
    /* Nút đóng modal ở góc */
    .btn-close-custom { position: absolute; top: 15px; right: 15px; z-index: 100; }
</style>

<div class="invoice-card" id="invoiceContent">

    <button type="button" class="btn-close btn-close-custom"
            data-bs-dismiss="modal" aria-label="Close"
            data-html2canvas-ignore="true"></button>

    <div class="invoice-header">
        <div>
            <h4 class="fw-bold mb-1">HÓA ĐƠN #${hoaDon.ma}</h4>
            <div class="text-muted small">
                <i class="bi bi-clock me-1"></i> <fmt:formatDate value="${hoaDon.ngayLap}" pattern="dd/MM/yyyy HH:mm"/>
            </div>
        </div>
        <div class="me-5">
            <c:choose>
                <c:when test="${hoaDon.trangThai == 0}"><span class="badge bg-warning text-dark status-badge">Chờ thanh toán</span></c:when>
                <c:when test="${hoaDon.trangThai == 1}"><span class="badge bg-info status-badge">Chờ giao hàng</span></c:when>
                <c:when test="${hoaDon.trangThai == 2}"><span class="badge bg-primary status-badge">Đang giao</span></c:when>
                <c:when test="${hoaDon.trangThai == 3}"><span class="badge bg-success status-badge">Hoàn thành</span></c:when>
                <c:when test="${hoaDon.trangThai == 4}"><span class="badge bg-success status-badge">Đã thanh toán</span></c:when>
                <c:otherwise><span class="badge bg-danger status-badge">Đã hủy</span></c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="invoice-body">
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="p-3 bg-light rounded h-100">
                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-person-circle me-2"></i>THÔNG TIN KHÁCH HÀNG</h6>
                    <div class="info-group">
                        <div class="info-label">Họ tên</div>
                        <div class="info-value">${hoaDon.khachHang != null ? hoaDon.khachHang.hoTen : 'Khách lẻ (Vãng lai)'}</div>
                    </div>
                    <div class="info-group mb-0">
                        <div class="info-label">Số điện thoại</div>
                        <div class="info-value">${hoaDon.khachHang != null ? hoaDon.khachHang.sdt : '---'}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-3 bg-light rounded h-100">
                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-shop me-2"></i>THÔNG TIN ĐƠN HÀNG</h6>
                    <div class="info-group">
                        <div class="info-label">Nhân viên bán hàng</div>
                        <div class="info-value">${hoaDon.nhanVien != null ? hoaDon.nhanVien.hoTen : 'Admin'}</div>
                    </div>
                    <div class="info-group mb-0">
                        <div class="info-label">Ghi chú</div>
                        <div class="info-value text-muted fst-italic">${not empty hoaDon.ghiChu ? hoaDon.ghiChu : 'Không có ghi chú'}</div>
                    </div>
                </div>
            </div>
        </div>

        <h6 class="fw-bold mb-3">CHI TIẾT SẢN PHẨM</h6>
        <div class="table-responsive mb-4">
            <table class="table table-custom table-hover">
                <thead>
                <tr>
                    <th style="width: 5%">#</th>
                    <th style="width: 45%">Sản phẩm</th>
                    <th style="width: 20%">Phân loại</th>
                    <th class="text-end" style="width: 15%">Đơn giá</th>
                    <th class="text-center" style="width: 15%">SL / Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${hoaDon.chiTiets}" var="ct" varStatus="i">
                    <tr>
                        <td>${i.index + 1}</td>
                        <td>
                            <div class="fw-bold">${ct.giayChiTiet.giay.ten}</div>
                            <div class="small text-muted">${ct.giayChiTiet.giay.ma}</div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border me-1">${ct.giayChiTiet.mauSac.ten}</span>
                            <span class="badge bg-light text-dark border">Size ${ct.giayChiTiet.kichCo.giaTri}</span>
                        </td>
                        <td class="text-end"><fmt:formatNumber value="${ct.giaDonVi}" pattern="#,###"/>₫</td>
                        <td class="text-center">
                            <div class="fw-bold">x${ct.soLuong}</div>
                            <div class="text-primary small fw-bold"><fmt:formatNumber value="${ct.giaDonVi * ct.soLuong}" pattern="#,###"/>₫</div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="row justify-content-end">
            <div class="col-md-6">
                <div class="bg-light p-3 rounded">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tổng tiền hàng (Tạm tính):</span>
                        <span class="fw-bold"><fmt:formatNumber value="${tongTienHang}" pattern="#,###"/>₫</span>
                    </div>

                    <c:if test="${tienGiam > 0}">
                        <div class="d-flex justify-content-between mb-2">
                            <div>
                                <span class="text-muted">Voucher giảm giá:</span>
                                <c:if test="${not empty hoaDon.phieuGiamGia}">
                                    <span class="badge bg-danger ms-1">
                                        <i class="bi bi-ticket-perforated-fill me-1"></i> ${hoaDon.phieuGiamGia.ma}
                                    </span>
                                </c:if>
                            </div>
                            <span class="fw-bold text-success">-<fmt:formatNumber value="${tienGiam}" pattern="#,###"/>₫</span>
                        </div>
                    </c:if>

                    <hr class="my-2">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fw-bold fs-5 text-dark">KHÁCH PHẢI TRẢ:</span>
                        <span class="fw-bold fs-4 text-primary"><fmt:formatNumber value="${hoaDon.tongTien}" pattern="#,###"/>₫</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-5 pt-3 border-top d-flex justify-content-between align-items-center">

            <button type="button" class="btn btn-outline-danger"
                    onclick="exportPDF('HoaDon_${hoaDon.ma}.pdf')"
                    data-html2canvas-ignore="true">
                <i class="bi bi-file-earmark-pdf-fill me-2"></i> Xuất PDF
            </button>

            <form action="${pageContext.request.contextPath}/cap-nhat-hoa-don" method="post"
                  class="d-flex align-items-center gap-2"
                  data-html2canvas-ignore="true">

                <input type="hidden" name="id" value="${hoaDon.id}">
                <label class="fw-bold text-secondary">Cập nhật trạng thái:</label>
                <select name="trangThai" class="form-select w-auto border-secondary">
                    <option value="0" ${hoaDon.trangThai == 0 ? 'selected' : ''}>Chờ thanh toán</option>
                    <option value="1" ${hoaDon.trangThai == 1 ? 'selected' : ''}>Chờ giao hàng</option>
                    <option value="2" ${hoaDon.trangThai == 2 ? 'selected' : ''}>Đang giao</option>
                    <option value="3" ${hoaDon.trangThai == 3 ? 'selected' : ''}>Hoàn thành</option>
                    <option value="4" ${hoaDon.trangThai == 4 ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="-1" ${hoaDon.trangThai == -1 ? 'selected' : ''}>Hủy đơn</option>
                </select>
                <button class="btn btn-dark px-4"><i class="bi bi-save me-2"></i>Lưu thay đổi</button>
            </form>
        </div>
    </div>
</div>

