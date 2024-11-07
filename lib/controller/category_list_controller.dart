import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/controller/home_controller.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class CategoryListController extends GetxController {
  var companyDetails = {}.obs;
  var parentCategories = <Map<String, dynamic>>[].obs;
  var categoryMap = <int, List<Map<String, dynamic>>>{}.obs;
  var isLoading = false.obs;
  var isCategoryLoading =
      <int, bool>{}.obs; // Track loading state for each category

  final HomeController homeController = Get.put(HomeController());

  Future<void> fetchCompanyDetails() async {
    await homeController.getCompanyDetail();
    companyDetails.value = homeController.companyDetails;
    update(); // Notify listeners
  }

  getParentCategory(int id) async {
    isLoading(true); // Start loading
    ResponseItem result =
        await GetParentCategoryRepo.getParentCategoryRepo(id: id);
    try {
      if (result.status && result.data != null) {
        parentCategories.value =
            (result.data as List).cast<Map<String, dynamic>>();
        for (var parentCategory in parentCategories) {
          isCategoryLoading[parentCategory['id']] =
              true; // Set category loading true
          await getCategory(parentCategory['id']);
          isCategoryLoading[parentCategory['id']] =
              false; // Set category loading false
        }
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {
      isLoading(false); // Stop loading
    }
    update();
  }

  getCategory(int parentId) async {
    ResponseItem result = await GetCategoryRepo.getCategoryRepo(id: parentId);
    try {
      if (result.status && result.data != null) {
        categoryMap[parentId] = List<Map<String, dynamic>>.from(result.data);
        update();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    }
  }
}
