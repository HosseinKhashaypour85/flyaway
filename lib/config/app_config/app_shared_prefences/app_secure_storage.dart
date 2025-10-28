
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences preferences;
  LocalStorage(this.preferences);

  dynamic get(String key){
    final value = preferences.get(key);
    if(value is int || value is bool || value is double || value is String){
      return value;
    }
    return null;
  }

  Future<bool>set(String key , dynamic value)async{
    if(value is bool){
      return await preferences.setBool(key, value);
    }
    if(value is int){
      return await preferences.setInt(key, value);
    }
    if(value is double){
      return await preferences.setDouble(key, value);
    }
    if(value is String){
      return await preferences.setString(key, value);
    }
    return Future.value(false);
  }
  Future<void>clear()async{
    await preferences.clear();
  }
}