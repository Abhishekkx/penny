import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';

class CsvExporter {
  /// Converts all database transactions into a formatted CSV string
  static String generateTransactionsCsv(
    List<Transaction> transactions,
    String currencySymbol,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
      'Date,Time,Type,Category,Amount ($currencySymbol),Essential Need,Note',
    );

    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    for (final tx in transactions) {
      final dateStr = dateFormat.format(tx.date);
      final timeStr = timeFormat.format(tx.date);
      final typeStr = tx.type.name.toUpperCase();
      final catStr = tx.category.name;
      final amountStr = tx.amount.toStringAsFixed(2);
      final isNeedStr = tx.isNeed ? 'YES' : 'NO';
      final rawNote = tx.note;
      final noteStr = '"${rawNote.replaceAll('"', '""')}"';

      buffer.writeln(
        '$dateStr,$timeStr,$typeStr,$catStr,$amountStr,$isNeedStr,$noteStr',
      );
    }

    return buffer.toString();
  }

  /// Exports the CSV string to a file and opens the device share sheet
  static Future<File> exportAndShareCsv({
    required List<Transaction> transactions,
    required String currencySymbol,
  }) async {
    final csvContent = generateTransactionsCsv(transactions, currencySymbol);
    final tempDir = await getTemporaryDirectory();
    final fileName =
        'penny_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsString(csvContent);

    final xFile = XFile(file.path, mimeType: 'text/csv');
    await Share.shareXFiles([
      xFile,
    ], text: 'Exported Penny Financial Records (CSV)');

    return file;
  }
}
