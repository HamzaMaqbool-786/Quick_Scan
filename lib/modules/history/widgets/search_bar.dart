import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../history_controller.dart';
class SearchBarWidget extends StatefulWidget {
  final HistoryController c;
  const SearchBarWidget({super.key, required this.c});

  @override
  State<SearchBarWidget> createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _textController,
        onChanged: widget.c.setSearchQuery,
        style:
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search scans...',
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textMuted, size: 20),
          // ✅ Obx wraps ONLY suffix icon — reads searchQuery.value
          suffixIcon: Obx(() => widget.c.searchQuery.value.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear_rounded,
                color: AppColors.textMuted, size: 18),
            onPressed: () {
              _textController.clear();
              widget.c.setSearchQuery('');
            },
          )
              : const SizedBox.shrink()),
        ),
      ),
    );
  }
}