import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/controller/location_controller.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AddSubCategoryController extends GetxController {
  RxBool isLoading = false.obs;
  var locations = [].obs;
  var selectedLocation = Rxn<String>(); // For selected location
  var parentCategories = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var selectedParentCategory = Rxn<String>(); // For selected parent category
  var selectedCategory = Rxn<String>(); // For selected category

  final LocationController locationController = Get.put(LocationController());
  final TextEditingController subCategoryNameController =
      TextEditingController();

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
    } catch (e) {
      log('Error fetching parent categories: $e');
    } finally {
      update();
    }
  }

  getCategory(int parentId) async {
    ResponseItem result = await GetCategoryRepo.getCategoryRepo(id: parentId);
    try {
      if (result.status && result.data != null) {
        categories.value = List<Map<String, dynamic>>.from(result.data);
        update();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    }
  }

  // Add category
  Future<void> addSubCategory({
    required int locationId,
    required int parentCategoryId,
    required int categoryId,
    required int createdBy,
    required String createdOn,
    required int modifiedBy,
    required String modifiedOn,
    required String name,
  }) async {
    if (subCategoryNameController.text.isEmpty) {
      showErrorSnackBar('Please enter the sub category name.');
      return;
    }
    isLoading.value = true;

    final subCategoryData = {
      "createdBy": createdBy,
      "createdOn": createdOn,
      "modifiedBy": modifiedBy,
      "modifiedOn": modifiedOn,
      "id": 0,
      "locationId": locationId,
      "parentCategoryId": parentCategoryId,
      "categoryId": categoryId,
      "name": name,
    };

    try {
      ResponseItem result = await AddSubCategoryRepo.addSubCategoryRepo(
          subCategoryData: subCategoryData);
      if (result.status == true) {
        showSuccessSnackBar('Sub Category Added successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Failed to add sub category');
      }
    } catch (e) {
      log('ERROR while Adding Sub Category: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear controllers and reset selections
  void clearControllers() {
    subCategoryNameController.clear();
    selectedLocation.value = null;
    selectedParentCategory.value = null;
  }
}
