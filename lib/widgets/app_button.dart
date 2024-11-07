import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFilledButton extends StatelessWidget {
  final Color? buttonColor;
  final double? radius;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? title;
  final Color? textColor;
  final Color? borderColor;
  final Function() onPressed;
  final Widget? child;
  const AppFilledButton({
    super.key,
    this.buttonColor,
    this.radius,
    this.width,
    this.title,
    this.textColor,
    required this.onPressed,
    this.borderColor,
    this.height,
    this.fontSize,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(buttonColor ?? appColor),
        fixedSize:
            MaterialStatePropertyAll(Size(width ?? w, height ?? h * 0.062)),
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 4),
            side: BorderSide(color: borderColor ?? appColor),
          ),
        ),
      ),
      child: child ??
          title!
              .semiBoldMontserratTextStyle(
                  fontColor: textColor ?? appColor, fontSize: fontSize ?? 20)
              .paddingOnly(top: 3),
    );
  }
}
