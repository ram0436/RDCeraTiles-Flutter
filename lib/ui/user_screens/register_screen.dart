import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/user_controllers/register_controller.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController = Get.put(RegisterController());
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'Register',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please register to continue',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'First Name',
                  hintText: 'Enter First Name',
                  controller: registerController.firstNameController,
                ),
                CustomTextField(
                  labelText: 'Last Name',
                  hintText: 'Enter Last Name',
                  controller: registerController.lastNameController,
                ),
                CustomTextField(
                  labelText: 'User ID',
                  hintText: 'Enter User ID',
                  controller: registerController.userIdController,
                ),
                CustomTextField(
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  controller: registerController.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                ),
                CustomTextField(
                  labelText: 'Mobile',
                  hintText: 'Enter Mobile Number',
                  controller: registerController.mobileController,
                ),
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'Enter Email',
                  controller: registerController.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  labelText: 'Address',
                  hintText: 'Enter Address',
                  controller: registerController.addressController,
                ),
                CustomTextField(
                  labelText: 'Pincode',
                  hintText: 'Enter Pincode',
                  controller: registerController.pincodeController,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  labelText: 'City',
                  hintText: 'Enter City',
                  controller: registerController.cityController,
                ),
                CustomTextField(
                  labelText: 'State',
                  hintText: 'Enter State',
                  controller: registerController.stateController,
                ),
                CustomTextField(
                  labelText: 'GST No',
                  hintText: 'Enter GST No',
                  controller: registerController.gstNoController,
                ),
                CustomTextField(
                  labelText: 'PAN',
                  hintText: 'Enter PAN',
                  controller: registerController.panController,
                ),
                CustomTextField(
                  labelText: 'Website',
                  hintText: 'Enter Website',
                  controller: registerController.websiteController,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return registerController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Register',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () async {
                            // Check for required fields
                            if (registerController
                                .firstNameController.text.isEmpty) {
                              showErrorSnackBar('Please enter First Name');
                            } else if (registerController
                                .lastNameController.text.isEmpty) {
                              showErrorSnackBar('Please enter Last Name');
                            } else if (registerController
                                .userIdController.text.isEmpty) {
                              showErrorSnackBar('Please enter User ID');
                            } else if (registerController
                                .passwordController.text.isEmpty) {
                              showErrorSnackBar('Please enter Password');
                            } else if (registerController
                                .mobileController.text.isEmpty) {
                              showErrorSnackBar('Please enter Mobile Number');
                            } else {
                              await registerController.createUser();
                            }
                          },
                        );
                }),

                // const SizedBox(height: 40),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.toNamed('/loginScreen');
                //     },
                //     child: const Text(
                //       "Already have an account? Sign In",
                //       style: TextStyle(
                //         fontFamily: 'Montserrat',
                //         fontSize: 14,
                //         color: appColor,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
