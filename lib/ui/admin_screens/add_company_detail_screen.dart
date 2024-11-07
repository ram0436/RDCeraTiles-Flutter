import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/add_brand_controller.dart';
import 'package:tiles_app/controller/admin_controllers/add_company_detail_screen.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class AddCompanyDetailScreen extends StatelessWidget {
  const AddCompanyDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddCompanyDetailController addCompanyDetailController =
        Get.put(AddCompanyDetailController());
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'Manage Company',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter Company Details',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter Company Name',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Company Name',
                  hintText: 'Enter Company Name',
                  controller: addCompanyDetailController.companyNameController,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter Logo URL',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Logo URL',
                  hintText: 'Enter Logo URL',
                  controller: addCompanyDetailController.logoUrlController,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter About Company',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'About Company',
                  hintText: 'Enter About Company',
                  controller: addCompanyDetailController.companyAboutController,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return addCompanyDetailController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Add Company',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () {
                            addCompanyDetailController.addCompanyDetail();
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
