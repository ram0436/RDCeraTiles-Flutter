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

class UpdateSaleScreen extends StatefulWidget {
  const UpdateSaleScreen({Key? key}) : super(key: key);

  @override
  _UpdateSaleScreenState createState() => _UpdateSaleScreenState();
}

class _UpdateSaleScreenState extends State<UpdateSaleScreen> {
  final UpdateSalesPurchaseController updateSalesPurchaseController =
      Get.put(UpdateSalesPurchaseController());

  @override
  void initState() {
    super.initState();
    updateSalesPurchaseController.getAllProducts();
    updateSalesPurchaseController.fetchProductModels();
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
            title: 'Sales Stock',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Sales Stock',
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
                      updateSalesPurchaseController
                          .setSelectedProduct(selectedName);
                    },
                    // Bind the text field to the selected product name
                    initialValue: TextEditingValue(
                        text: updateSalesPurchaseController
                            .selectedProductName.value),
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  if (updateSalesPurchaseController.commonModels.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Model',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDropdown(
                          hintText: "Select a Model",
                          labelText: "Select A Model",
                          value: updateSalesPurchaseController
                                      .selectedModelId.value !=
                                  0
                              ? updateSalesPurchaseController.commonModels
                                      .firstWhere(
                                          (model) =>
                                              model['id'] ==
                                              updateSalesPurchaseController
                                                  .selectedModelId.value,
                                          orElse: () => {'name': null})['name']
                                  as String?
                              : null,
                          items: updateSalesPurchaseController.commonModels
                              .map((model) => DropdownMenuItem<String>(
                                    value: model['name'],
                                    child: Text(model['name']),
                                  ))
                              .toList(),
                          onChanged: (modelName) {
                            final selectedModel = updateSalesPurchaseController
                                .commonModels
                                .firstWhere(
                                    (model) => model['name'] == modelName);
                            updateSalesPurchaseController
                                .selectedModelId.value = selectedModel['id'];
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return Container();
                }),
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
                            updateSalesPurchaseController.updateSalesBoxCount();
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
