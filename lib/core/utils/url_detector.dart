import '../../data/models/scan_result_model.dart';

abstract class UrlDetector {
  static ScanType detect(String? value) {
    if (value == null || value.isEmpty) return ScanType.text;

    final lower = value.toLowerCase().trim();

    if (lower.startsWith('http://') || lower.startsWith('https://') || lower.startsWith('www.')) {
      return ScanType.url;
    }
    if (lower.startsWith('mailto:') || RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$').hasMatch(lower)) {
      return ScanType.email;
    }
    if (lower.startsWith('tel:') || lower.startsWith('phone:') || RegExp(r'^\+?[\d\s\-()]{7,15}$').hasMatch(lower)) {
      return ScanType.phone;
    }
    if (lower.startsWith('wifi:') || lower.startsWith('wlan:')) {
      return ScanType.wifi;
    }
    if (lower.startsWith('begin:vcard') || lower.startsWith('mecard:')) {
      return ScanType.contact;
    }
    if (lower.startsWith('smsto:') || lower.startsWith('sms:')) {
      return ScanType.sms;
    }
    if (lower.startsWith('geo:') || lower.startsWith('maps:')) {
      return ScanType.location;
    }
    return ScanType.text;
  }

  static String getDisplayType(ScanType type) {
    switch (type) {
      case ScanType.url: return 'URL';
      case ScanType.email: return 'Email';
      case ScanType.phone: return 'Phone';
      case ScanType.wifi: return 'Wi-Fi';
      case ScanType.contact: return 'Contact';
      case ScanType.sms: return 'SMS';
      case ScanType.location: return 'Location';
      case ScanType.text: return 'Text';
    }
  }

  static String getIcon(ScanType type) {
    switch (type) {
      case ScanType.url: return '🌐';
      case ScanType.email: return '📧';
      case ScanType.phone: return '📞';
      case ScanType.wifi: return '📶';
      case ScanType.contact: return '👤';
      case ScanType.sms: return '💬';
      case ScanType.location: return '📍';
      case ScanType.text: return '📄';
    }
  }

  /// Strips protocol prefix for display
  static String getActionableValue(String raw, ScanType type) {
    switch (type) {
      case ScanType.email:
        return raw.replaceFirst('mailto:', '');
      case ScanType.phone:
        return raw.replaceFirst('tel:', '').replaceFirst('phone:', '');
      case ScanType.sms:
        return raw.replaceFirst('smsto:', '').replaceFirst('sms:', '');
      default:
        return raw;
    }
  }
}
