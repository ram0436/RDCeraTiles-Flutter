import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/constant/app_string.dart';
import 'package:tiles_app/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        cursorColor: blackColor,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        style: textFieldTextStyleBlack,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            bottom: 10,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          hintText: hintText,
          hintStyle: textFieldTextStyleGrey,
          prefixIcon: const Icon(CupertinoIcons.search),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  static Widget formTextField({
    final String? hintText,
    final TextEditingController? controller,
    final int? maxLines,
    final int? maxLength,
    final Widget? suffixIcon,
    final Widget? labelText,
    final TextInputType? textInputType,
    final bool readOnly = false,
    final FormFieldValidator? validator,
    final TextStyle? hintStyle,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: validator,
      maxLength: maxLength,
      onChanged: onChanged,
      controller: controller,
      cursorColor: blackColor,
      readOnly: readOnly,
      keyboardType: textInputType ?? TextInputType.text,
      textInputAction: TextInputAction.done,
      style: textFieldTextStyleBlack,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        filled: true,
        label: labelText,
        fillColor: Colors.grey.shade100,
        hintText: hintText,
        hintStyle: hintStyle ?? textFieldTextStyleForm,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLength;
  final TextInputType? textInputType;
  final FormFieldValidator? validator;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcons;

  const CommonTextField(
      {super.key,
      required this.controller,
      this.maxLength,
      this.textInputType,
      this.validator,
      required this.hintText,
      this.suffixIcon,
      this.prefixIcons});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.start,
      maxLength: maxLength,
      keyboardType: textInputType,
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.none,
      ),
      validator: validator,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: prefixIcons ?? const Text(""),

        //prefixIcon: prefixIcons ?? const SizedBox(),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

///Dropdown TextField
class DropDownTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  final String hintText;
  final String labelText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onFieldSubmitted;

  const DropDownTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.suffixIcon,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.onFieldSubmitted,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.none,
      ),
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onFieldSubmitted,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
        suffixIcon: suffixIcon,
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

///Description Text Field
class DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  const DescriptionTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.suffixIcon,
      required this.labelText,
      this.maxLines,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return TextFormField(
      validator: validator,
      keyboardType: TextInputType.text,
      controller: controller,
      cursorColor: blackColor,
      maxLines: maxLines,
      style: textFieldTextStyleBlack,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.035,
        ),
        label: labelText.semiBoldMontserratTextStyle(),
        hintText: hintText,
        hintStyle: textFieldTextStyleForm,
        enabled: true,
        suffixIcon: Padding(
          padding: EdgeInsets.only(bottom: h * 0.12),
          child: suffixIcon,
        ),
      ),
    );
  }
}

class AutoCorrectField extends StatelessWidget {
  const AutoCorrectField(
      {super.key,
      required this.optionList,
      required this.label,
      this.onSelected,
      this.initialValue,
      this.onChanged,
      this.suffixIcon});

  final List<String> optionList;
  final String label;
  final Function(String)? onSelected;
  final TextEditingValue? initialValue;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: initialValue,
      optionsBuilder: (TextEditingValue textEditingValue) {
        return optionList.where(
          (String option) {
            return option
                .toUpperCase()
                .contains(textEditingValue.text.toUpperCase());
          },
        );
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return DropDownTextField(
          onChanged: onChanged,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          controller: textEditingController,
          hintText: "Search Product",
          labelText: label,
          suffixIcon: suffixIcon ??
              IconButton(
                  onPressed: () {
                    textEditingController.clear();
                  },
                  icon: const Icon(Icons.arrow_drop_down)),
        );
      },
      onSelected: onSelected,
    );
  }
}
