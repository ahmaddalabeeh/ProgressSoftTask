import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';

class GenderDropdownTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? errorText;

  const GenderDropdownTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.errorText,
  });

  @override
  GenderDropdownTextFieldState createState() => GenderDropdownTextFieldState();
}

class GenderDropdownTextFieldState extends State<GenderDropdownTextField> {
  @override
  Widget build(BuildContext context) {
    final List<String> genders = [
      AppLocalizations.of(context)!.male,
      AppLocalizations.of(context)!.female
    ];
    return GestureDetector(
      onTap: () async {
        final selectedGender = await showModalBottomSheet<String>(
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.3,
              child: SafeArea(
                child: ListView.builder(
                  itemCount: genders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(genders[index]),
                      onTap: () {
                        Navigator.pop(context, genders[index]);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );

        if (selectedGender != null) {
          setState(() {
            widget.textEditingController.text = selectedGender;
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: widget.textEditingController,
          readOnly: true,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.r),
              borderSide: BorderSide(color: AppColors.error, width: 2.0.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.r),
              borderSide: BorderSide(color: AppColors.error, width: 2.0.w),
            ),
            errorText: widget.errorText,
            hintText: widget.hintText,
            prefixIcon: Icon(
                widget.textEditingController.text ==
                        AppLocalizations.of(context)!.male
                    ? Icons.male
                    : Icons.female,
                color: AppColors.primaryColor),
            suffixIcon: Icon(
              Icons.arrow_downward,
              color: AppColors.primaryColor,
              size: 22.r,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2.w),
            ),
          ),
        ),
      ),
    );
  }
}
