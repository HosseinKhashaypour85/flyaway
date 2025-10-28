import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';

class AuthApiServices {
  final Dio _dio = DioClient().dio;

  Future<Response> callAuthApiServices(
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      final response = await _dio.post(
        AppUrlsConfig.createUser,
        data: {"first_name": firstName, "last_name": lastName, "email": email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Success API for response');
      }
      return response;
    } on DioException catch (e) {
      print('❌ Dio Error: $e');
      rethrow;
    }
  }
}
