import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.appName, style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.dashboardSubtitle, style: textTheme.bodySmall),
      ],
    );
  }
}
