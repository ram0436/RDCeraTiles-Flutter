import 'package:tiles_app/utils/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const isLogin = "isLogin";
  static const userData = "userData";
  static const userId = "userId";
  static const roleId = "roleId";
  static const isRegisteredUser = "isRegisteredUser";

  logOut() async {
    await _preferences?.clear();
    Get.offAllNamed(Routes.homeScreen);
  }

  Future<bool?> putString(String key, String value) async {
    await init(); // Ensure initialization before usage
    return _preferences?.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences?.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    await init(); // Ensure initialization before usage
    return _preferences?.setInt(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    return _preferences?.getInt(key) ?? defValue;
  }

  Future<bool?> putDouble(String key, double value) async {
    await init(); // Ensure initialization before usage
    return _preferences?.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    await init(); // Ensure initialization before usage
    return _preferences?.setBool(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preferences?.getBool(key) ?? defValue;
  }
}
