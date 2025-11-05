import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:flyaway/features/trip_features/model/trips_history_model.dart';
import 'package:flyaway/features/trip_features/services/trip_api_services.dart';
import 'package:get/get.dart';

class TripsController extends GetxController {
  final TripApiServices tripApiServices = TripApiServices();
  LocalStorage? localStorage;
  var getAllTrips = Rxn<TripsHistoryModel>();



  Future<TripsHistoryModel?> loadAllTrips(String email) async {
    getAllTrips.value = await tripApiServices.callTripsHistoryApi(email);
    return getAllTrips.value;
  }
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    localStorage = await LocalStorage.getInstance();
    final email = await localStorage!.get('email');
    loadAllTrips(email);
  }
}
