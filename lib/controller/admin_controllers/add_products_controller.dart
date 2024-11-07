import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tiles_app/api/repo/master_repo.dart';
import 'package:tiles_app/api/repo/product_repo.dart';
import 'package:tiles_app/controller/category_list_controller.dart';
import 'package:tiles_app/controller/location_controller.dart';
import 'package:tiles_app/controller/products_controllers/products_controller.dart';
import 'package:tiles_app/model/product_model.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:tiles_app/utils/shared_prefs.dart';

class AddProductController extends GetxController {
  ImagePicker picker = ImagePicker();
  var addDataList = <File>[].obs;
  File? profileImage;
  RxList<ProductModel> productModels = <ProductModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isDataAssigned = false.obs;

  var locations = [].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var parentCategories = <Map<String, dynamic>>[].obs;
  var subCategories = <Map<String, dynamic>>[].obs;
  var brands = <Map<String, dynamic>>[].obs;
  var punchs = <Map<String, dynamic>>[].obs;
  var models = <Map<String, dynamic>>[].obs;
  var productDetails = <Map<String, dynamic>>[].obs;

  final ProductsController productsController = Get.put(ProductsController());
  final LocationController locationController = Get.put(LocationController());
  final CategoryListController categoryListController =
      Get.put(CategoryListController());

  RxString selectedLocation = ''.obs;
  RxString selectedParentCategory = ''.obs;
  RxString selectedCategory = ''.obs;
  RxString selectedSubCategory = ''.obs;
  RxString selectedBrand = ''.obs;
  RxString selectedPunch = ''.obs;

  bool isValidate = false;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController boxCountController = TextEditingController();
  TextEditingController seriesController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController coverageAreaController = TextEditingController();
  TextEditingController piecesPerBoxController = TextEditingController();
  TextEditingController thicknessController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  TextEditingController modelBoxCountController = TextEditingController();
  TextEditingController onWayBoxCountController = TextEditingController();

