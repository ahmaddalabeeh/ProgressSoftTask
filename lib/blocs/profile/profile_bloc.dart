import 'package:ahmad_progress_soft_task/screens/profile/my_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore firestore;

  ProfileBloc(this.firestore) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLogoutUser(
      LogoutUser event, Emitter<ProfileState> emit) async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(ProfileInitial()); // Reset the state after logout
    } catch (e) {
      emit(ProfileError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc('user_id').get();

      if (snapshot.exists) {
        final user = UserModel.fromFirestore(snapshot.data()!);
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
