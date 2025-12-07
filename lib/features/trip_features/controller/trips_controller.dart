import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/app_config/app_shared_prefences/app_secure_storage.dart';
import '../model/trips_history_model.dart';
import '../services/trip_api_services.dart';

class TripsController extends GetxController {
  final TripApiServices tripApiServices = TripApiServices();
  LocalStorage? localStorage;

  /// مدل نهایی
  var trips = Rxn<TripsHistoryModel>();

  Future<void> loadAllTrips(String phone) async {
    final response = await tripApiServices.callTripsHistoryApi(phone);

    if (response != null && response.statusCode == 200) {
      trips.value = TripsHistoryModel.fromJson(response.data);
    } else {
      print("⚠️ دریافت لیست سفرها با مشکل مواجه شد");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    localStorage = await LocalStorage.getInstance();

    final phone = await localStorage!.get('phone');  // ← درست شد
    if (phone != null) {
      loadAllTrips(phone);
    }
  }
}
