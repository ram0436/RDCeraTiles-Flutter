import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class HomeController extends GetxController {
  var companyDetails = {}.obs;
  var isLoading = false.obs;

  getCompanyDetail() async {
    isLoading.value = true;
    ResponseItem result = await GetCompanyDetailRepo.getCompanyDetailRepo();
    try {
      if (result.status && result.data != null) {
        companyDetails.value = result.data;
        isLoading.value = false;
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=======>>>>====>>>>$e');
      showBottomSnackBar('An error occurred while fetching data');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
