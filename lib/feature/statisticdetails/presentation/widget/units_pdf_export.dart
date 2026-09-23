import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../data/models/units_model.dart';

final RegExp _arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F]');
bool _isArabic(String text) => _arabicRegex.hasMatch(text);

Future<void> exportUnitsToPdf(
    List<PropertyUnit> units, {
      required String companyName,
    }) async {
  final pdf = pw.Document();
  final arabicFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoNaskhArabic-Medium.ttf'),
  );
  final logoBytes = await rootBundle.load('assets/images/icon.png');
  final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

  final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

  const double headerFont = 7;
  const double bodyFont = 6.5;
  const double cellHPad = 4;
  const double charWidthFactor = 0.5; // approx avg glyph width relative to font size
  const double numColWidth = 24;

  // ---- Compute a fixed width per column from the longest text ----
  double textWidth(String text, double fontSize) =>
      text.length * fontSize * charWidthFactor;

  final Map<int, pw.TableColumnWidth> columnWidths = {
    0: const pw.FixedColumnWidth(numColWidth),
  };
  double totalWidth = numColWidth;

  for (var i = 0; i < unitsColumns.length; i++) {
    final col = unitsColumns[i];
    double maxW = textWidth(col.header.tr, headerFont);
    for (final u in units) {
      final w = textWidth(col.getValue(u), bodyFont);
      if (w > maxW) maxW = w;
    }
    final colWidth = maxW + cellHPad * 2 + 4; // padding + small safety margin
    columnWidths[i + 1] = pw.FixedColumnWidth(colWidth);
    totalWidth += colWidth;
  }

  const double margin = 20;
  final baseFormat = PdfPageFormat.a3.landscape;
  // Page as wide as the table needs (never narrower than A4 landscape)
  final pageWidth = (totalWidth + margin * 2) > baseFormat.width
      ? totalWidth + margin * 2
      : baseFormat.width;
  final pageFormat = PdfPageFormat(
    pageWidth,
    baseFormat.height,
    marginAll: margin,
  );

  pw.Widget buildCell(String text, {bool isHeader = false}) {
    final rtl = _isArabic(text);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: cellHPad, vertical: 6),
      child: pw.Directionality(
        textDirection: rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        child: pw.Text(
          text,
          softWrap: false,
          maxLines: 1,
          textAlign: rtl ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            font: rtl ? arabicFont : null,
            fontSize: isHeader ? headerFont : bodyFont,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      margin: const pw.EdgeInsets.all(margin),
      header: (context) {
        if (context.pageNumber != 1) return pw.SizedBox();
        return pw.SizedBox(
          width: double.infinity,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(logoImage, height: 50),
              pw.SizedBox(height: 8),
              pw.Text(
                companyName,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(todayStr, style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 2),
              pw.Text(
                'Claimizer',
                style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 16),
            ],
          ),
        );
      },
      build: (context) => [
        pw.Table(
          border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey400),
          columnWidths: columnWidths,
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7E24D)),
              children: [
                buildCell('#', isHeader: true),
                ...unitsColumns.map((c) => buildCell(c.header.tr, isHeader: true)),
              ],
            ),
            ...units.asMap().entries.map(
                  (entry) => pw.TableRow(
                children: [
                  buildCell('${entry.key + 1}'),
                  ...unitsColumns.map((c) => buildCell(c.getValue(entry.value))),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
    format: PdfPageFormat.a3.landscape,
    onLayout: (format) async => pdf.save(),
  );
}