  fetchProductModels() async {
    ResponseItem result =
        await GetAllProductModelsData.getAllProductModelsData();
    try {
      if (result.status && result.data != null) {
        models.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    } finally {}
    update();
  }

  void addNewModel() {
    productModels
        .add(ProductModel(id: 0, model: '', boxCount: 0, productId: 0));
    update();
  }

  void removeModel(int index) {
    if (productModels.length > 1) {
      productModels.removeAt(index);
      update();
    }
  }

  void updateModel(int index, String model, int boxCount) {
    productModels[index].model = model;
    productModels[index].boxCount = boxCount;
    update();
  }

  void selectLocation(String locationId) async {
    selectedLocation.value = locationId; // Update the selected location
    await fetchParentCategories(
        int.parse(locationId)); // Fetch parent categories
  }

  void removePhoto(int index) {
    addDataList.removeAt(index);
    update();
  }

  Future getData() async {
    if (preferences
        .getString(SharedPreference.userData)
        .toString()
        .isNotEmpty) {}
  }

  void reorderImages(int newIndex, int oldIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final File image = addDataList.removeAt(oldIndex);
    addDataList.insert(newIndex, image);
    update();
  }

  Future<void> getImages(BuildContext context) async {
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        addDataList.add(File(file.path));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
    update();
  }

  /// PICK MULTI IMAGE
  // Future getImages(BuildContext context) async {
  //   final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //   List<XFile> xFilePick = pickedFile;
  //   if (xFilePick.isNotEmpty) {
  //     for (var i = 0; i < xFilePick.length; i++) {
  //       log('---xFilePick[i].path----${xFilePick[i].path}');
  //       addDataList.add(File(xFilePick[i].path));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
  //   }
  //   update();
  // }

  Future<void> pickImage() async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      profileImage = File(file.path);
      update();
    }
  }

  Future<void> fetchLocations() async {
    await locationController.getAllLocationData();
    locations.value = locationController.locations;
    log('Fetched Locations: ${locations}'); // Log fetched locations
    update(); // Notify listeners
  }

  Future<void> fetchParentCategories(int locationId) async {
    await categoryListController.getParentCategory(locationId);
    parentCategories.value = categoryListController
        .parentCategories; // Store fetched parent categories
    log('Parent Categories: ${parentCategories}');
    update(); // Notify listeners
  }

  Future<void> fetchSubCategories(int categoryId) async {
    await productsController.getSubCategory(categoryId);
    subCategories.value =
        productsController.subCategories; // Store fetched subcategories
    log('Subcategories: ${subCategories}');
  }

  Future<void> getCategory(int parentId) async {
    ResponseItem result = await GetCategoryRepo.getCategoryRepo(id: parentId);
    try {
      if (result.status && result.data != null) {
        categories.value = (result.data as List)
            .cast<Map<String, dynamic>>(); // Store categories
        update();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====selectedCategory==>>>>====>>>>$e');
    }
  }

  Future<void> getAllPunchs() async {
    ResponseItem result = await GetAllPunch.getAllPunch();
    try {
      if (result.status && result.data != null) {
        punchs.value =
            (result.data as List).cast<Map<String, dynamic>>(); // Store punchs
        update();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====getAllPunchs==>>>>====>>>>$e');
    }
  }

  Future<void> getAllBrands() async {
    ResponseItem result = await GetAllBrand.getAllBrand();
    try {
      if (result.status && result.data != null) {
        brands.value =
            (result.data as List).cast<Map<String, dynamic>>(); // Store brands
        update();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR=====getAllBrands==>>>>====>>>>$e');
    }
  }

  void selectParentCategory(int parentId) async {
    selectedParentCategory.value = '';
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    selectedParentCategory.value = parentId.toString();
    await getCategory(parentId);
  }

  void selectCategory(String categoryId) async {
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    selectedCategory.value = categoryId;
    await fetchSubCategories(int.parse(categoryId));
  }

  void selectSubCategory(String subCategoryId) {
    selectedSubCategory.value = '';
    selectedSubCategory.value = subCategoryId;
  }

  void selectBrand(String brandId) {
    selectedBrand.value = brandId;
  }

  void selectPunch(String punchId) {
    selectedPunch.value = punchId;
  }

  void updateBoxCount() {
    int totalBoxCount = productModels.fold(0, (sum, model) {
      return sum + (model.boxCount ?? 0);
    });

    boxCountController.text = totalBoxCount.toString();
  }

  getProductDetails(int id) async {
    ResponseItem result =
        await GetProductDetailsRepo.getProductDetailsRepo(id: id);

    try {
      if (result.status && result.data != null) {
        productDetails.clear();
        productDetails.add(result.data);

        // Access the models using the correct key
        if (productDetails[0].containsKey('productModel')) {
          var models = productDetails[0]['productModel'];
          // Make sure models is not null and is a List
          if (models is List && models.isNotEmpty) {
            assignModels(List<Map<String, dynamic>>.from(models));
          }
        }
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR in getProductDetails: $e');
    } finally {}

    update(); // Notify listeners
  }

  void assignModels(List<Map<String, dynamic>>? models) {
    if (models != null && models.isNotEmpty) {
      productModels.clear(); // Clear existing models if any

      for (var modelData in models) {
        productModels.add(ProductModel(
          id: modelData['id'],
          model: modelData['model'],
          boxCount: modelData['boxCount'],
          productId: modelData['productId'],
        ));
      }
    }

    print(productModels.toString());

    update(); // Notify listeners of the state change
  }

  // /// ASSIGN DATA

  void assignData(Map<String, dynamic>? productData) {
    isDataAssigned.value = true;
    // Assigning values to the text controllers
    productNameController.text = productData?['name'] ?? '';
    productCodeController.text = productData?['productCode'] ?? '';
    boxCountController.text = productData?['boxCount']?.toString() ?? '';
    seriesController.text = productData?['series'] ?? '';
    priceController.text = productData?['price']?.toString() ?? '';
    sizeController.text = productData?['size'] ?? '';
    weightController.text = productData?['weight'] ?? '';
    onWayBoxCountController.text =
        productData?['boxCountOnTheWay']?.toString() ?? '';
    coverageAreaController.text =
        productData?['coverageArea']?.toString() ?? '';
    piecesPerBoxController.text =
        productData?['piecesPerBox']?.toString() ?? '';
    thicknessController.text = productData?['thickness']?.toString() ?? '';

    // Assign data to the dropdown selections based on product details
    selectedLocation.value = productData?['locationId']?.toString() ?? '';
    selectLocation(selectedLocation.value);
    selectedParentCategory.value =
        productData?['parentCategoryId']?.toString() ?? '';
    selectParentCategory(productData?['parentCategoryId']);
    selectedCategory.value = productData?['categoryId']?.toString() ?? '';
    selectCategory(selectedCategory.value);
    selectedSubCategory.value = productData?['subCategoryId']?.toString() ?? '';
    selectSubCategory(selectedSubCategory.value);
    selectedBrand.value = productData?['brandId']?.toString() ?? '';
    selectedPunch.value = productData?['punchId']?.toString() ?? '';

    // Assuming productModel is a list, you can assign the first model or handle it accordingly
    if (productData?['productModel'] != null &&
        productData?['productModel'].isNotEmpty) {
      modelNameController.text = productData?['productModel'][0]['model'] ?? '';
      modelBoxCountController.text =
          productData?['productModel'][0]['boxCount']?.toString() ?? '';
    } else {
      modelNameController.text = '';
      modelBoxCountController.text = '';
    }

    // Convert raw product image data to ProductImageList instances
    List<ProductImageList> formattedProductImageList =
        (productData?['productImageList'] as List<dynamic>?)
                ?.map((image) => ProductImageList.fromJson(image))
                .toList() ??
            [];

    // Save the product images
    saveImage(productImageList: formattedProductImageList);
    isDataAssigned.value = false;

    // Notify listeners of the state change
    update();
  }

  /// UPLOAD IMAGE API
  List imageUrl = [];

  uploadImages({required List<File> requestData}) async {
    isLoading.value = true;
    ResponseItem result;
    result = await UploadImageRepo.uploadImagesRepo(requestData: requestData);
    try {
      if (result.status) {
        if (result.data != null) {
          isLoading.value = false;
          imageUrl = result.data;
          update();
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      log('ERROR====AddGadgetData===>>>>====>>>>$e');
      isLoading.value = false;
    }
    update();
  }

  saveImage({required List<ProductImageList>? productImageList}) async {
    productImageList?.forEach((element) async {
      final http.Response response =
          await http.get(Uri.parse(element.imageUrl ?? ''));
      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/${element.imageUrl?.split('/').last}';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
      log('---xFilePick[i].path----${file.path}');

      addDataList.add(file);
    });

    // Notify the UI that the addDataList has changed
    update(); // This should notify the UI to rebuild
  }

  /// ADD NEW Product DATA API
  addProductData({required Map<String, dynamic> productData}) async {
    isLoading.value = true;
    ResponseItem result;
    result = await AddProductRepo.addProductRepo(productData: productData);
    try {
      if (result.status == true) {
        showSuccessSnackBar('Publish Successfully');
        isLoading.value = false;
        clearData();
        update();
      } else {
        isLoading.value = false;
        showSuccessSnackBar('Something Went Wrong,Please Try Again');
      }
    } catch (e) {
      log('ERROR====AddGadgetData===>>>>====>>>>$e');
      isLoading.value = false;
    }
    update();
  }

  /// UPDATE Product
  updateProductData(
      {required Map<String, dynamic> productData, required String id}) async {
    isLoading.value = true;
    ResponseItem result;
    result = await UpdateProductData.updateProductData(
        productData: productData, id: id);
    try {
      if (result.status == true) {
        showSuccessSnackBar('Product Updated Successfully');
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        showErrorSnackBar('Something Went Wrong,Please Try Again');
      }
    } catch (e) {
      log('ERROR====updateGadgetData===>>>>====>>>>$e');
      isLoading.value = false;
    }
    update();
  }

  void clearData() {
    selectedLocation.value = '';
    selectedParentCategory.value = '';
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    selectedBrand.value = '';
    selectedPunch.value = '';

    productNameController.clear();
    productCodeController.clear();
    boxCountController.clear();
    seriesController.clear();
    priceController.clear();
    sizeController.clear();
    weightController.clear();
    coverageAreaController.clear();
    piecesPerBoxController.clear();
    thicknessController.clear();

    addDataList.clear(); // Clear the image list

    update(); // Notify listeners about the changes
  }
}
