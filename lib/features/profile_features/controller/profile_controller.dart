import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../services/profile_services.dart';

class ProfileController extends GetxController {
  final ProfileServices _profileServices = ProfileServices();

  RxBool isLoading = false.obs;
  var errorMessage = ''.obs;

  RxInt walletCount = 0.obs;

  Future<void> getWalletCount(String phone) async {
    isLoading.value = true;

    try {
      final response = await _profileServices.callGetWalletCountApi(phone);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        walletCount.value = response.data['wallet_count'] ?? 0;
      } else {
        errorMessage.value =
            response.data?["message"]?.toString() ?? "Request failed!";
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  Future<void> addAmountToWallet(String phone, int amount) async {
    isLoading.value = true;
    try {
      final response = await _profileServices.callAddAmountToWallet(
        phone,
        amount,
      );
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('add amount seccess');
      } else {
        errorMessage.value =
            response.data?["message"]?.toString() ?? "Request failed!";
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}
