import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/utils/extension.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double h;
  final double w;
  final String title;
  final Widget? action;
  final Widget? backIcon;
  // final String? addPostText; // New parameter for the navigation text

  const CommonAppBar({
    super.key,
    required this.h,
    required this.w,
    required this.title,
    this.action,
    this.backIcon,
    // this.addPostText, // Include the new parameter
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(h * 0.075),
      child: Container(
        height: h * 0.075,
        color: appColor,
        child: Padding(
          padding: EdgeInsets.only(right: w * 0.035),
          child: Row(
            mainAxisAlignment: action != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              backIcon ??
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.014),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
              title
                  .toString()
                  .boldMontserratTextStyle(fontColor: whiteColor, fontSize: 16),
              // if (addPostText != null) // Check if addPostText is provided
              //   GestureDetector(
              //     onTap: () {
              //       Get.toNamed('/addProductScreen');
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.only(left: w * 0.085),
              //       child: Text(
              //         addPostText!,
              //         style: const TextStyle(
              //           color: secondaryAppColor,
              //           fontFamily: "Montserrat",
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // action != null ? action! : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(h * 0.075);
}
