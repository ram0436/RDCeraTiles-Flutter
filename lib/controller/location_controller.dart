import 'dart:developer';

import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class LocationController extends GetxController {
  var locations = [].obs;
  var companyDetails = [].obs;
  var isLoading = false.obs;

  getAllLocationData() async {
    isLoading.value = true;

    try {
      ResponseItem result = await GetAllLocationData.getAllLocationData();
      isLoading.value = false;

      if (result.status && result.data != null) {
        locations.value = result.data;
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=======>>>>====>>>>$e');
      showBottomSnackBar('An error occurred while fetching data');
    } finally {
      isLoading.value = false; // Ensure loading state is reset
      update();
    }
  }
}
