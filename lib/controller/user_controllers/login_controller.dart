import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/api_firebase.dart';
import 'package:tiles_app/api/repo/auth_repo.dart';
import 'package:tiles_app/model/post_login_response_model.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:tiles_app/utils/shared_prefs.dart';

class LoginController extends GetxController {
  // Loading state
  var isLoading = false.obs;

  /// Post Login controller
  UserLoginResponseModel? postLoginResponseModel;
  final FirebaseApi _firebaseApi = FirebaseApi();

  Future<bool> postLogin({
    required String userId,
    required String password,
  }) async {
    isLoading.value = true;
    ResponseItem result;
    result = await AuthLogin.authLoginRepo(
      userId: userId,
      password: password,
    );

    try {
      if (result.status) {
        if (result.data != null) {
          postLoginResponseModel = UserLoginResponseModel.fromJson(result.data);

          String jsonData = jsonEncode(result.data);
          await preferences.putString(SharedPreference.userData, jsonData);
          preferences.putInt(
              SharedPreference.userId, postLoginResponseModel?.id ?? 0);

          preferences.putBool(SharedPreference.isLogin, true);
          _firebaseApi.initNotifications();

          showSuccessSnackBar('Login Successfully');

          return true;
        }
      } else {
        showSuccessSnackBar('Please Enter Valid Credentials!');
        return false; // Return false for failed login
      }
    } catch (e) {
      log('Error during login: $e');
      return false; // Return false in case of an error
    } finally {
      isLoading.value = false;
      update();
    }

    return false; // Default return false if not already handled
  }
}
