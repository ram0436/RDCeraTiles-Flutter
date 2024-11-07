import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/product_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class ProductDetailsController extends GetxController {
  var productDetails = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // Single loading state

  // Track the loading state of each operation separately
  var _isProductDetailsLoading = false;

  // Method to handle the single loading state
  void _updateLoadingState() {
    isLoading(_isProductDetailsLoading);
  }

  // Fetch Product Details
  getProductDetails(int id) async {
    _isProductDetailsLoading = true;
    _updateLoadingState(); // Update the global loading state

    ResponseItem result =
        await GetProductDetailsRepo.getProductDetailsRepo(id: id);

    try {
      if (result.status && result.data != null) {
        productDetails.clear();
        productDetails.add(result.data);
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR in getProductDetails: $e');
    } finally {
      _isProductDetailsLoading = false;
      _updateLoadingState(); // Update the global loading state
    }

    update(); // Notify listeners
  }
}
