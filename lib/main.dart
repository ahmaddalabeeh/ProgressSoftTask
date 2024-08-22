import 'package:ahmad_progress_soft_task/blocs/auth/auth_bloc.dart';
import 'package:ahmad_progress_soft_task/blocs/auth/auth_event.dart';
import 'package:ahmad_progress_soft_task/blocs/configuration/config_bloc.dart';
import 'package:ahmad_progress_soft_task/blocs/configuration/config_event.dart';
import 'package:ahmad_progress_soft_task/blocs/language/language_state.dart';
import 'package:ahmad_progress_soft_task/firebase_options.dart';
import 'package:ahmad_progress_soft_task/blocs/language/language_bloc.dart';
import 'package:ahmad_progress_soft_task/language/model/language_model.dart';
import 'package:ahmad_progress_soft_task/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('country_code', "+962");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ConfigBloc()..add(FetchCountryCode())),
        BlocProvider(
            create: (context) => AuthBloc(prefs)..add(AuthCheckRequested())),
        BlocProvider(
          create: (context) => LanguageBloc(prefs),
        )
      ],
      child: MyApp(
        sharedPreferences: prefs,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return ScreenUtilInit(
          designSize: const Size(361, 798),
          minTextAdapt: true,
          rebuildFactor: RebuildFactors.change,
          builder: (context, child) {
            return MaterialApp(
              title: 'Ahmad Progress Soft Task',
              locale: languageState.selectedLanguage.value,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales:
                  LanguageModel.values.map((e) => e.value).toList(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              home: SplashScreen(
                sharedPreferences: sharedPreferences,
              ),
            );
          },
        );
      },
    );
  }
}
