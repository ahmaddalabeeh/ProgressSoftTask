import 'dart:async';

import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
import 'package:ahmad_progress_soft_task/screens/auth/sign_in_screen.dart';
import 'package:ahmad_progress_soft_task/screens/profile/my_user_model.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final SharedPreferences sharedPreferences;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.sharedPreferences,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
        navigateToSignUpScreen();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void navigateToSignUpScreen() {
    NavigationHelper.navigatePushAndRemoveUntil(
      context,
      SignUpScreen(sharedPreferences: widget.sharedPreferences),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel data =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return BlocProvider(
      create: (context) => AuthBloc(widget.sharedPreferences),
      child: Scaffold(
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
        body: BlocProvider(
          create: (_) => AuthBloc(widget.sharedPreferences),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (ctx, state) {
              if (state.status == AuthStatus.otpVerified) {
                Navigator.pop(context, state);
                ctx.read<AuthBloc>().add(UploadUserDataRequested(
                      password: data.password ?? '',
                      name: data.name,
                      userId: 'user_id',
                      phoneNumber: data.phoneNumber,
                      age: data.age,
                      gender: data.gender,
                    ));
                Future.delayed(const Duration(seconds: 2));
                _showVerified(context, widget.sharedPreferences);
              } else if (state.status == AuthStatus.failure) {
                _showWrongOtp(context);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
              return SingleChildScrollView(
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
                      SizedBox(height: 20.h),
                      Pinput(
                        length: 6,
                        onCompleted: (otp) {
                          ctx.read<AuthBloc>().add(VerifyOtpRequested(
                                verificationId: widget.verificationId,
                                otpCode: otp,
                              ));
                        },
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'OTP Timer: $_start',
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

void _showWrongOtp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('Wrong Otp, please try again.'),
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

void _showVerified(BuildContext context, SharedPreferences sharedPreferences) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('Account Created Successfully'),
        actions: <Widget>[
          TextButton(
            child: const Text('Thank you'),
            onPressed: () {
              NavigationHelper.navigateToAsync(
                  context, SignInScreen(sharedPreferences: sharedPreferences));
            },
          ),
        ],
      );
    },
  );
}
