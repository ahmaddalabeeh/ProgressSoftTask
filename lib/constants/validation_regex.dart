class ValidationRegex {
  static const String phoneNumberRegex = r'^\+\d{12}$';
  static const String signUpPhoneNumberRegex = r'^\d{9}$';
  static const String passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
}
