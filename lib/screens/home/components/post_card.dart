import 'package:ahmad_progress_soft_task/screens/home/home_imports.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String body;

  const PostCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      margin: EdgeInsetsDirectional.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: FontSizes.large,
              fontWeight: FontWeights.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            height: 2.h,
            width: 30.w,
            color: AppColors.primaryColor,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            body,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: FontSizes.mid,
              fontWeight: FontWeights.regular,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
