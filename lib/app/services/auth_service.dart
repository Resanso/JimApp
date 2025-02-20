import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String authBox = 'authBox';
  static const String userIdKey = 'userId';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(authBox);
  }

  static Future<void> saveLoginStatus(String userId) async {
    final box = Hive.box(authBox);
    await box.put(userIdKey, userId);
  }

  static Future<void> clearLoginStatus() async {
    final box = Hive.box(authBox);
    await box.delete(userIdKey);
  }

  static String? getUserId() {
    final box = Hive.box(authBox);
    return box.get(userIdKey);
  }

  static bool isLoggedIn() {
    return getUserId() != null;
  }
}
