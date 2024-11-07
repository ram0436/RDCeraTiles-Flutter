import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showAppSnackBar(
  String tittle,
) {
  return Get.showSnackbar(GetSnackBar(
      messageText: Text(
        // "Email or password is wrong",
        tittle,
        style: const TextStyle(color: Colors.white),
      ),
      borderRadius: 0,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shouldIconPulse: false,
      icon: Container(
        height: 25,
        width: 25,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Center(
          child: Icon(
            Icons.close_rounded,
            color: blackColor,
          ),
        ),
      ),
      backgroundColor: blackColor,
      duration: const Duration(seconds: 3)));
}

showBottomSnackBar(String tittle) {
  return Get.showSnackbar(GetSnackBar(
    // message: tittle,
    messageText: tittle.semiBoldMontserratTextStyle(fontColor: whiteColor),
    borderRadius: 15,

    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shouldIconPulse: false,
    icon: const Icon(
      Icons.error_outline,
      color: Colors.white,
    ),
    backgroundColor: blackColor,
    duration: const Duration(seconds: 3),
  ));
}

showErrorSnackBar(String tittle) {
  return Get.showSnackbar(GetSnackBar(
    // message: tittle,
    messageText: tittle.semiBoldMontserratTextStyle(fontColor: whiteColor),
    borderRadius: 15,

    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shouldIconPulse: false,
    icon: const Icon(
      Icons.error_outline,
      color: Colors.white,
    ),
    backgroundColor: redColor,
    duration: const Duration(seconds: 3),
  ));
}

showSuccessSnackBar(String tittle) {
  return Get.showSnackbar(
    GetSnackBar(
      // message: tittle,
      messageText: tittle.semiBoldMontserratTextStyle(fontColor: whiteColor),
      borderRadius: 15,

      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shouldIconPulse: false,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      backgroundColor: appColor,
      duration: const Duration(seconds: 3),
    ),
  );
}
