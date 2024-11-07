import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/user_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class UserProfileController extends GetxController {
  var userProfile = {}.obs;
  var isLoading = false.obs;

  var _isuserProfileLoading = false;

  void _updateLoadingState() {
    isLoading(_isuserProfileLoading);
  }

  getUserProfile(int id) async {
    _isuserProfileLoading = true;
    _updateLoadingState();

    ResponseItem result = await GetUserProfileRepo.getUserProfileRepo(id: id);
    try {
      if (result.status && result.data != null) {
        userProfile.value = result.data;
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR in getUserProfile: $e');
    } finally {
      _isuserProfileLoading = false;
      _updateLoadingState();
    }

    update();
  }
}
