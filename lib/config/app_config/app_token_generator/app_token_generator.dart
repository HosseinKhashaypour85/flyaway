import 'package:uuid/uuid.dart';

class AppTokenGenerator {
  var uuid = Uuid();

  String generateToken() {
    return uuid.v4();
  }
}