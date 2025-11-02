import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';
import 'package:flyaway/features/home_features/model/home_show_comments_model.dart';

class HomeShowCommentsApi {
  final Dio _dio = DioClient().dio;

  Future<HomeShowCommentsModel?> callHomeCommentsApi() async {
    try {
      final Response response = await _dio.get(AppUrlsConfig.allComments);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeShowCommentsModel.fromJson(response.data);
      } else {
        print('❌ خطا در پاسخ سرور: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('⚠️ خطا در ارتباط با سرور: $e');
      return null;
    }
  }
}
