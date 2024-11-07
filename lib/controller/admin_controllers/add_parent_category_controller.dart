import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/controller/location_controller.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddParentCategoryController extends GetxController {
  RxBool isLoading = false.obs;
  var locations = [].obs;
  var selectedLocation = Rxn<String>(); // To store the selected location

  final LocationController locationController = Get.put(LocationController());
  final TextEditingController parentCategoryNameController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLocations(); // Fetch locations when the controller is initialized
  }

  Future<void> fetchLocations() async {
    await locationController.getAllLocationData();
    locations.value = locationController.locations;
    update(); // Notify listeners
  }

  addParentCategory({
    required int locationId,
    required int createdBy,
    required String createdOn,
    required int modifiedBy,
    required String modifiedOn,
    required String name,
  }) async {
    if (parentCategoryNameController.text.isEmpty) {
      showErrorSnackBar('Please enter the parent category name.');
      return;
    }
    isLoading.value = true;

    final parentCategoryData = {
      "createdBy": createdBy,
      "createdOn": createdOn,
      "modifiedBy": modifiedBy,
      "modifiedOn": modifiedOn,
      "id": 0,
      "locationId": locationId, // Pass the selected location ID
      "name": parentCategoryNameController.text,
    };
    try {
      ResponseItem result = await AddParentCategoryRepo.addParentCategoryRepo(
          parentCategoryData: parentCategoryData);
      if (result.status == true) {
        showSuccessSnackBar('Parent Category Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Failed to add parent category');
      }
    } catch (e) {
      log('ERROR while Adding Parent Category: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    parentCategoryNameController.clear();
    selectedLocation.value = null; // Clear the selected location
  }
}
