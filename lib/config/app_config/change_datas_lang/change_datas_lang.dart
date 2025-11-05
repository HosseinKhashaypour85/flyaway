import '../app_localization_config/en_US.dart';
import '../app_localization_config/fa_IR.dart';
import '../app_localization_config/language_service.dart';

class ChangeDatasLang {
  static final ChangeDatasLang _instance = ChangeDatasLang._internal();
  factory ChangeDatasLang() => _instance;
  ChangeDatasLang._internal();

  String tr(String key) {
    final langCode = LanguageService().currentLocale.languageCode;
    return langCode == 'fa' ? (faIR[key] ?? key) : (enUS[key] ?? key);
  }

  String trTicketType(String key) {
    return tr(key);
  }
}