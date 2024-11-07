import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/add_sub_category_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class AddSubCategoryScreen extends StatelessWidget {
  const AddSubCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddSubCategoryController addSubCategoryController =
        Get.put(AddSubCategoryController());
    final int userId = preferences.getInt(SharedPreference.userId);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'Manage Sub Category',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Add Sub Category',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Location',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return CustomDropdown(
                    hintText: 'Select Location',
                    labelText: 'Location',
                    value: addSubCategoryController.selectedLocation.value,
                    items: addSubCategoryController.locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['id'].toString(),
                        child: Text(location['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addSubCategoryController.selectedLocation.value = value!;
                      addSubCategoryController.getParentCategory(
                          int.parse(value)); // Fetch parent categories
                    },
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Select Parent Category',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return CustomDropdown(
                    hintText: 'Select Parent Category',
                    labelText: 'Parent Category',
                    value:
                        addSubCategoryController.selectedParentCategory.value,
                    items: addSubCategoryController.parentCategories
                        .map((parentCategory) {
                      return DropdownMenuItem<String>(
                        value: parentCategory['id'].toString(),
                        child: Text(parentCategory['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addSubCategoryController.selectedParentCategory.value =
                          value!;
                      addSubCategoryController.getCategory(int.parse(value)); //
                    },
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return CustomDropdown(
                    hintText: 'Select  Category',
                    labelText: 'Category',
                    value: addSubCategoryController.selectedCategory.value,
                    items: addSubCategoryController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addSubCategoryController.selectedCategory.value = value!;
                    },
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Enter Sub Category Name',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Sub Category Name',
                  hintText: 'Enter Category Name',
                  controller:
                      addSubCategoryController.subCategoryNameController,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return addSubCategoryController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Add Sub Category',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () {
                            addSubCategoryController.addSubCategory(
                              locationId: int.parse(addSubCategoryController
                                  .selectedLocation.value!),
                              parentCategoryId: int.parse(
                                  addSubCategoryController
                                      .selectedParentCategory.value!),
                              categoryId: int.parse(addSubCategoryController
                                  .selectedCategory.value!),
                              createdBy: userId,
                              createdOn: DateTime.now().toIso8601String(),
                              modifiedBy: userId,
                              modifiedOn: DateTime.now().toIso8601String(),
                              name: addSubCategoryController
                                  .subCategoryNameController.text,
                            );
                          },
                        );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
