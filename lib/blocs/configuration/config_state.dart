abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final String countryCode;

  ConfigLoaded({required this.countryCode});
}

class ConfigError extends ConfigState {
  final String message;

  ConfigError({required this.message});
}
