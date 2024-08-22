import 'package:ahmad_progress_soft_task/language/model/language_model.dart';
import 'package:equatable/equatable.dart';

abstract class ILanguageEvent extends Equatable {
  const ILanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends ILanguageEvent {
  final LanguageModel selectedLanguage;

  const ChangeLanguage({
    required this.selectedLanguage,
  });

  @override
  List<Object> get props => [selectedLanguage];
}
