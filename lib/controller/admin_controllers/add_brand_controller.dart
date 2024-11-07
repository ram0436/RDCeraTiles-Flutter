import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddBrandController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController brandNameController = TextEditingController();

  /// Create NEW User DATA API
  addBrand() async {
    isLoading.value = true;

    final brandData = {
      "name": brandNameController.text,
    };

    try {
      ResponseItem result =
          await AddBrandRepo.addBrandRepo(brandData: brandData);

      if (result.status == true) {
        showSuccessSnackBar('Brand Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Something went wrong, please try again');
      }
    } catch (e) {
      log('ERROR while Adding Brand: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }
  

  void clearControllers() {
    brandNameController.clear();
  }
}
