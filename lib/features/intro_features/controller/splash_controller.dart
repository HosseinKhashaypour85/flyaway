import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/check_ip_services.dart';

class SplashController extends GetxController {
  final CheckIpServices _checkIp = CheckIpServices();
  late LocalStorage localStorage;

  Future<void>initialLocalStorage()async{
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorage(prefs);
  }

  @override
  void onInit() {
    super.onInit();
    initApp();
    initialLocalStorage();
  }

  Future<void> initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    await _checkIp.callCheckIp();
    final getToken = localStorage.get('token');
    if(getToken == null){
      Get.offAllNamed('/auth');
    } else{
      Get.offAllNamed('/home');
    }
  }
}