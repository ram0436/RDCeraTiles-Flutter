import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/add_category_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddCategoryController addCategoryController =
        Get.put(AddCategoryController());
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
            title: 'Manage Category',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Add Category',
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
                    value: addCategoryController.selectedLocation.value,
                    items: addCategoryController.locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['id'].toString(),
                        child: Text(location['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addCategoryController.selectedLocation.value = value!;
                      addCategoryController.getParentCategory(
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
                    value: addCategoryController.selectedParentCategory.value,
                    items: addCategoryController.parentCategories
                        .map((parentCategory) {
                      return DropdownMenuItem<String>(
                        value: parentCategory['id'].toString(),
                        child: Text(parentCategory['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addCategoryController.selectedParentCategory.value =
                          value!;
                    },
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Enter Category Name',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Category Name',
                  hintText: 'Enter Category Name',
                  controller: addCategoryController.categoryNameController,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return addCategoryController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Add Category',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () {
                            addCategoryController.addCategory(
                              locationId: int.parse(addCategoryController
                                  .selectedLocation.value!),
                              parentCategoryId: int.parse(addCategoryController
                                  .selectedParentCategory.value!),
                              createdBy: userId,
                              createdOn: DateTime.now().toIso8601String(),
                              modifiedBy: userId,
                              modifiedOn: DateTime.now().toIso8601String(),
                              name: addCategoryController
                                  .categoryNameController.text,
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
