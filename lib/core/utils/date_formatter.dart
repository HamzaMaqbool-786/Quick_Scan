import 'package:intl/intl.dart';

abstract class DateFormatter {
  static String formatFull(DateTime dt) {
    return DateFormat('dd MMM yyyy · HH:mm:ss').format(dt);
  }

  static String formatShort(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  static String formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today · ${formatShort(dt)}';
    if (diff.inDays == 1) return 'Yesterday · ${formatShort(dt)}';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatDate(dt);
  }

  static String groupLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return 'This Week';
    if (diff.inDays < 30) return 'This Month';
    return DateFormat('MMMM yyyy').format(dt);
  }
}
