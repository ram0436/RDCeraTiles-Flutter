import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/constant/app_string.dart';
import 'package:tiles_app/controller/admin_controllers/add_products_controller.dart';
import 'package:tiles_app/model/post_login_response_model.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:tiles_app/utils/extension.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_button.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AddProductController addProductController =
      Get.put(AddProductController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String isFrom = '';
  int productId = 0;
  Map<String, dynamic> productDetails = {};
  UserLoginResponseModel? userLoginResponseModel;

  Future getData() async {
    if (preferences
        .getString(SharedPreference.userData)
        .toString()
        .isNotEmpty) {
      userLoginResponseModel = UserLoginResponseModel.fromJson(json
          .decode(preferences.getString(SharedPreference.userData).toString()));
    }
  }

  @override
  void initState() {
    super.initState();
    isFrom = Get.arguments['isFrom'];
    if (isFrom == 'editScreen') {
      productId = Get.arguments['productId'];
      productDetails = Get.arguments['productDetails'];
      addProductController.assignData(productDetails);
      addProductController.getProductDetails(productId);
      getData();
    }

    addProductController.fetchLocations();
    addProductController.getAllBrands();
    addProductController.getAllPunchs();
    addProductController.fetchProductModels();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: CommonAppBar(h: h, w: w, title: AppString.postProduct),
          body: GetBuilder<AddProductController>(
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.040),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Enter Product Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Locations Dropdown
                        Obx(() {
                          return CustomDropdown(
                            hintText: 'Select Location',
                            labelText: 'Location',
                            value: addProductController
                                    .selectedLocation.value.isNotEmpty
                                ? addProductController.selectedLocation.value
                                : null,
                            items:
                                addProductController.locations.map((location) {
                              return DropdownMenuItem<String>(
                                value: location['id'].toString(),
                                child: Text(location['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                addProductController.selectLocation(value);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a location';
                              }
                              return null;
                            },
                          );
                        }),

                        const SizedBox(height: 20),

                        // Parent Categories Dropdown
                        Obx(() {
                          return CustomDropdown(
                            hintText: 'Select Parent Category',
                            labelText: 'Parent Category',
                            value: addProductController
                                    .selectedParentCategory.value.isNotEmpty
                                ? addProductController
                                    .selectedParentCategory.value
                                : null,
                            items: addProductController.parentCategories
                                .map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'].toString(),
                                child: Text(category['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                addProductController
                                    .selectParentCategory(int.parse(value));
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a parent category';
                              }
                              return null;
                            },
                          );
                        }),

                        const SizedBox(height: 20),

                        Obx(() {
                          if (addProductController.selectedParentCategory.value
                                  .trim() ==
                              '2') {
                            if (addProductController.productModels.isEmpty) {
                              return Column(
                                children: [
                                  AppFilledButton(
                                    onPressed: () {
                                      addProductController.addNewModel();
                                    },
                                    child: const Text("Add Model"),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                ...List.generate(
                                  addProductController.productModels.length,
                                  (index) => Column(
                                    children: [
                                      CustomDropdown(
                                        hintText: "Select a model",
                                        labelText: "Model Name",
                                        value: addProductController.models.any(
                                          (model) =>
                                              model['name'] ==
                                              addProductController
                                                  .productModels[index].model,
                                        )
                                            ? addProductController
                                                .productModels[index].model
                                            : null,
                                        items: addProductController.models
                                            .map((model) =>
                                                DropdownMenuItem<String>(
                                                  value:
                                                      model['name'].toString(),
                                                  child: Text(model['name']),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            final selectedModel =
                                                addProductController.models
                                                    .firstWhere(
                                              (model) =>
                                                  model['name'].toString() ==
                                                  value,
                                            );

                                            if (selectedModel != null) {
                                              addProductController.updateModel(
                                                index,
                                                selectedModel['name'],
                                                addProductController
                                                    .productModels[index]
                                                    .boxCount,
                                              );
                                            }
                                          }
                                        },
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? 'Model is required'
                                                : null,
                                      ),
                                      CustomTextField(
                                        labelText: "Box Count",
                                        hintText: "Enter box count",
                                        controller: addProductController
                                            .productModels[index]
                                            .boxCountController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Only allow digits (0-9)
                                        ],
                                        onChanged: (value) {
                                          addProductController.updateModel(
                                            index,
                                            addProductController
                                                .productModels[index].model,
                                            int.tryParse(value) ?? 0,
                                          );
                                          addProductController.updateBoxCount();
                                        },
                                        validator: (value) => value!.isEmpty
                                            ? 'Box Count is required'
                                            : null,
                                      ),
                                      const SizedBox(height: 20),
                                      AppFilledButton(
                                        onPressed: () {
                                          addProductController.addNewModel();
                                        },
                                        child: const Text("Add More Model"),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),

                        // Categories Dropdown
                        Obx(
                          () => CustomDropdown(
                            hintText: 'Select Category',
                            labelText: 'Category',
                            value: addProductController
                                    .selectedCategory.value.isNotEmpty
                                ? addProductController.selectedCategory.value
                                : null,
                            items:
                                addProductController.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'].toString(),
                                child: Text(category['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                addProductController.selectCategory(value);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Subcategories Dropdown
                        Obx(
                          () => CustomDropdown(
                            hintText: 'Select Subcategory',
                            labelText: 'Subcategory',
                            value: addProductController
                                    .selectedSubCategory.value.isNotEmpty
                                ? addProductController.selectedSubCategory.value
                                : null,
                            items: addProductController.subCategories
                                .map((subcategory) {
                              return DropdownMenuItem<String>(
                                value: subcategory['id'].toString(),
                                child: Text(subcategory['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                addProductController.selectSubCategory(value);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a subcategory';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Brands Dropdown
                        Obx(() => CustomDropdown(
                              hintText: 'Select Brand',
                              labelText: 'Brand',
                              value: addProductController
                                      .selectedBrand.value.isNotEmpty
                                  ? addProductController.selectedBrand.value
                                  : null,
                              items: addProductController.brands.map((brand) {
                                return DropdownMenuItem<String>(
                                  value: brand['id'].toString(),
                                  child: Text(brand['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  addProductController.selectBrand(value);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a brand';
                                }
                                return null;
                              },
                            )),

                        const SizedBox(height: 20),

                        // Punches Dropdown
                        Obx(() => CustomDropdown(
                              hintText: 'Select Punch',
                              labelText: 'Punch',
                              value: addProductController
                                      .selectedPunch.value.isNotEmpty
                                  ? addProductController.selectedPunch.value
                                  : null,
                              items: addProductController.punchs.map((punch) {
                                return DropdownMenuItem<String>(
                                  value: punch['id'].toString(),
                                  child: Text(punch['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  addProductController.selectPunch(value);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a punch';
                                }
                                return null;
                              },
                            )),

                        // Text Field for Product Name
                        CustomTextField(
                          labelText: "Product Name",
                          hintText: "Enter product name",
                          controller: controller.productNameController,
                          validator: (value) => value!.isEmpty
                              ? 'Product Name is required'
                              : null,
                        ),
                        // Text Field for Product Code
                        // CustomTextField(
                        //   labelText: "Product Code",
                        //   hintText: "Enter product code",
                        //   controller: controller.productCodeController,
                        //   validator: (value) => value!.isEmpty
                        //       ? 'Product Code is required'
                        //       : null,
                        // ),
                        // Text Field for Box Count
                        CustomTextField(
                          labelText: "Box Count",
                          hintText: "Enter box count",
                          controller: controller.boxCountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly, // Only allow digits (0-9)
                          ],
                          validator: (value) =>
                              value!.isEmpty ? 'Box Count is required' : null,
                        ),
                        // Text Field for Series
                        // CustomTextField(
                        //   labelText: "Series",
                        //   hintText: "Enter series",
                        //   controller: controller.seriesController,
                        //   validator: (value) =>
                        //       value!.isEmpty ? 'Series is required' : null,
                        // ),
                        // Text Field for Price
                        // CustomTextField(
                        //   labelText: "Price",
                        //   hintText: "Enter price",
                        //   controller: controller.priceController,
                        //   inputFormatters: <TextInputFormatter>[
                        //     FilteringTextInputFormatter
                        //         .digitsOnly, // Only allow digits (0-9)
                        //   ],
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) =>
                        //       value!.isEmpty ? 'Price is required' : null,
                        // ),
                        // Text Field for Weight
                        CustomTextField(
                          labelText: "Weight",
                          hintText: "Enter weight",
                          controller: controller.weightController,
                          validator: (value) =>
                              value!.isEmpty ? 'Weight is required' : null,
                        ),
                        // Text Field for Coverage Area
                        CustomTextField(
                          labelText: "Coverage Area",
                          hintText: "Enter coverage area",
                          controller: controller.coverageAreaController,
                          validator: (value) => value!.isEmpty
                              ? 'Coverage Area is required'
                              : null,
                        ),
                        // Text Field for Pieces Per Box
                        CustomTextField(
                          labelText: "Pieces Per Box",
                          hintText: "Enter pieces per box",
                          controller: controller.piecesPerBoxController,
                          validator: (value) => value!.isEmpty
                              ? 'Pieces Per Box is required'
                              : null,
                        ),
                        // Text Field for Thickness
                        CustomTextField(
                          labelText: "Thickness",
                          hintText: "Enter thickness",
                          controller: controller.thicknessController,
                          validator: (value) =>
                              value!.isEmpty ? 'Thickness is required' : null,
                        ),

                        if (isFrom == 'editScreen') ...[
                          CustomTextField(
                            labelText: "On The Way Boxes",
                            hintText: "Enter On The Way Boxes",
                            controller: controller.onWayBoxCountController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'On The Way Boxes is required';
                              }
                              return null; // If valid, return null
                            },
                          ),
                        ],

                        const SizedBox(height: 20),

                        AppString.uploadPhotoText
                            .toString()
                            .semiBoldMontserratTextStyle(
                                fontColor: blackColor, fontSize: 18),
                        (h * 0.02).addHSpace(),
                        Obx(
                          () => ReorderableGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: controller.addDataList.length +
                                1, // +1 for the add button
                            itemBuilder: (BuildContext context, int index) {
                              if (index == controller.addDataList.length) {
                                return GestureDetector(
                                  key: const ValueKey('add_button'),
                                  onTap: () {
                                    if (controller.addDataList.length <= 9) {
                                      controller.getImages(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: AppString.maximumphotoText
                                              .w500MontserratTextStyle(
                                                  fontColor: whiteColor),
                                        ),
                                      );
                                    }
                                  },
                                  child: controller.addDataList.length == 10
                                      ? const SizedBox()
                                      : Container(
                                          height: h * 0.1,
                                          width: h * 0.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(color: appColor),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt_outlined,
                                                color: appColor,
                                                size: 28,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.008),
                                                child: AppString.addPhotoText
                                                    .semiBoldMontserratTextStyle(
                                                  fontColor: appColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                );
                              } else {
                                return GridTile(
                                  key: ValueKey(controller.addDataList[index]),
                                  child: Container(
                                    height: h * 0.14,
                                    width: h * 0.14,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: greyColor, width: 0.7),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            controller.addDataList[index]),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.removePhoto(index);
                                              },
                                              child: Container(
                                                height: h * 0.030,
                                                width: h * 0.030,
                                                decoration: BoxDecoration(
                                                  color: redColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: whiteColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        index == 0
                                            ? Container(
                                                height: h * 0.033,
                                                decoration: const BoxDecoration(
                                                  color: blueAccentColor,
                                                ),
                                                child: Center(
                                                  child: AppString
                                                      .coverPhotoText
                                                      .semiBoldMontserratTextStyle(
                                                    fontColor: whiteColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              controller.reorderImages(newIndex, oldIndex);
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: controller.isLoading.value
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: h * 0.02),
                                  child:
                                      const Center(child: AppLoadingWidget()),
                                )
                              : AppFilledButton(
                                  onPressed: () async {
                                    controller.isValidate = false;

                                    if (controller
                                        .productNameController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterProductName);
                                      // } else if (controller
                                      //     .productCodeController.text.isEmpty) {
                                      //   showErrorSnackBar(
                                      //       AppString.enterProductCode);
                                      // } else if (controller
                                      //     .priceController.text.isEmpty) {
                                      //   showErrorSnackBar(
                                      //       AppString.enterProductPrice);
                                      // } else if (controller.addDataList.isEmpty) {
                                      //   showErrorSnackBar(
                                      //       AppString.selectImageText);
                                    } else if (controller
                                        .boxCountController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterBoxCount);
                                      // } else if (controller
                                      //     .seriesController.text.isEmpty) {
                                      //   showErrorSnackBar(
                                      //       AppString.enterProductSeries);
                                    } else if (controller
                                        .weightController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterProductWeight);
                                    } else if (controller
                                        .piecesPerBoxController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterPiecesPerBox);
                                    } else if (controller
                                        .coverageAreaController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterCoverageArea);
                                    } else if (controller
                                        .thicknessController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterProductThickness);
                                    } else if (controller
                                        .weightController.text.isEmpty) {
                                      showErrorSnackBar(
                                          AppString.enterProductWeight);
                                    } else {
                                      List<Map<String, dynamic>>
                                          productImageList = [];
                                      await controller.uploadImages(
                                          requestData: controller.addDataList);

                                      if (controller.imageUrl.isNotEmpty) {
                                        for (var element
                                            in controller.imageUrl) {
                                          productImageList.addAll({
                                            {
                                              "id": 0,
                                              "imageURL": element,
                                              "productId": 0
                                            }
                                          });
                                        }
                                      }

                                      Map<String, dynamic> productData = {
                                        "createdBy": preferences
                                            .getInt(SharedPreference.userId),
                                        "createdOn": DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss'Z'")
                                            .format(DateTime.now()),
                                        "modifiedBy": preferences
                                            .getInt(SharedPreference.userId),
                                        "modifiedOn": DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss'Z'")
                                            .format(DateTime.now()),
                                        "id": isFrom == 'editScreen'
                                            ? productId
                                            : 0,
                                        "productCode": controller
                                                .productCodeController
                                                .text
                                                .isNotEmpty
                                            ? controller
                                                .productCodeController.text
                                            : '',
                                        "locationId": int.parse(
                                            controller.selectedLocation.value),
                                        "parentCategoryId": int.parse(controller
                                            .selectedParentCategory.value),
                                        "categoryId": int.parse(
                                            controller.selectedCategory.value),
                                        "subCategoryId": int.parse(controller
                                            .selectedSubCategory.value),
                                        "name": controller
                                            .productNameController.text,
                                        "boxCount": controller
                                                .boxCountController.text.isEmpty
                                            ? 0
                                            : int.parse(controller
                                                .boxCountController.text),
                                        "series": controller.seriesController
                                                .text.isNotEmpty
                                            ? controller.seriesController.text
                                            : '',
                                        "price": controller
                                                .priceController.text.isEmpty
                                            ? 0
                                            : int.tryParse(controller
                                                    .priceController.text) ??
                                                0,
                                        "brandId": int.parse(
                                            controller.selectedBrand.value),
                                        "size": "",
                                        "weight":
                                            controller.weightController.text,
                                        "punchId": int.parse(
                                            controller.selectedPunch.value),
                                        "coverageArea": controller
                                            .coverageAreaController.text,
                                        "piecesPerBox": controller
                                            .piecesPerBoxController.text,
                                        "boxCountOnTheWay": controller
                                                .onWayBoxCountController
                                                .text
                                                .isEmpty
                                            ? 0
                                            : int.tryParse(controller
                                                    .onWayBoxCountController
                                                    .text) ??
                                                0,
                                        "thickness":
                                            controller.thicknessController.text,
                                        "productImageList": productImageList,
                                        "productModel": controller.productModels
                                            .map((model) => model.toJson())
                                            .toList(),
                                      };

                                      if (isFrom == 'editScreen') {
                                        controller.updateProductData(
                                            productData: productData,
                                            id: productDetails["id"]
                                                .toString());
                                        log('UPDATE DATA');
                                      } else {
                                        await controller.addProductData(
                                            productData: productData);
                                      }
                                    }
                                  },
                                  title: isFrom == 'editScreen'
                                      ? AppString.updateProductText
                                      : AppString.addProductText,
                                  textColor: whiteColor,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
