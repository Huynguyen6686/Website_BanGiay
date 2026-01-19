<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>Thống kê & Báo cáo</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .content { margin-left: 260px; padding: 20px; min-height: 100vh; }
        .stat-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); text-align: center; }
        .stat-number { font-size: 2.3rem; font-weight: 700; }
        .stat-label { font-size: 0.95rem; color: #64748b; margin-top: 8px; }
        .nav-tabs .nav-link { border-radius: 8px 8px 0 0; }
        .nav-tabs .nav-link.active { background-color: #0d6efd; color: white; }
        .chart-container { width: 100%; max-width: 1000px; margin: 0 auto; }
        .big-chart { height: 400px !important; }
        .medium-chart { height: 320px !important; }
        .small-chart { height: 280px !important; }
    </style>
</head>
<body>

<%@ include file="/layout/sidebar.jsp" %>

<div class="content">
    <% request.setAttribute("pageTitle", "Thống kê & Báo cáo"); %>
    <%@ include file="/layout/header.jsp" %>

    <div class="mb-4">
        <h4 class="fw-semibold">Thống kê & Báo cáo</h4>
        <p class="text-secondary">Phân tích chi tiết về hoạt động kinh doanh</p>
    </div>

    <!-- COMBOBOX NHIỀU LỰA CHỌN -->
    <div class="d-flex justify-content-end mb-4">
        <select class="form-select w-auto me-2" id="timeRange">
            <option value="7">7 ngày qua</option>
            <option value="30">30 ngày qua</option>
            <option value="90">90 ngày qua</option>
            <option value="180">6 tháng qua</option>
            <option value="365">1 năm qua</option>
        </select>
        <a href="${contextPath}/thong-ke?action=export" class="btn btn-success">
            <i class="bi bi-file-earmark-excel"></i> Xuất Excel
        </a>
    </div>

    <!-- TABS -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#doanhthu">Doanh thu</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#sanpham">Sản phẩm</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#phieugiamgia">Phiếu giảm giá</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#dotgiamgia">Đợt giảm giá</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#donhang">Đơn hàng</a></li>
    </ul>

    <div class="tab-content">
        <!-- DOANH THU -->
        <div class="tab-pane fade show active" id="doanhthu">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-label">Tổng doanh thu</div>
                        <div class="stat-number text-primary">
                            <fmt:formatNumber value="${doanhThu}" type="currency" currencySymbol="₫"/>
                        </div>
                        <small class="text-success">+15.3% so với kỳ trước</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-label">Doanh thu trung bình</div>
                        <div class="stat-number">
                            <fmt:formatNumber value="${tbDonHang}" type="currency" currencySymbol="₫"/>
                        </div>
                        <small>Mỗi đơn hàng</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-label">Giá trị đơn hàng TB</div>
                        <div class="stat-number text-success">3.890.000₫</div>
                        <small class="text-success">+8.2% so với kỳ trước</small>
                    </div>
                </div>
            </div>

            <div class="card mt-4 shadow-sm">
                <div class="card-body">
                    <h5 class="text-center">Biểu đồ doanh thu theo tháng</h5>
                    <canvas id="chartDoanhThu" class="big-chart"></canvas>
                </div>
            </div>
        </div>

        <!-- SẢN PHẨM -->
        <div class="tab-pane fade" id="sanpham">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="text-center">Top 5 sản phẩm bán chạy</h5>
                    <canvas id="chartTopSanPham" class="big-chart"></canvas>
                </div>
            </div>
        </div>

        <!-- PHIẾU GIẢM GIÁ -->
        <div class="tab-pane fade" id="phieugiamgia">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number text-primary">${tongPhieu}</div>
                        <div class="stat-label">Mã giảm giá</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number text-info">${daPhatHanh}</div>
                        <div class="stat-label">Lượt phát hành</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number text-success">
                            <fmt:formatNumber value="${tongGiaTriGiam}" type="currency" currencySymbol="₫"/>
                        </div>
                        <div class="stat-label">Tổng giá trị đã giảm</div>
                    </div>
                </div>
            </div>

            <div class="card mt-4 shadow-sm">
                <div class="card-body">
                    <h5 class="text-center">Thống kê sử dụng phiếu giảm giá</h5>
                    <canvas id="chartPhieuGiamGia" class="big-chart"></canvas>
                </div>
            </div>
        </div>

        <!-- ĐỢT GIẢM GIÁ -->
        <div class="tab-pane fade" id="dotgiamgia">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number text-primary">${totalDot}</div>
                        <div class="stat-label">Tổng đợt giảm giá</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number text-success">${dangDienRa}</div>
                        <div class="stat-label">Đang diễn ra</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number text-warning">${sapDienRa}</div>
                        <div class="stat-label">Sắp diễn ra</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-number text-secondary">${daKetThuc}</div>
                        <div class="stat-label">Đã kết thúc</div>
                    </div>
                </div>
            </div>

            <div class="card mt-4 shadow-sm">
                <div class="card-body">
                    <h5 class="text-center">Thống kê đợt giảm giá</h5>
                    <canvas id="chartDotGiamGia" class="big-chart"></canvas>
                </div>
            </div>
        </div>

        <!-- ĐƠN HÀNG – ĐÃ SỬA ĐÚNG TRẠNG THÁI CỦA BẠN -->
        <div class="tab-pane fade" id="donhang">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <div class="stat-number text-primary">${tongDonHang}</div>
                        <div class="stat-label">Tổng đơn hàng</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <div class="stat-number text-warning">${choXacNhan}</div>
                        <div class="stat-label">Chờ xác nhận</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <div class="stat-number text-info">${daXacNhan + dangGiao}</div>
                        <div class="stat-label">Đang xử lý</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <div class="stat-number text-success">${hoanThanh + daThanhToan}</div>
                        <div class="stat-label">Hoàn thành</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card text-center">
                        <div class="stat-number text-danger">${daHuy}</div>
                        <div class="stat-label">Đã hủy</div>
                    </div>
                </div>
            </div>

            <div class="card mt-5 shadow-sm">
                <div class="card-body">
                    <h5 class="text-center mb-4">Phân bố trạng thái đơn hàng</h5>
                    <div class="chart-container">
                        <canvas id="chartDonHang" class="medium-chart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Biểu đồ doanh thu theo tháng
    new Chart(document.getElementById('chartDoanhThu'), {
        type: 'line',
        data: {
            labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10'],
            datasets: [{
                label: 'Doanh thu',
                data: [65000000, 59000000, 80000000, 81000000, 56000000, 55000000, 40000000, 70000000, 85000000, 90000000],
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13,110,253,0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: { responsive: true }
    });

    // Top sản phẩm
    const topSp = [
        <c:forEach items="${topSanPham}" var="sp" varStatus="loop">
        { ten: "${sp[0]}", sl: ${sp[1]} }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];
    new Chart(document.getElementById('chartTopSanPham'), {
        type: 'bar',
        data: {
            labels: topSp.map(x => x.ten),
            datasets: [{
                label: 'Số lượng bán',
                data: topSp.map(x => x.sl),
                backgroundColor: '#212529'
            }]
        },
        options: { responsive: true }
    });

    // Phiếu giảm giá
    new Chart(document.getElementById('chartPhieuGiamGia'), {
        type: 'bar',
        data: {
            labels: ['Tổng phiếu', 'Đã phát hành', 'Đã sử dụng'],
            datasets: [{
                label: 'Số lượng',
                data: [${tongPhieu}, ${daPhatHanh}, ${daSuDung}],
                backgroundColor: ['#0d6efd', '#198754', '#dc3545']
            }]
        },
        options: { responsive: true }
    });

    // Đợt giảm giá
    new Chart(document.getElementById('chartDotGiamGia'), {
        type: 'bar',
        data: {
            labels: ['Tổng đợt', 'Đang diễn ra', 'Sắp diễn ra', 'Đã kết thúc'],
            datasets: [{
                label: 'Số lượng',
                data: [${totalDot}, ${dangDienRa}, ${sapDienRa}, ${daKetThuc}],
                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#6c757d']
            }]
        },
        options: { responsive: true }
    });

    // ĐƠN HÀNG – ĐÃ SỬA ĐÚNG TRẠNG THÁI CỦA BẠN
    new Chart(document.getElementById('chartDonHang'), {
        type: 'doughnut',
        data: {
            labels: ['Chờ xác nhận', 'Đang xử lý', 'Hoàn thành', 'Đã hủy'],
            datasets: [{
                data: [${choXacNhan}, ${daXacNhan + dangGiao}, ${hoanThanh + daThanhToan}, ${daHuy}],
                backgroundColor: ['#ffc107', '#0d6efd', '#198754', '#dc3545'],
                borderWidth: 3
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'bottom' } }
        }
    });
</script>
</body>
</html>