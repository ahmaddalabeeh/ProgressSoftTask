import 'package:ahmad_progress_soft_task/singletons/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer(
      {super.key,
      this.borderRadius,
      required this.height,
      required this.width});
  final double? borderRadius;
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            height: height,
            width: width,
            margin: EdgeInsetsDirectional.only(bottom: 12.h),
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
                color: AppColors.disabledColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 8.r))),
          )),
    );
  }
}
