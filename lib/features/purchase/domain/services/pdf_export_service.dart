// lib/features/purchase/domain/services/pdf_export_service.dart

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  Future<Uint8List> generatePurchaseReport({
    required String title,
    required List<PurchaseModel> purchases,
  }) async {
    final pdf = pw.Document();

    // Carica un font che supporti i caratteri speciali come '€'
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    // Calcola i totali aggregati
    final double totalOverall = purchases.fold(0, (sum, p) => sum + p.total);
    final double totalGlutenFree = purchases.fold(
      0,
      (sum, p) => sum + p.totalGlutenFree,
    );
    final double totalOther = purchases.fold(
      0,
      (sum, p) => sum + p.totalRegular,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(title, boldFont),
        footer: (context) => _buildFooter(context), // <-- Passa il context qui
        build: (context) => [
          _buildSummary(
            totalOverall: totalOverall,
            totalGlutenFree: totalGlutenFree,
            totalOther: totalOther,
            boldFont: boldFont,
            font: font,
          ),
          pw.Divider(height: 30),
          // Aggiungi un capitolo per ogni acquisto
          ...purchases.map(
            (purchase) => _buildPurchaseDetails(purchase, boldFont, font),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  // --- Widget Helper per la costruzione del PDF ---

  pw.Widget _buildHeader(String title, pw.Font boldFont) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Text(title, style: pw.TextStyle(font: boldFont, fontSize: 18)),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    // <-- 1. Accetta il pw.Context
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        // 2. Accedi a 'pageNumber' tramite il context
        'Pagina ${context.pageNumber} di ${context.pagesCount}',
        style: pw.TextStyle(
          font: pw.Font.helvetica(),
          fontStyle: pw.FontStyle.italic,
        ), // Ho usato un font di fallback
      ),
    );
  }

  pw.Widget _buildSummary({
    required double totalOverall,
    required double totalGlutenFree,
    required double totalOther,
    required pw.Font boldFont,
    required pw.Font font,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Riepilogo Generale',
          style: pw.TextStyle(font: boldFont, fontSize: 16),
        ),
        pw.SizedBox(height: 10),
        _summaryRow(
          'Spesa Totale:',
          '${totalOverall.toStringAsFixed(2)} €',
          boldFont,
          font,
          isTotal: true,
        ),
        pw.SizedBox(height: 5),
        _summaryRow(
          'Spesa Senza Glutine:',
          '${totalGlutenFree.toStringAsFixed(2)} €',
          boldFont,
          font,
        ),
        pw.SizedBox(height: 5),
        _summaryRow(
          'Spesa Altro:',
          '${totalOther.toStringAsFixed(2)} €',
          boldFont,
          font,
        ),
      ],
    );
  }

  pw.Widget _summaryRow(
    String label,
    String value,
    pw.Font boldFont,
    pw.Font font, {
    bool isTotal = false,
  }) {
    final style = pw.TextStyle(font: isTotal ? boldFont : font, fontSize: 12);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: style),
        pw.Text(value, style: style),
      ],
    );
  }

  pw.Widget _buildPurchaseDetails(
    PurchaseModel purchase,
    pw.Font boldFont,
    pw.Font font,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${DateFormat.yMMMd().format(purchase.date)} - ${purchase.store ?? 'Acquisto generico'}',
          style: pw.TextStyle(font: boldFont, fontSize: 14),
        ),
        pw.SizedBox(height: 8),
        pw.Table.fromTextArray(
          headers: ['Prodotto', 'Q.tà', 'P. Unitario', 'Subtotale'],
          cellStyle: pw.TextStyle(font: font, fontSize: 10),
          headerStyle: pw.TextStyle(font: boldFont, fontSize: 10),
          data: purchase.items
              .map(
                (item) => [
                  '${item.name} ${item.isGlutenFree ? "(SG)" : ""}',
                  item.quantity.toString(),
                  '${item.unitPrice.toStringAsFixed(2)} €',
                  '${item.subtotal.toStringAsFixed(2)} €',
                ],
              )
              .toList(),
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Totale Acquisto: ${purchase.total.toStringAsFixed(2)} €',
            style: pw.TextStyle(font: boldFont, fontSize: 12),
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }
}
