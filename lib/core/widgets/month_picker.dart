import 'package:flutter/material.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// Un semplice dialogo per permettere all'utente di selezionare un mese.
Future<int?> showMonthPicker({
  required BuildContext context,
  required int initialYear,
}) async {
  final now = DateTime.now();
  final List<String> months = [];
  // Usa l'app localizations per i nomi dei mesi
  final locale = Localizations.localeOf(context).toString();

  for (int i = 1; i <= 12; i++) {
    // Non mostrare mesi futuri se l'anno è quello corrente
    if (initialYear == now.year && i > now.month) break;
    months.add(DateFormat.MMMM(locale).format(DateTime(initialYear, i)));
  }

  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      final l10n = AppLocalizations.of(context)!;
      return SimpleDialog(
        title: Text(l10n.selectMonthOfYear(initialYear.toString())),
        children: months.map((monthName) {
          final monthNumber = months.indexOf(monthName) + 1;
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, monthNumber),
            child: Text(monthName),
          );
        }).toList(),
      );
    },
  );
}
