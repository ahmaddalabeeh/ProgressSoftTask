import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState(
      {this.showPassword = false,
      this.showConfirmPassword = false,
      this.isButtonEnabled = false,
      this.isSignUpButtonEnabled = false,
      this.status = AuthStatus.initial,
      this.errorMessage,
      this.verificationId = '',
      this.phoneNumber = '',
      this.password = '',
      this.signUpPhoneNumber = '',
      this.age = 0,
      this.isPhoneNumberValid = true,
      this.isSignUpPhoneNumberValid = true,
      this.isPasswordValid = true,
      this.isGenderValid = true,
      this.isAgeValid = true,
      this.isConfirmPasswordValid = true,
      this.isFullNameValid = true});

  final bool showPassword;
  final bool showConfirmPassword;
  final bool isButtonEnabled;
  final bool isSignUpButtonEnabled;
  final AuthStatus status;
  final String? errorMessage;
  final String phoneNumber;
  final String signUpPhoneNumber;
  final String password;
  final int age;
  final bool isPhoneNumberValid;
  final bool isSignUpPhoneNumberValid;
  final bool isPasswordValid;
  final bool isGenderValid;
  final bool isAgeValid;
  final bool isConfirmPasswordValid;
  final bool isFullNameValid;
  final String verificationId;
  @override
  List<Object> get props => [
        showPassword,
        showConfirmPassword,
        status,
        errorMessage ?? '',
        phoneNumber,
        password,
        age,
        isButtonEnabled,
        isPhoneNumberValid,
        isPasswordValid,
        isAgeValid,
        isGenderValid,
        isConfirmPasswordValid,
        isFullNameValid,
        isSignUpButtonEnabled,
        isSignUpPhoneNumberValid,
        signUpPhoneNumber,
        verificationId,
      ];

  AuthState copyWith(
      {bool? showPassword,
      bool? showConfirmPassword,
      bool? isButtonEnabled,
      AuthStatus? status,
      String? errorMessage,
      String? phoneNumber,
      String? password,
      String? signUpPhoneNumber,
      String? verificationId,
      int? age,
      bool? isPhoneNumberValid,
      bool? isSignUpPhoneNumberValid,
      bool? isPasswordValid,
      bool? isGenderValid,
      bool? isAgeValid,
      bool? isConfirmPasswordValid,
      bool? isFullNameValid,
      bool? isSignUpButtonEnabled}) {
    return AuthState(
        showPassword: showPassword ?? this.showPassword,
        showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
        isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
        status: status ?? this.status,
        signUpPhoneNumber: signUpPhoneNumber ?? this.signUpPhoneNumber,
        isSignUpPhoneNumberValid:
            isSignUpPhoneNumberValid ?? this.isSignUpPhoneNumberValid,
        errorMessage: errorMessage ?? this.errorMessage,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        age: age ?? this.age,
        isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isAgeValid: isAgeValid ?? this.isAgeValid,
        isConfirmPasswordValid:
            isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        isGenderValid: isGenderValid ?? this.isGenderValid,
        isSignUpButtonEnabled:
            isSignUpButtonEnabled ?? this.isSignUpButtonEnabled,
        verificationId: verificationId ?? this.verificationId,
        isFullNameValid: isFullNameValid ?? this.isFullNameValid);
  }
}

enum AuthStatus {
  initial,
  loading,
  userExists,
  success,
  otpSent,
  failure,
  newUser,
  wrongPassword,
  wrongOtp,
  otpVerified
}

class AuthInitial extends AuthState {}

class AuthSignedInState extends AuthState {}

class CodeSentState extends AuthState {}

class AuthSignedOutState extends AuthState {}
