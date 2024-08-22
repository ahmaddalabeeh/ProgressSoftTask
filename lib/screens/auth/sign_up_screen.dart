import 'package:flutter/cupertino.dart';
import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
import 'package:ahmad_progress_soft_task/screens/otp/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const SignUpScreen({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(sharedPreferences),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    _nameController.addListener(_onTextChanged);
    _genderController.addListener(_onTextChanged);
    _confirmPasswordController.addListener(_onTextChanged);
    _ageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _phoneNumberController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _nameController.removeListener(_onTextChanged);
    _genderController.removeListener(_onTextChanged);
    _ageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    context.read<AuthBloc>().add(
          TextChanged(
              phoneNumber: '',
              password: _passwordController.text,
              age: _ageController.text,
              confirmPassword: _confirmPasswordController.text,
              fullName: _nameController.text,
              gender: _genderController.text,
              signUpPhoneNumber: _phoneNumberController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGroundAppColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.backGroundAppColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ResourcePath.progress_soft_logo_png,
                width: 250.w,
                height: 250.h,
              ),
              CustomTextField(
                textEditingController: _nameController,
                hintText: AppLocalizations.of(context)!.fullName,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocBuilder<ConfigBloc, ConfigState>(
                builder: (context, configState) {
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String prefix = '';

                      if (configState is ConfigLoaded) {
                        prefix = configState.countryCode;
                      }
                      return CustomTextField(
                        prefix: Text("$prefix | "),
                        hintText: AppLocalizations.of(context)!.phoneNumber,
                        textEditingController: _phoneNumberController,
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        errorText: state.isSignUpPhoneNumberValid
                            ? null
                            : '${AppLocalizations.of(context)!.invalidPhoneNumber}\n'
                                '${AppLocalizations.of(context)!.phoneNoExample}',
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                  hintText: 'Age',
                  textEditingController: _ageController,
                  suffixIcon: Icons.arrow_downward,
                  showSuffixIcon: true,
                  readOnly: true,
                  onSuffixIconTap: () {
                    _showAgePickerBottomSheet(context);
                  },
                  prefixIcon: Icons.person_2),
              SizedBox(
                height: 20.h,
              ),
              GenderDropdownTextField(
                hintText: AppLocalizations.of(context)!.gender,
                textEditingController: _genderController,
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomTextField(
                    hintText: AppLocalizations.of(context)!.password,
                    prefixIcon: Icons.lock,
                    textEditingController: _passwordController,
                    showSuffixIcon: true,
                    suffixIcon: state.showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconTap: () {
                      context.read<AuthBloc>().add(
                            SetPasswordVisibility(
                              showPassword: !state.showPassword,
                            ),
                          );
                    },
                    obscureText: !state.showPassword,
                    errorText: state.isPasswordValid
                        ? null
                        : '${AppLocalizations.of(context)!.passwordRequirements}\n'
                            '• ${AppLocalizations.of(context)!.passwordCharacterLength}\n'
                            '• ${AppLocalizations.of(context)!.passwordUpperCase}\n'
                            '• ${AppLocalizations.of(context)!.passwordLowerCase}\n'
                            '• ${AppLocalizations.of(context)!.passwordDigitRequirement}\n'
                            '• ${AppLocalizations.of(context)!.passwordSpecialRequirement}',
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomTextField(
                    hintText: AppLocalizations.of(context)!.confirmPassword,
                    prefixIcon: Icons.lock,
                    textEditingController: _confirmPasswordController,
                    showSuffixIcon: true,
                    suffixIcon: state.showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconTap: () {
                      context.read<AuthBloc>().add(
                            SetConfirmPasswordVisibility(
                              showConfirmPassword: !state.showConfirmPassword,
                            ),
                          );
                    },
                    errorText: state.isConfirmPasswordValid
                        ? null
                        : 'Passwords must match',
                    obscureText: !state.showConfirmPassword,
                  );
                },
              ),
              SizedBox(
                height: 30.h,
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  {
                    if (state.verificationId.isNotEmpty) {
                      NavigationHelper.navigateTo(
                        context,
                        OtpScreen(verificationId: state.verificationId),
                      );
                    } else if (state.status == AuthStatus.failure) {
                      // Show error message or handle failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(state.errorMessage ?? 'Unknown error')),
                      );
                    }
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    return CustomElevatedButton(
                      onPressed: state.isSignUpButtonEnabled
                          ? () {
                              if (state.status == AuthStatus.loading) {
                                null;
                              } else {
                                ctx.read<AuthBloc>().add(RegisterRequested(
                                      fullName: _nameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      age: _ageController.text,
                                      gender: _genderController.text,
                                      password: _passwordController.text,
                                    ));
                                //TODO: Move this one below in the otp verify page saying that is AuthStatus.success then call it
                                if (state.status == AuthStatus.otpVerified) {
                                  ctx
                                      .read<AuthBloc>()
                                      .add(UploadUserDataRequested(
                                        password: _passwordController.text,
                                        name: _nameController.text,
                                        //TODO: CHange this when it works
                                        userId: 'user_id',
                                        phoneNumber:
                                            _phoneNumberController.text,
                                        age: _ageController.text,
                                        gender: _genderController.text,
                                      ));
                                }
                              }
                            }
                          : null,
                      isEnabled: state.isSignUpButtonEnabled,
                      child: Center(
                        child: state.status == AuthStatus.loading
                            ? const CircularProgressIndicator()
                            : Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                  fontSize: FontSizes.xxMid,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAgePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int selectedAge = 1; // Default selected age

        return SizedBox(
          height: 250.h,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0.h,
                  onSelectedItemChanged: (int index) {
                    selectedAge = index + 1;
                    _ageController.text = '$selectedAge';
                  },
                  children: List<Widget>.generate(100, (int index) {
                    return Center(child: Text('${index + 1}'));
                  }),
                ),
              ),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _ageController.text = '$selectedAge';
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    AppLocalizations.of(context)!.selectAge,
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
