import 'package:ahmad_progress_soft_task/singletons/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isEnabled;
  final Widget child;
  const CustomElevatedButton(
      {super.key,
      required this.onPressed,
      this.isEnabled = true,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0.r),
          ),
          backgroundColor:
              isEnabled ? AppColors.primaryColor : AppColors.disabledColor,
        ),
        child: child);
  }
}
