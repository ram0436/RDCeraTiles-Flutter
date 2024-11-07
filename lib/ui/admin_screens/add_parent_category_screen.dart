import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/add_parent_category_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class AddParentCategoryScreen extends StatelessWidget {
  const AddParentCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddParentCategoryController addParentCategoryController =
        Get.put(AddParentCategoryController());
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
            title: 'Manage Parent Category',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Add Parent Category',
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
                    value: addParentCategoryController.selectedLocation
                        .value, // Bind to the controller's selected location
                    items:
                        addParentCategoryController.locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['id'].toString(),
                        child: Text(location['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addParentCategoryController.selectedLocation.value =
                          value!;
                    },
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Enter Parent Category Name',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Parent Category Name',
                  hintText: 'Enter Parent Category Name',
                  controller:
                      addParentCategoryController.parentCategoryNameController,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return addParentCategoryController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Add Parent Category',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () {
                            addParentCategoryController.addParentCategory(
                              locationId: int.parse(addParentCategoryController
                                  .selectedLocation.value!),
                              createdBy: userId, // Pass actual values as needed
                              createdOn: DateTime.now().toIso8601String(),
                              modifiedBy: userId,
                              modifiedOn: DateTime.now().toIso8601String(),
                              name: addParentCategoryController
                                  .parentCategoryNameController.text,
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
