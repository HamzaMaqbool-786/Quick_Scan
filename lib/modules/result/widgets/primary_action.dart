import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickscan/modules/result/result_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/scan_result_model.dart';
Widget buildPrimaryActions(ResultController controller) {
  final type = controller.scan.type;
  return Column(
    children: [
      // Context-aware primary action
      if (type == ScanType.url) ...[
        _ActionButton(
          icon: Icons.open_in_browser_rounded,
          label: 'Open in Browser',
          color: AppColors.primary,
          onTap: controller.openUrl,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
      ] else if (type == ScanType.email) ...[
        _ActionButton(
          icon: Icons.email_rounded,
          label: 'Send Email',
          color: AppColors.secondary,
          onTap: controller.openEmail,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
      ] else if (type == ScanType.phone) ...[
        _ActionButton(
          icon: Icons.phone_rounded,
          label: 'Call Number',
          color: AppColors.success,
          onTap: controller.callPhone,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
      ],
      // Copy & Share row
      Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.copy_rounded,
              label: 'Copy',
              color: AppColors.secondary,
              onTap: controller.copyToClipboard,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              color: AppColors.orange,
              onTap: controller.shareResult,
            ),
          ),
        ],
      ),
    ],
  );
}
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(isPrimary ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
