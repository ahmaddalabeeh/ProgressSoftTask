import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final String userId;

  LoadUserProfile(this.userId);

  @override
  List<Object> get props => [userId];
}

class LogoutUser extends ProfileEvent {}
