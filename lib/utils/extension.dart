import 'package:tiles_app/constant/app_color.dart';
import 'package:flutter/material.dart';

extension SizedExtension on double {
  addHSpace() {
    return SizedBox(height: this);
  }

  addWSpace() {
    return SizedBox(width: this);
  }
}

extension AppDivider on double {
  Widget appDivider({Color? color}) {
    return Divider(
      thickness: this,
      color: color ?? Colors.white,
    );
  }
}

hideKeyBoard(BuildContext context) {
  return FocusScope.of(context).unfocus();
}

extension MontserratTextStyle on String {
  Widget regularMontserratTextStyle({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    int? maxLine,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 16,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget w500MontserratTextStyle({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    int? maxLine,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 16,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget semiBoldMontserratTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      TextOverflow? textOverflow,
      int? maxLine,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 16,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget boldMontserratTextStyle(
      {Color? fontColor,
      double? fontSize,
      TextDecoration? textDecoration,
      int? maxLine,
      TextOverflow? textOverflow,
      TextAlign? textAlign}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        color: fontColor ?? Colors.black,
        fontSize: fontSize ?? 16,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w800,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}

const TextStyle textFieldTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Barlow');

const TextStyle textFieldTextStyleGrey = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    fontFamily: 'Barlow');

const TextStyle textFieldTextStyleBlack = TextStyle(
    fontSize: 16,
    color: blackColor,
    fontWeight: FontWeight.w500,
    fontFamily: 'Barlow');

const TextStyle textFieldTextStyleForm = TextStyle(
  color: Colors.grey,
  fontSize: 17,
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.none,
);
