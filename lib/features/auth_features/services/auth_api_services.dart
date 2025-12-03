import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';

class AuthApiServices {
  final Dio _dio = DioClient().dio;

  Future<Response> callAuthApiServices(
    String firstName,
    String lastName,
    String phone,
  ) async {
    try {
      final response = await _dio.post(
        AppUrlsConfig.sendOtp,
        data: {'mobile': phone, 'token': AppUrlsConfig.farazApiKeyToken},
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

  Future<Response> callConfirmOtp(String phone, String code) async {
    try {
      final Response response = await _dio.post(
        AppUrlsConfig.confirmOtp,
        data: {'mobile': phone, 'otp': code},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print('success OTP');
      }
      return response;
    } on DioException catch (e) {
      print('❌ Dio Error: $e');
      rethrow;
    }
  }
}
