import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/url_detector.dart';
import '../data/models/scan_result_model.dart';

class ScanTypeBadge extends StatelessWidget {
  final ScanType type;
  final bool small;

  const ScanTypeBadge({super.key, required this.type, this.small = true});

  Color get _color {
    switch (type) {
      case ScanType.url: return AppColors.urlColor;
      case ScanType.email: return AppColors.emailColor;
      case ScanType.phone: return AppColors.phoneColor;
      case ScanType.wifi: return AppColors.wifiColor;
      case ScanType.contact: return AppColors.secondary;
      case ScanType.sms: return AppColors.success;
      case ScanType.location: return AppColors.orange;
      case ScanType.text: return AppColors.textColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        UrlDetector.getDisplayType(type).toUpperCase(),
        style: GoogleFonts.spaceMono(
          fontSize: small ? 8 : 10,
          fontWeight: FontWeight.w700,
          color: _color,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
