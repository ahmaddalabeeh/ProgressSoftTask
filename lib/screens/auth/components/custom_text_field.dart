import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool? obscureText;
  final bool showSuffixIcon;
  final Function(String)? onChanged;
  final bool readOnly;
  final Widget? prefix;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final Function()? onSuffixIconTap;
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      required this.prefixIcon,
      this.errorText,
      this.onChanged,
      this.obscureText,
      this.prefix,
      this.suffixIcon,
      this.onSuffixIconTap,
      this.showSuffixIcon = false,
      this.readOnly = false,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      keyboardType: keyboardType,
      controller: textEditingController,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: TextStyle(fontSize: FontSizes.xMid),
      decoration: InputDecoration(
        hintText: hintText,
        prefix: prefix,
        errorText: errorText,
        hintStyle: TextStyle(fontSize: FontSizes.xMid),
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
        suffixIcon: showSuffixIcon
            ? InkWell(
                onTap: onSuffixIconTap,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Icon(
                  suffixIcon,
                  color: AppColors.primaryColor,
                  size: 22.r,
                ))
            : const SizedBox(),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        filled: true,
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: BorderSide(color: AppColors.error, width: 2.0.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: BorderSide(color: AppColors.error, width: 2.0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: BorderSide(color: AppColors.secondaryColor, width: 1.5.w),
        ),
      ),
    );
  }
}
