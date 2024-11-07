import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/update_sales_purchase_controller.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_button.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_text_fields.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';

class UpdateOnTheWayBoxesScreen extends StatefulWidget {
  const UpdateOnTheWayBoxesScreen({Key? key}) : super(key: key);

  @override
  _UpdateOnTheWayBoxesScreenState createState() =>
      _UpdateOnTheWayBoxesScreenState();
}

class _UpdateOnTheWayBoxesScreenState extends State<UpdateOnTheWayBoxesScreen> {
  final UpdateSalesPurchaseController updateSalesPurchaseController =
      Get.put(UpdateSalesPurchaseController());

  @override
  void initState() {
    super.initState();
    updateSalesPurchaseController.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'On The Way Boxes',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Update On The Way Boxes',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Product',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  return AutoCorrectField(
                    optionList: updateSalesPurchaseController.productNames,
                    label: 'Search A Product',
                    // suffixIcon: const SizedBox(),
                    onSelected: (selectedName) {
                      updateSalesPurchaseController.setSelectedProduct(
                          selectedName,
                          fromOnTheWayBox: false);
                    },
                    // Bind the text field to the selected product name
                    initialValue: TextEditingValue(
                        text: updateSalesPurchaseController
                            .selectedProductName.value),
                  );
                }),
                const SizedBox(height: 16),
                const Text(
                  'Enter Box Count',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                CustomTextField(
                  labelText: 'Box Count',
                  hintText: 'Enter Box Count',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: updateSalesPurchaseController.boxCountController,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return updateSalesPurchaseController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: const Center(child: AppLoadingWidget()),
                        )
                      : AppFilledButton(
                          title: 'Update',
                          buttonColor: appColor,
                          textColor: whiteColor,
                          fontSize: 16,
                          onPressed: () {
                            updateSalesPurchaseController.updateOnTheWayBox();
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
