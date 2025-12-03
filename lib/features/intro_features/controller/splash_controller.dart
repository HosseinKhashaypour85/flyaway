import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/app_config/app_check_token/app_check_token.dart';
import '../services/check_ip_services.dart';

class SplashController extends GetxController {
  final CheckIpServices _checkIp = CheckIpServices();
  AppCheckToken appCheckToken = AppCheckToken();

  Future<void> initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    await _checkIp.callCheckIp();
    await appCheckToken.checkToken();
  }
}
