import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddLocationController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController locationNameController = TextEditingController();

  /// Create NEW User DATA API
  addLocation() async {
    isLoading.value = true;

    final locationData = {
      "name": locationNameController.text,
    };

    try {
      ResponseItem result =
          await AddLocationRepo.addLocationRepo(locationData: locationData);

      if (result.status == true) {
        showSuccessSnackBar('Location Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Something went wrong, please try again');
      }
    } catch (e) {
      log('ERROR while Adding Location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    locationNameController.clear();
  }
}
