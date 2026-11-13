import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text(title, style: textTheme.titleLarge)),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(AppStrings.seeAll, style: textTheme.labelMedium),
          ),
      ],
    );
  }
}
