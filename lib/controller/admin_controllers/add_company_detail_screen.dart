import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddCompanyDetailController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController logoUrlController = TextEditingController();
  final TextEditingController companyAboutController = TextEditingController();

  /// Create NEW User DATA API
  addCompanyDetail() async {
    isLoading.value = true;

    final companyDetails = {
      "name": companyNameController.text,
      "logoURL": logoUrlController.text,
      "about": companyAboutController.text,
    };

    try {
      ResponseItem result = await AddCompanyDetailRepo.addCompanyDetailRepo(
          companyDetails: companyDetails);

      if (result.status == true) {
        showSuccessSnackBar('Company Details Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Something went wrong, please try again');
      }
    } catch (e) {
      log('ERROR while Adding Company Details: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    companyNameController.clear();
    logoUrlController.clear();
    companyAboutController.clear();
  }
}
