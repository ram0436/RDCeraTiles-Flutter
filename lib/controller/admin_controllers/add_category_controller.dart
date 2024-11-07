import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/controller/location_controller.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddCategoryController extends GetxController {
  RxBool isLoading = false.obs;
  var locations = [].obs;
  var selectedLocation = Rxn<String>(); // For selected location
  var parentCategories = <Map<String, dynamic>>[].obs;
  var selectedParentCategory = Rxn<String>(); // For selected parent category

  final LocationController locationController = Get.put(LocationController());
  final TextEditingController categoryNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  // Fetch locations
  Future<void> fetchLocations() async {
    await locationController.getAllLocationData();
    locations.value = locationController.locations;
    update();
  }

  // Fetch parent categories based on selected location ID
  Future<void> getParentCategory(int locationId) async {
    ResponseItem result =
        await GetParentCategoryRepo.getParentCategoryRepo(id: locationId);
    try {
      if (result.status && result.data != null) {
        parentCategories.value =
            (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) 
    {
      log('Error fetching parent categories: $e');
    } finally {
      update();
    }
  }

  // Add category
  Future<void> addCategory({
    required int locationId,
    required int parentCategoryId,
    required int createdBy,
    required String createdOn,
    required int modifiedBy,
    required String modifiedOn,
    required String name,
  }) async {
    if (categoryNameController.text.isEmpty) {
      showErrorSnackBar('Please enter the category name.');
      return;
    }
    isLoading.value = true;

    final categoryData = {
      "createdBy": createdBy,
      "createdOn": createdOn,
      "modifiedBy": modifiedBy,
      "modifiedOn": modifiedOn,
      "id": 0,
      "locationId": locationId,
      "parentCategoryId": parentCategoryId,
      "name": name,
    };

    try {
      ResponseItem result =
          await AddCategoryRepo.addCategoryRepo(categoryData: categoryData);
      if (result.status == true) {
        showSuccessSnackBar('Category Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Failed to add category');
      }
    } catch (e) {
      log('ERROR while Adding Category: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear controllers and reset selections
  void clearControllers() {
    categoryNameController.clear();
    selectedLocation.value = null;
    selectedParentCategory.value = null;
  }
}
