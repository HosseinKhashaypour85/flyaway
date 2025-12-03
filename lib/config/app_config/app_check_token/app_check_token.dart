import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:get/get.dart';

class AppCheckToken {

  Future<void> checkToken() async {
    final localStorage = await LocalStorage.getInstance();
    final getToken = await localStorage.get('token');

    if (getToken == null || getToken.isEmpty) {
      Get.offAllNamed('/auth');
    } else {
      Get.offAllNamed('/bottomNav');
    }
  }
}
