import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';

class ProfileServices {
  final Dio _dio = DioClient().dio;
  LocalStorage? localStorage;

  //   get users wallet count
  Future<Response> callGetWalletCountApi(String phone) async {
    try {
      localStorage = await LocalStorage.getInstance();
      final getPhoneNumber = localStorage!.get('phone');
      final Response response = await _dio.get(
        AppUrlsConfig.getWalletCount,
        data: {'phone': getPhoneNumber},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('sucess response for wallet');
      }
      return response;
    } on DioException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Response> callAddAmountToWallet(String phone, int amount) async {
    try {
      localStorage = await LocalStorage.getInstance();
      final getPhoneNumber = localStorage!.get('phone');
      final Response response = await _dio.post(
        AppUrlsConfig.addAmountToWallet,
        data: {'phone': getPhoneNumber, 'amount': amount},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('add success from profile services');
      }
      return response;
    } on DioException catch (e) {
      print(e);
      throw e;
    }
  }
}
