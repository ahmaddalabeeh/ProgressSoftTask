import 'package:ahmad_progress_soft_task/language/model/language_model.dart';
import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  const LanguageState({
    LanguageModel? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? LanguageModel.arabic;

  final LanguageModel selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];

  LanguageState copyWith({LanguageModel? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
