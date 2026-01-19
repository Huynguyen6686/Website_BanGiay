package com.example.ASM.controller;

import com.example.ASM.repository.ThongKeRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/thong-ke")
public class ThongKeServlet extends HttpServlet {

    private final ThongKeRepository tkRepo = new ThongKeRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // XỬ LÝ XUẤT EXCEL
        if ("export".equals(req.getParameter("action"))) {
            exportExcel(resp);
            return;
        }

        try {
            // 1. TỔNG DOANH THU TỪ TRƯỚC ĐẾN NAY (trạng thái 3 và 4) - Đây là cái hiển thị ở card chính
            double tongDoanhThuAllTime = tkRepo.getTongDoanhThuAllTime();

            // 2. Tổng số đơn hàng hoàn thành để tính trung bình
            Map<Integer, Long> ttMap = tkRepo.getTrangThaiDonHang();
            long tongDonHoanThanh = ttMap.getOrDefault(3, 0L) + ttMap.getOrDefault(4, 0L);
            double tbDonHang = tongDonHoanThanh > 0 ? tongDoanhThuAllTime / tongDonHoanThanh : 0.0;

            // 3. Top 5 sản phẩm bán chạy (đã sửa IN(3,4) trong Repository)
            List<Object[]> topSp = tkRepo.getTop5SanPham();
            if (topSp == null) topSp = new ArrayList<>();

            // 4. Phiếu giảm giá
            Map<String, Object> pggStats = tkRepo.getPhieuGiamGiaStats();
            if (pggStats == null) pggStats = new HashMap<>();

            // 5. Trạng thái đơn hàng
            long tongDon = ttMap.values().stream().mapToLong(Long::longValue).sum();
            long choXacNhan = ttMap.getOrDefault(0, 0L);
            long daXacNhan = ttMap.getOrDefault(1, 0L);
            long dangGiao = ttMap.getOrDefault(2, 0L);
            long hoanThanh = ttMap.getOrDefault(3, 0L);
            long daThanhToan = ttMap.getOrDefault(4, 0L);
            long daHuy = ttMap.getOrDefault(-1, 0L);

            // 6. Doanh thu theo tháng (12 tháng gần nhất)
            List<Object[]> dtThang = tkRepo.getDoanhThuTheoThang();
            if (dtThang == null) dtThang = new ArrayList<>();

            // 7. Đợt giảm giá
            long totalDot = tkRepo.getAllDotGiamGia().size();
            long dangDienRa = tkRepo.countDangDienRa();
            long sapDienRa = tkRepo.countSapDienRa();
            long daKetThuc = tkRepo.countDaKetThuc();

            // === GỬI DỮ LIỆU SANG JSP ===
            req.setAttribute("doanhThu", tongDoanhThuAllTime);           // Tổng doanh thu thật
            req.setAttribute("tbDonHang", tbDonHang);                    // Trung bình đơn hàng
            req.setAttribute("topSanPham", topSp);

            req.setAttribute("tongPhieu", pggStats.getOrDefault("tongPhieu", 0L));
            req.setAttribute("daPhatHanh", pggStats.getOrDefault("daPhatHanh", 0L));
            req.setAttribute("daSuDung", pggStats.getOrDefault("daSuDung", 0L));
            req.setAttribute("tongGiaTriGiam", pggStats.getOrDefault("tongGiaTri", 0.0));

            req.setAttribute("tongDonHang", tongDon);
            req.setAttribute("choXacNhan", choXacNhan);
            req.setAttribute("daXacNhan", daXacNhan);
            req.setAttribute("dangGiao", dangGiao);
            req.setAttribute("hoanThanh", hoanThanh);
            req.setAttribute("daThanhToan", daThanhToan);
            req.setAttribute("daHuy", daHuy);

            req.setAttribute("dtThang", dtThang);

            req.setAttribute("totalDot", totalDot);
            req.setAttribute("dangDienRa", dangDienRa);
            req.setAttribute("sapDienRa", sapDienRa);
            req.setAttribute("daKetThuc", daKetThuc);

            req.setAttribute("pageTitle", "Thống kê & Báo cáo");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
        }

        req.getRequestDispatcher("/view/ThongKe.jsp").forward(req, resp);
    }

    // === XUẤT EXCEL (đã cập nhật dùng tổng doanh thu thật) ===
    private void exportExcel(HttpServletResponse response) throws IOException {
        double doanhThu = tkRepo.getTongDoanhThuAllTime();
        Map<Integer, Long> ttMap = tkRepo.getTrangThaiDonHang();
        long soDon = ttMap.getOrDefault(3, 0L) + ttMap.getOrDefault(4, 0L);
        double tbDonHang = soDon > 0 ? doanhThu / soDon : 0;

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Bao Cao Thong Ke");

        // Style header
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);

        // Tiêu đề
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO THỐNG KÊ KINH DOANH");
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 6));

        int rowNum = 2;

        // Doanh thu
        Row row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("TỔNG DOANH THU (TỪ TRƯỚC ĐẾN NAY)");
        row.createCell(1).setCellValue(doanhThu);
        row.getCell(0).setCellStyle(headerStyle);
        row.getCell(1).setCellStyle(headerStyle);

        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Doanh thu trung bình/đơn");
        row.createCell(1).setCellValue(tbDonHang);

        rowNum += 2;

        // Top 5 sản phẩm
        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("TOP 5 SẢN PHẨM BÁN CHẠY");
        row.getCell(0).setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 0, 2));

        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("STT");
        row.createCell(1).setCellValue("Tên sản phẩm");
        row.createCell(2).setCellValue("Số lượng bán");
        for (int i = 0; i < 3; i++) row.getCell(i).setCellStyle(headerStyle);

        List<Object[]> topSp = tkRepo.getTop5SanPham();
        if (topSp == null) topSp = new ArrayList<>();

        int stt = 1;
        for (Object[] sp : topSp) {
            row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(stt++);
            row.createCell(1).setCellValue(sp[0].toString());
            row.createCell(2).setCellValue(((Number) sp[1]).longValue());
        }

        rowNum += 2;

        // Trạng thái đơn hàng
        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("PHÂN BỐ TRẠNG THÁI ĐƠN HÀNG");
        row.getCell(0).setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum-1, rowNum-1, 0, 1));

        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Trạng thái");
        row.createCell(1).setCellValue("Số lượng");
        row.getCell(0).setCellStyle(headerStyle);
        row.getCell(1).setCellStyle(headerStyle);

        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Chờ xác nhận"); row.createCell(1).setCellValue(ttMap.getOrDefault(0, 0L));
        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Đang xử lý");   row.createCell(1).setCellValue(ttMap.getOrDefault(1, 0L) + ttMap.getOrDefault(2, 0L));
        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Hoàn thành");   row.createCell(1).setCellValue(ttMap.getOrDefault(3, 0L) + ttMap.getOrDefault(4, 0L));
        row = sheet.createRow(rowNum++);
        row.createCell(0).setCellValue("Đã hủy");       row.createCell(1).setCellValue(ttMap.getOrDefault(-1, 0L));

        for (int i = 0; i <= 6; i++) sheet.autoSizeColumn(i);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=BaoCao_ThongKe_" +
                new SimpleDateFormat("dd-MM-yyyy_HH-mm").format(new Date()) + ".xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }
}