import 'dart:async';

import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
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
            listener: (context, state) {
              if (state.status == AuthStatus.otpVerified) {
                Navigator.pop(context);
                // You can add additional logic for OTP verified here
              } else {
                //TODO: Show Error Dialog
              }
            },
            child: SingleChildScrollView(
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
                        context.read<AuthBloc>().add(VerifyOtpRequested(
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
            ),
          ),
        ),
      ),
    );
  }
}
