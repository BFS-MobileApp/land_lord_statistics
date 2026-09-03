import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:flutter/services.dart';
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

  pw.Widget buildCell(String text, {bool isHeader = false}) {
    final rtl = _isArabic(text);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: pw.Directionality(
        textDirection: rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        child: pw.Text(
          text,
          textAlign: rtl ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            font: rtl ? arabicFont : null,
            fontSize: isHeader ? 7 : 6.5,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(20),
      header: (context) {
        if (context.pageNumber != 1) return pw.SizedBox();
        return pw.Column(
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
            pw.Text('Claimizer', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
            pw.SizedBox(height: 16),
          ],
        );
      },
      build: (context) => [
        pw.Table(
          border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(24), // # column
            for (var i = 0; i < unitsColumns.length; i++) i + 1: const pw.FlexColumnWidth(),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7E24D)),
              children: [
                buildCell('#', isHeader: true),
                ...unitsColumns.map((c) => buildCell(c.header, isHeader: true)),
              ],
            ),
            // Data rows
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

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}