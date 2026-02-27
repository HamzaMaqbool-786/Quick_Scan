import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';

Widget buildCard(List<Widget> children) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: children),
  );
}
