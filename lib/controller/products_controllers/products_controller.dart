import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/api/repo/product_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class ProductsController extends GetxController {
  var subCategories = <Map<String, dynamic>>[].obs;
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // Single loading state
  var storedCategoryId;

  // Track the loading state of each operation separately
  var _isSubCategoryLoading = false;
  var _isProductsLoading = false;

  // Method to handle the single loading state
  void _updateLoadingState() {
    // If either of the operations is still loading, keep the loading indicator active
    isLoading(_isSubCategoryLoading || _isProductsLoading);
  }

  // Fetch subcategories
  getSubCategory(int id) async {
    _isSubCategoryLoading = true; // Start subcategory loading
    _updateLoadingState(); // Update the global loading state

    ResponseItem result = await GetSubCategoryRepo.getSubCategoryRepo(id: id);
    try {
      if (result.status && result.data != null) {
        subCategories.value =
            (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {
      _isSubCategoryLoading = false; // Stop subcategory loading
      _updateLoadingState(); // Update the global loading state
    }
    update();
  }

  // Fetch all products
  getAllProducts(int categoryId) async {
    _isProductsLoading = true; // Start product loading
    _updateLoadingState(); // Update the global loading state
    storedCategoryId = categoryId;

    ResponseItem result =
        await GetAllProductByCategoryId.getAllProductByCategoryId(
            categoryId: categoryId);
    try {
      if (result.status && result.data != null) {
        products.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {
      _isProductsLoading = false; // Stop product loading
      _updateLoadingState(); // Update the global loading state
    }
    update();
  }

  // Fetch all products
  getProductsBySubCategoryId(int subCategoryId) async {
    _isProductsLoading = true;
    _updateLoadingState();

    ResponseItem result =
        await GetProductBySubcategoryRepo.getProductBySubcategoryRepo(
            subCategoryId: subCategoryId);
    try {
      if (result.status && result.data != null) {
        products.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {
      _isProductsLoading = false;
      _updateLoadingState();
    }
    update();
  }

  // Fetch all products
  deleteProduct(int id) async {
    ResponseItem result = await DeleteProductRepo.deleteProductRepo(id: id);
    try {
      if (result.status) {
        getAllProducts(storedCategoryId);
        showSuccessSnackBar('Product Deleted successfully');
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====DeleteProduct==>>>>====>>>>$e');
    } finally {}
    update();
  }
}
