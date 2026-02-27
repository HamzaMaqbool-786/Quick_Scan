import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/history/widgets/app_bar.dart';
import 'package:quickscan/modules/history/widgets/filter_chips.dart';
import 'package:quickscan/modules/history/widgets/history_list.dart';
import 'package:quickscan/modules/history/widgets/search_bar.dart';
import 'history_controller.dart';
import '../../core/theme/app_colors.dart';


class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Find controller once — pass explicitly to every child
    final c = Get.find<HistoryController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HistoryAppBar(c: c),
      body: Column(
        children: [
          SearchBarWidget(c: c),
          FilterChips(c: c),
          Expanded(child: HistoryList(c: c)),
        ],
      ),
    );
  }
}
