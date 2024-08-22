import 'package:ahmad_progress_soft_task/blocs/configuration/config_event.dart';
import 'package:ahmad_progress_soft_task/blocs/configuration/config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigInitial()) {
    on<FetchCountryCode>((event, emit) async {
      emit(ConfigLoading());

      try {
        final String countryCode = await _fetchCountryCode();

        emit(ConfigLoaded(countryCode: countryCode));
      } catch (e) {
        emit(ConfigError(message: e.toString()));
      }
    });
  }

  Future<String> _fetchCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? countryCode = prefs.getString('country_code');

    if (countryCode != null) {
      return countryCode;
    } else {
      throw Exception('Country code not found in system configuration');
    }
  }
}
