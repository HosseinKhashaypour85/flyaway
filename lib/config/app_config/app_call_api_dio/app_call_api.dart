import 'package:dio/dio.dart';

class DioClient {
  // ✅ Singleton instance
  static final DioClient _instance = DioClient._internal();

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  factory DioClient() => _instance;

  late Dio _dio;

  Dio get dio => _dio;
}
