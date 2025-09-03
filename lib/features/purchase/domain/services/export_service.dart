import 'package:csv/csv.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

class ExportService {
  /// Converte un singolo acquisto in una stringa in formato CSV.
  String purchaseToCsv(PurchaseModel purchase) {
    // Definiamo le intestazioni (header) del CSV
    final List<String> headers = [
      'Item Name',
      'Quantity',
      'Unit Price',
      'Subtotal',
      'Barcode',
    ];

    // Creiamo le righe dei dati
    final List<List<dynamic>> rows = purchase.items.map((item) {
      return [
        item.name,
        item.quantity,
        item.unitPrice,
        item.subtotal,
        item.barcode ?? '',
      ];
    }).toList();

    // Aggiungiamo righe di riepilogo in cima per contesto
    final summaryRows = [
      ['Store', purchase.store ?? 'N/A'],
      ['Date', DateFormat.yMd().format(purchase.date)],
      ['Total', purchase.total],
      <String>[], // Riga vuota per separazione
      headers,
    ];

    // Combina riepilogo e righe di dati
    final allRows = summaryRows..addAll(rows as Iterable<List<Object>>);

    // Converte la lista di liste in una stringa CSV
    return const ListToCsvConverter().convert(allRows);
  }
}
