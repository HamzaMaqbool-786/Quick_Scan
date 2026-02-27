import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/home/widgets/app_bar.dart';
import 'package:quickscan/modules/home/widgets/recent_section.dart';
import 'package:quickscan/modules/home/widgets/scanned_btn.dart';
import 'package:quickscan/modules/home/widgets/stat_rows.dart';
import 'home_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/url_detector.dart';
import '../../widgets/scan_type_badge.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () async => controller.loadRecent(),
          child: CustomScrollView(
            slivers: [
              buildAppBar(controller),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    buildScanButton(controller),
                    const SizedBox(height: 32),
                    buildStatsRow(controller),
                    const SizedBox(height: 32),
                    buildRecentSection(controller),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}




