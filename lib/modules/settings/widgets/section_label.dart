import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_text_styles.dart';

Widget buildSectionLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(label, style: AppTextStyles.monoLabel),
  );
}
