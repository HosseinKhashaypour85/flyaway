import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_localization_config/language_service.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';

class CheckIpServices {
  final Dio _dio = Dio();

  Future<void> callCheckIp() async {
    try {
      final Response response = await _dio.get(AppUrlsConfig.checkIp);
      bool isIranian = response.data['isIranian'] == true;
      if (isIranian) {
        await LanguageService().setLanguage('fa');
      } else {
        await LanguageService().setLanguage('en');
      }
    } on DioException catch (e) {
      print("Location check failed: $e");
      await LanguageService().setLanguage('fa');
    }
  }
}
