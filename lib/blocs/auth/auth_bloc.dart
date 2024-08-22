// ignore_for_file: avoid_print

import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<IAuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  AuthBloc(this.sharedPreferences) : super(const AuthState()) {
    on<SetPasswordVisibility>(onSetPasswordVisibility);
    on<SetConfirmPasswordVisibility>(onSetConfirmPasswordVisibility);
    on<SignInRequested>(onSignInRequested);
    on<TextChanged>(onTextChanged);
    on<AgeSelected>(onAgeSelected);
    on<RegisterRequested>(onRegisterRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignedIn>(_onAuthSignedIn);
    on<AuthSignedOut>(_onAuthSignedOut);
    on<UploadUserDataRequested>(onUploadUserDataRequested);
  }
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isSignedIn = sharedPreferences.getBool('is_signedin') ?? false;
    if (isSignedIn) {
      emit(AuthSignedInState());
    } else {
      emit(AuthSignedOutState());
    }
  }

  Future<void> uploadUserData({
    required String userId,
    required String name,
    required String phoneNumber,
    required String age,
    required String gender,
    required String password,
    Emitter<AuthState>? emit,
  }) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      Map<String, dynamic> userData = {
        'name': name,
        'phoneNumber': phoneNumber,
        'age': age,
        'gender': gender,
        'password': password,
      };

      await userDoc.set(userData);

      emit?.call(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit?.call(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: "Failed to upload user data",
      ));
    }
  }

  Future<void> onUploadUserDataRequested(
    UploadUserDataRequested event,
    Emitter<AuthState> emit,
  ) async {
    await uploadUserData(
        userId: event.userId,
        name: event.name,
        phoneNumber: '+962${event.phoneNumber}',
        age: event.age,
        gender: event.gender,
        emit: emit,
        password: event.password);
  }

  Future<void> _onAuthSignedIn(
    AuthSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    await sharedPreferences.setBool('is_signedin', true);
    emit(AuthSignedInState());
  }

  Future<void> _onAuthSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await sharedPreferences.setBool('is_signedin', false);
    emit(AuthSignedOutState());
  }

  Future<void> onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          //TODO: in here navigate pack and then show a success dialog for two seconds or something and then navigate to home page.
          emit(state.copyWith(status: AuthStatus.success));
        } else {
          emit(state.copyWith(
            status: AuthStatus.failure,
            errorMessage: "User does not exist in Firestore.",
          ));
        }
      } else {
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: "Authentication failed.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+962${event.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verifyPhoneNumber===========================');
// Todo: i think in here I need to navigate to home screen
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final user = userCredential.user;
          if (user != null) {
            emit(state.copyWith(
              status: AuthStatus.success,
              errorMessage: "Authentication failed.",
            ));
          } else {
            emit(state.copyWith(
              status: AuthStatus.failure,
              errorMessage: "Authentication failed.",
            ));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed===========================');

          emit(state.copyWith(
            status: AuthStatus.failure,
            errorMessage: e.message,
          ));
        },
        codeSent: (String verificationID, int? resendToken) async {
          emit(state.copyWith(verificationId: verificationID));

          //TODO: Code is being sent but I need to navigate to otp screen and verify it
          //TODO: user_id everywhere

          print(
              "$verificationID[---------------------------------------------------]");
          emit(state.copyWith(verificationId: verificationID));
          state.copyWith(verificationId: verificationID);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAutoRetrievalTimeout===========================');
          // Handle timeout scenario
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      // Start phone number verification
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final user = userCredential.user;

          if (user != null) {
            emit(state.copyWith(status: AuthStatus.success));
          } else {
            emit(state.copyWith(
              status: AuthStatus.failure,
              errorMessage: "Authentication failed.",
            ));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          emit(state.copyWith(
            status: AuthStatus.failure,
            errorMessage: e.message,
          ));
        },
        codeSent: (String verificationId, int? resendToken) async {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc('user_id')
              .get();

          if (userDoc.exists) {
            final storedPassword = userDoc.get('password');
            final storedPhoneNumber = userDoc.get('phoneNumber');

            if (storedPassword == event.password &&
                event.phoneNumber == storedPhoneNumber) {
              print(
                  '--------------------storedPass=$storedPassword && eventOne is ${event.password}');
              print(
                  '--------------------storedPhone=$storedPhoneNumber && eventOne is ${event.phoneNumber}');
              emit.isDone;

              emit(state.copyWith(status: AuthStatus.success));
              print(
                  '----------------------------------------${state.status}-----------------');
            } else if (event.phoneNumber == storedPhoneNumber &&
                storedPhoneNumber != event.password) {
              emit.isDone;
              emit(state.copyWith(
                status: AuthStatus.wrongPassword,
              ));
            }
          } else {
            emit(state.copyWith(
              status: AuthStatus.failure,
              errorMessage: "User does not exist in Firestore.",
            ));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void onSetPasswordVisibility(
      SetPasswordVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(showPassword: event.showPassword));
  }

  void onSetConfirmPasswordVisibility(
      SetConfirmPasswordVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(showConfirmPassword: event.showConfirmPassword));
  }

  void onTextChanged(TextChanged event, Emitter<AuthState> emit) {
    final phoneNumberRegex = RegExp(ValidationRegex.phoneNumberRegex);
    final signUpPhoneNumberRegex =
        RegExp(ValidationRegex.signUpPhoneNumberRegex);
    final passwordRegex = RegExp(ValidationRegex.passwordRegex);
    final isPhoneNumberValid = phoneNumberRegex.hasMatch(event.phoneNumber);
    final isSignUpPhoneNumberValid =
        signUpPhoneNumberRegex.hasMatch(event.signUpPhoneNumber ?? '');
    final isPasswordValid = passwordRegex.hasMatch(event.password);
    final isGenderValid = event.gender?.isNotEmpty;
    final isAgeValid = event.age?.isNotEmpty;
    final isFullNameValid = event.fullName?.isNotEmpty;
    final isConfirmPasswordValid = event.confirmPassword?.isNotEmpty;
    final isButtonEnabled = isPhoneNumberValid && isPasswordValid;
    final isSignUpButtonEnabled = isSignUpPhoneNumberValid &&
        isPasswordValid &&
        isConfirmPasswordValid! &&
        isGenderValid! &&
        isFullNameValid! &&
        isAgeValid!;

    emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        password: event.password,
        isPhoneNumberValid: isPhoneNumberValid,
        isPasswordValid: isPasswordValid,
        isGenderValid: isGenderValid,
        isAgeValid: isAgeValid,
        isFullNameValid: isFullNameValid,
        isSignUpPhoneNumberValid: isSignUpPhoneNumberValid,
        isConfirmPasswordValid: isConfirmPasswordValid,
        isButtonEnabled: isButtonEnabled,
        isSignUpButtonEnabled: isSignUpButtonEnabled));
  }

  void onAgeSelected(AgeSelected event, Emitter<AuthState> emit) {
    emit(state.copyWith(age: event.age));
  }
}
