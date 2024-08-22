import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
import 'package:ahmad_progress_soft_task/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const SignInScreen({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(sharedPreferences),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            NavigationHelper.navigateToReplacement(
                context,
                HomeScreen(
                  sharedPreferences: sharedPreferences,
                ));
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication failed')),
            );
          } else if (state.status == AuthStatus.wrongPassword) {
            _showWrongPasswordDialog(context);
          } else if (state.status == AuthStatus.newUser) {
            _showNewUserDialog(context, sharedPreferences);
          }
        },
        child: _SignInView(sharedPreferences),
      ),
    );
  }
}

class _SignInView extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const _SignInView(this.sharedPreferences);

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    context.read<AuthBloc>().add(
          TextChanged(
            phoneNumber: _phoneNumberController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _phoneNumberController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomTextField(
                    hintText: AppLocalizations.of(context)!.phoneNumber,
                    textEditingController: _phoneNumberController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    errorText: state.isPhoneNumberValid
                        ? null
                        : '${AppLocalizations.of(context)!.invalidPhoneNumber}\n'
                            '${AppLocalizations.of(context)!.phoneNoSignInEg}',
                  );
                },
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
                height: 30.h,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomElevatedButton(
                    onPressed: state.isButtonEnabled
                        ? () {
                            context.read<AuthBloc>().add(
                                  SignInRequested(
                                    phoneNumber: _phoneNumberController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        : null,
                    isEnabled: state.isButtonEnabled,
                    child: Center(
                      child: state.status == AuthStatus.loading
                          ? const CircularProgressIndicator()
                          : Text(
                              AppLocalizations.of(context)!.signIn,
                              style: TextStyle(
                                fontSize: FontSizes.xxMid,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.registerNewAccount,
                      style: const TextStyle(
                        color: AppColors.blackColor,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.registerNow,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: FontSizes.mid,
                        fontWeight: FontWeights.semiBold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationHelper.navigateTo(
                              context,
                              SignUpScreen(
                                sharedPreferences: widget.sharedPreferences,
                              ));
                          _passwordController.clear();
                          _phoneNumberController.clear();
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showWrongPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('Wrong password, please try again.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showNewUserDialog(
    BuildContext context, SharedPreferences sharedPreferences) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text(AppLocalizations.of(context)!.newUser),
          content: Text(AppLocalizations.of(context)!.phoneNumberNotFound),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.signUp),
                  onPressed: () {
                    Navigator.of(context).pop();

                    NavigationHelper.navigateTo(context,
                        SignUpScreen(sharedPreferences: sharedPreferences));
                  },
                ),
              ],
            )
          ]);
    },
  );
}
