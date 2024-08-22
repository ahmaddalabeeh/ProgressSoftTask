import 'dart:async';

import 'package:ahmad_progress_soft_task/blocs/auth/auth_bloc.dart';
import 'package:ahmad_progress_soft_task/blocs/auth/auth_state.dart';
import 'package:ahmad_progress_soft_task/helpers/navigation_helper.dart';
import 'package:ahmad_progress_soft_task/screens/auth/sign_in_screen.dart';
import 'package:ahmad_progress_soft_task/screens/home/home_imports.dart';
import 'package:ahmad_progress_soft_task/screens/home/home_screen.dart';
import 'package:ahmad_progress_soft_task/singletons/resource_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const SplashScreen({super.key, required this.sharedPreferences});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      NavigationHelper.navigateToReplacement(
        context,
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedInState) {
              return HomeScreen(
                sharedPreferences: widget.sharedPreferences,
              );
            } else {
              return SignInScreen(sharedPreferences: widget.sharedPreferences);
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              ResourcePath.progress_soft_logo_png,
              width: 250.w,
              height: 250.h,
            ),
          ),
          PositionedDirectional(
            bottom: 20.h,
            start: 0,
            end: 0,
            child: Text(
              '© 2024 ProgressSoft. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: FontSizes.mid, color: AppColors.disabledColor),
            ),
          ),
        ],
      ),
    );
  }
}
