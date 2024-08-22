import 'dart:ui';

enum LanguageModel {
  english(
    Locale('en', 'US'),
    'English',
  ),
  arabic(
    Locale('ar', 'JO'),
    'عربي',
  );

  const LanguageModel(
    this.value,
    this.text,
  );

  final Locale value;
  final String text;
}
