import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/url_detector.dart';
import '../../../data/models/scan_result_model.dart';
import '../../../widgets/scan_type_badge.dart';
import '../history_controller.dart';

class HistoryList extends StatelessWidget {
  final HistoryController c;

  const HistoryList({required this.c});

  @override
  Widget build(BuildContext context) {
    // ✅ Single Obx reads ALL observables up front as plain values,
    //    then passes them down as regular Dart values — NO nested Obx
    return Obx(() {
      final scans = c.filteredScans.toList(); // RxList → plain List
      final hasSearch = c.searchQuery.value.isNotEmpty;
      final selMode = c.isSelectionMode.value;
      final selected = c.selectedItems.toSet(); // RxSet → plain Set

      if (scans.isEmpty) {
        return _EmptyHistory(hasSearch: hasSearch);
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: scans.length,
        itemBuilder: (_, index) {
          final scan = scans[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            // ✅ Pure widget — receives plain bool/callbacks, no Obx inside
            child: _SlidableTile(
              scan: scan,
              isSelectionMode: selMode,
              isSelected: selected.contains(scan),
              onTap: () =>
                  selMode ? c.toggleSelection(scan) : c.openScanResult(scan),
              onLongPress: () {
                if (!selMode) {
                  c.toggleSelectionMode();
                  c.toggleSelection(scan);
                }
              },
              onDelete: () => c.deleteScan(scan),
              onCopy: () => c.copyToClipboard(scan),
              onFavorite: () => c.toggleFavorite(scan),
            ),
          );
        },
      );
    });
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool hasSearch;

  const _EmptyHistory({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Icons.search_off_rounded : Icons.history_rounded,
              color: AppColors.textMuted,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch ? 'No Results Found' : 'No Scan History',
              style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              hasSearch
                  ? 'Try a different search term'
                  : 'Your scanned codes will appear here',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidableTile extends StatelessWidget {
  final ScanResultModel scan;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;

  const _SlidableTile({
    required this.scan,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onCopy,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(scan.key),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            onPressed: (_) => onCopy(),
            backgroundColor: AppColors.secondaryDim,
            foregroundColor: AppColors.secondary,
            icon: Icons.copy_rounded,
            label: 'Copy',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
          SlidableAction(
            onPressed: (_) => onFavorite(),
            backgroundColor: AppColors.warningDim,
            foregroundColor: AppColors.warning,
            icon: scan.isFavorite
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            label: scan.isFavorite ? 'Unstar' : 'Star',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppColors.errorDim,
            foregroundColor: AppColors.error,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDim : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primaryBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              if (isSelectionMode)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderLight,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.background, size: 14)
                      : null,
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ScanTypeBadge(type: scan.type),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormatter.formatRelative(scan.scannedAt),
                            style: AppTextStyles.monoSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (scan.isFavorite && !isSelectionMode)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.star_rounded,
                      color: AppColors.warning, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
