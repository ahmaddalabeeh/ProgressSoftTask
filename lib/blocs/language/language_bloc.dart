import 'package:ahmad_progress_soft_task/blocs/language/language_event.dart';
import 'package:ahmad_progress_soft_task/blocs/language/language_state.dart';
import 'package:ahmad_progress_soft_task/language/model/language_model.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<ILanguageEvent, LanguageState> {
  final SharedPreferences _prefs;

  LanguageBloc(this._prefs) : super(_loadInitialState(_prefs)) {
    on<ChangeLanguage>(onChangeLanguage);
  }

  static LanguageState _loadInitialState(SharedPreferences prefs) {
    final languageCode = prefs.getString('language_code') ?? 'ar';
    final selectedLanguage = LanguageModel.values
        .firstWhere((lang) => lang.value.languageCode == languageCode);
    return LanguageState(selectedLanguage: selectedLanguage);
  }

  Future<void> onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    final selectedLanguage = event.selectedLanguage;
    emit(state.copyWith(selectedLanguage: selectedLanguage));
    await _prefs.setString(
        'language_code', selectedLanguage.value.languageCode);
  }
}
