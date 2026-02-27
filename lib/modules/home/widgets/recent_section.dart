import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/home/home_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/url_detector.dart';
import '../../../widgets/scan_type_badge.dart';

Widget buildRecentSection(HomeController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Recent Scans', style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
          GestureDetector(
            onTap: controller.goToHistory,
            child: Text('View All →',
                style: AppTextStyles.monoSmall.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Obx(() {
        if (controller.recentScans.isEmpty) {
          return _EmptyState();
        }
        return Column(
          children: controller.recentScans.asMap().entries.map((e) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (e.key * 80)),
              curve: Curves.easeOutCubic,
              builder: (context, val, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - val)),
                  child: Opacity(opacity: val, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RecentTile(
                  scan: e.value,
                  onTap: () => controller.openScanResult(e.value),
                ),
              ),
            );
          }).toList(),
        );
      }),
    ],
  );
}


































class _RecentTile extends StatelessWidget {
  final dynamic scan;
  final VoidCallback onTap;

  const _RecentTile({required this.scan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  UrlDetector.getIcon(scan.type),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.rawValue,
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      ScanTypeBadge(type: scan.type),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.formatRelative(scan.scannedAt),
                        style: AppTextStyles.monoSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_rounded, color: AppColors.textMuted, size: 48),
          const SizedBox(height: 16),
          Text('No Scans Yet', style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Tap the scan button above to\nstart scanning QR codes & barcodes',
              style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

