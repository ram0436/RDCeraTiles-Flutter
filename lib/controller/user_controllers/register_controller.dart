import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/user_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController gstNoController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  /// Create NEW User DATA API
  createUser() async {
    isLoading.value = true;

    final userData = {
      "createdBy": 0,
      "createdOn": DateTime.now().toIso8601String(),
      "modifiedBy": 0,
      "modifiedOn": DateTime.now().toIso8601String(),
      "userId": userIdController.text,
      "userRoleId": 0,
      "password": passwordController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "mobile": mobileController.text,
      "email": emailController.text,
      "address": addressController.text,
      "pincode": pincodeController.text,
      "city": cityController.text,
      "state": stateController.text,
      "gstNo": gstNoController.text,
      "pan": panController.text,
      "website": websiteController.text,
    };

    try {
      ResponseItem result =
          await CreateUserRepo.createUserRepo(userData: userData);

      if (result.status == true) {
        showSuccessSnackBar('User registered successfully');
        clearControllers();
      } else {
        showErrorSnackBar('Something went wrong, please try again');
      }
    } catch (e) {
      log('ERROR during user registration: $e');
      showErrorSnackBar('An error occurred, please try again');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    userIdController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    mobileController.clear();
    emailController.clear();
    addressController.clear();
    pincodeController.clear();
    cityController.clear();
    stateController.clear();
    gstNoController.clear();
    panController.clear();
    websiteController.clear();
  }
}
