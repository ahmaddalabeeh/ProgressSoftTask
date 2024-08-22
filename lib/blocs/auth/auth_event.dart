import 'package:equatable/equatable.dart';

abstract class IAuthEvent extends Equatable {
  const IAuthEvent();

  @override
  List<Object> get props => [];
}

class SetPasswordVisibility extends IAuthEvent {
  final bool showPassword;

  const SetPasswordVisibility({
    required this.showPassword,
  });

  @override
  List<Object> get props => [showPassword];
}

class SetConfirmPasswordVisibility extends IAuthEvent {
  final bool showConfirmPassword;

  const SetConfirmPasswordVisibility({
    required this.showConfirmPassword,
  });

  @override
  List<Object> get props => [showConfirmPassword];
}

class RegisterRequested extends IAuthEvent {
  final String fullName;
  final String phoneNumber;
  final String age;
  final String gender;
  final String password;

  const RegisterRequested({
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.password,
  });
}

class TextChanged extends IAuthEvent {
  final String phoneNumber;
  final String? signUpPhoneNumber;
  final String password;
  final String? gender;
  final String? age;
  final String? confirmPassword;
  final String? fullName;

  const TextChanged({
    this.gender,
    this.age,
    this.signUpPhoneNumber,
    this.confirmPassword,
    this.fullName,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [
        phoneNumber,
        password,
        gender ?? '',
        age ?? '',
        confirmPassword ?? '',
        fullName ?? '',
        signUpPhoneNumber ?? ''
      ];
}

class SignInRequested extends IAuthEvent {
  final String phoneNumber;
  final String password;

  const SignInRequested({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];
}

class AgeSelected extends IAuthEvent {
  final int age;

  const AgeSelected({
    required this.age,
  });

  @override
  List<Object> get props => [age];
}

class UploadUserDataRequested extends IAuthEvent {
  final String userId;
  final String name;
  final String phoneNumber;
  final String age;
  final String gender;
  final String password;

  const UploadUserDataRequested({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.password,
  });
}

class VerifyOtpRequested extends IAuthEvent {
  final String verificationId;
  final String otpCode;

  const VerifyOtpRequested(
      {required this.verificationId, required this.otpCode});

  @override
  List<Object> get props => [verificationId];
}

class AuthCheckRequested extends IAuthEvent {}

class AuthSignedIn extends IAuthEvent {}

class AuthSignedOut extends IAuthEvent {}
