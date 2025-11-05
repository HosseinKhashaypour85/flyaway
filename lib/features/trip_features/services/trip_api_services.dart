import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';
import 'package:flyaway/features/trip_features/model/trips_history_model.dart';

class TripApiServices {
  final Dio dio = DioClient().dio;

  // get all trips
  Future<TripsHistoryModel?> callTripsHistoryApi(String email) async {
    try {
      final Response response = await dio.get(
        AppUrlsConfig.getAllTrips,
        queryParameters: {"email": email},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TripsHistoryModel.fromJson(response.data);
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
