import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == '—') return '—';
    try {
      final dateTime = DateTime.parse(rawDate.trim());
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  static String formatShortDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '—';
    try {
      final dateTime = DateTime.parse(rawDate.trim());
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }
}
