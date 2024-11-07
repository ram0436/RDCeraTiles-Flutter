import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/api/repo/product_repo.dart';
import 'package:tiles_app/controller/products_controllers/product_details_controller.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:tiles_app/utils/shared_prefs.dart';

class UpdateSalesPurchaseController extends GetxController {
  RxBool isLoading = false.obs;
  var products = <Map<String, dynamic>>[].obs;
  var productNames = <String>[].obs;
  var selectedProductId = 0.obs;
  var selectedProductName = ''.obs;
  final int userId = preferences.getInt(SharedPreference.userId);

  final TextEditingController boxCountController = TextEditingController();

  final TextEditingController productTextController = TextEditingController();

  final ProductDetailsController productDetailsController =
      Get.put(ProductDetailsController());

  // Variable to store product details and models
  var selectedProductDetails = <Map<String, dynamic>>[].obs;
  var selectedModelId = 0.obs;
  var models = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> commonModels = <Map<String, dynamic>>[].obs;

  // Fetch Product Models from API
  fetchProductModels() async {
    ResponseItem result =
        await GetAllProductModelsData.getAllProductModelsData();
    try {
      if (result.status && result.data != null) {
        models.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {}
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    }
    update();
  }

  /// Helper method to get common models between API and product details
  List<Map<String, dynamic>> getCommonModels(List<dynamic> productModels) {
    final productModelNames =
        productModels.map((productModel) => productModel['model']).toList();

    // Filter models by comparing with product model names
    final commonModels = models.where((model) {
      return productModelNames.contains(model['name']);
    }).toList();

    return commonModels;
  }

  // Fetch Product Details based on selectedProductId
  Future<void> fetchProductDetails(int id) async {
    await productDetailsController.getProductDetails(id);
    selectedProductDetails.value = productDetailsController.productDetails;

    if (selectedProductDetails.isNotEmpty) {
      final productModels = selectedProductDetails[0]['productModel'] as List;
      // Filter for common models
      commonModels.value = getCommonModels(productModels);
      print(commonModels);
    }
    update();
  }

  // Fetch all products
  getAllProducts() async {
    ResponseItem result = await GetAllProducts.getAllProducts();
    try {
      if (result.status && result.data != null) {
        products.value = (result.data as List).cast<Map<String, dynamic>>();
        productNames.value =
            products.map((product) => product['name'] as String).toList();
      } else {}
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {
      isLoading.value = false;
    }
    update();
  }

  void setSelectedProduct(String productName, {bool fromOnTheWayBox = true}) {
    final selectedProduct =
        products.firstWhere((product) => product['name'] == productName);
    if (selectedProduct != null) {
      selectedProductId.value = selectedProduct['id'] as int;
      selectedProductName.value = productName;
      final parentCategoryId = selectedProduct['parentCategoryId'] as int;

      if (selectedProductId.value != 0) {
        if (fromOnTheWayBox && parentCategoryId == 2) {
          fetchProductDetails(selectedProductId.value);
          fetchProductModels();
        } else {
          selectedModelId.value = 0;
          commonModels.clear();
        }
      }
    } else {
      selectedProductId.value = 0;
      selectedProductName.value = '';
    }
    // update(); // Not needed if using reactive observables
  }

  Future<void> updateSalesBoxCount() async {
    int boxCount = int.tryParse(boxCountController.text) ?? 0;

    if (selectedProductId.value == 0 || boxCount <= 0) {
      showErrorSnackBar('Please select a product and enter a valid box count.');
      return;
    }

    isLoading.value = true;
    try {
      ResponseItem result =
          await UpdateSalesBoxCountRepo.updateSalesBoxCountRepo(
              productId: selectedProductId.value,
              modelId: selectedModelId,
              newBoxCount: int.tryParse(boxCountController.text) ?? 0,
              modifiedBy: userId,
              modifiedOn: DateTime.now().toIso8601String());
      if (result.status) {
        showSuccessSnackBar('Sales Box Count Updated Successfully');
        clearControllers();
      } else {
        // Handle the error accordingly
      }
    } catch (e) {
      log('ERROR while Updating Sales Box Count: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePurchaseBoxCount() async {
    int boxCount = int.tryParse(boxCountController.text) ?? 0;

    if (selectedProductId.value == 0 || boxCount <= 0) {
      showErrorSnackBar('Please select a product and enter a valid box count.');
      return;
    }

    isLoading.value = true;
    try {
      ResponseItem result =
          await UpdatePurchaseBoxCountRepo.updatePurchaseBoxCountRepo(
              productId: selectedProductId.value,
              modelId: selectedModelId,
              newBoxCount: int.tryParse(boxCountController.text) ?? 0,
              modifiedBy: userId,
              modifiedOn: DateTime.now().toIso8601String());
      print(result.status);
      if (result.status) {
        showSuccessSnackBar('Purchase Box Count Updated Successfully');
        clearControllers();
      } else {}
    } catch (e) {
      log('ERROR while Updating Purchase Box Count: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOnTheWayBox() async {
    int boxCount = int.tryParse(boxCountController.text) ?? 0;

    if (selectedProductId.value == 0 || boxCount <= 0) {
      showErrorSnackBar('Please select a product and enter a valid box count.');
      return;
    }

    isLoading.value = true;
    try {
      ResponseItem result = await UpdateOnTheWayBoxRepo.updateOnTheWayBoxRepo(
          productId: selectedProductId.value,
          onTheWayBoxCount: int.tryParse(boxCountController.text) ?? 0,
          modifiedBy: userId,
          modifiedOn: DateTime.now().toIso8601String());
      if (result.status) {
        showSuccessSnackBar('On The Way Box Updated Successfully');
        clearControllers();
      } else {
        // Handle the error accordingly
      }
    } catch (e) {
      log('ERROR while Updating On The Way Box: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    boxCountController.clear();
    // selectedProductId.value = 0;
    // selectedModelId.value = 0;
    // selectedProductDetails.clear();
    // commonModels.clear();
    // selectedProductName.value = '';
    // productTextController.clear();
  }
}
