import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, AppSizes.buttonHeight)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (isOutlined) return AppColors.transparent;
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textDisabled;
        }
        return AppColors.primary;
      }),
      foregroundColor: WidgetStatePropertyAll(
        isOutlined ? AppColors.primary : AppColors.textOnPrimary,
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: isOutlined ? AppColors.border : AppColors.transparent,
          width: AppSizes.borderWidth,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
      ),
      textStyle: WidgetStatePropertyAll(AppTextTheme.textTheme.labelLarge),
      elevation: const WidgetStatePropertyAll(0),
    );

    return SizedBox(
      width: width ?? double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: _buildContent(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: AppSizes.iconMedium,
        width: AppSizes.iconMedium,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.splashIndicatorStroke,
          color: AppColors.textOnPrimary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
