import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../history_controller.dart';
class FilterChips extends StatelessWidget {
  final HistoryController c;
  const FilterChips({required this.c});

  static const _filters = [
    (ScanFilter.all, 'All'),
    (ScanFilter.url, '🌐 URL'),
    (ScanFilter.email, '📧 Email'),
    (ScanFilter.phone, '📞 Phone'),
    (ScanFilter.barcode, '📦 Barcode'),
    (ScanFilter.favorites, '⭐ Starred'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
      child: SizedBox(
        height: 36,
        // ✅ Obx reads activeFilter.value — used directly inside builder
        child: Obx(() {
          final active = c.activeFilter.value; // ← observable read is HERE
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final isActive = active == _filters[i].$1;
              return GestureDetector(
                onTap: () => c.setFilter(_filters[i].$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryDim
                        : AppColors.surface2,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primaryBorder
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    _filters[i].$2,
                    style: AppTextStyles.monoSmall.copyWith(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
