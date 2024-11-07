import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/user_controllers/create_order_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/app_loading_widget.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderController createOrderController =
      Get.put(CreateOrderController());
  int? productId;
  int? userId;
  int? parentId;

  @override
  void initState() {
    super.initState();
    // Retrieve arguments
    final arguments = Get.arguments;
    productId = arguments['productId'];
    parentId = arguments['parentId'];
    userId = preferences.getInt(SharedPreference.userId);
    createOrderController.fetchProductModels();

    // Call fetchProductDetails with productId
    if (productId != null) {
      createOrderController.fetchProductDetails(productId!);
    }
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
            title: 'Create Order',
          ),
          body: Obx(() {
            // Show loading indicator while data is being fetched
            if (createOrderController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            // Get the product details from the controller
            final product = createOrderController.productDetails.value;

            if (product.isEmpty) {
              return const Center(child: Text('No product details available'));
            }

            final productDetails = product[0];
            final commonModels = createOrderController
                .getCommonModels(productDetails['productModel']);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w * 0.040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product details UI
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product[0]['productImageList'][0]['imageURL'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            Text(
                              productDetails['name'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Show models and boxes if parentId is 2
                            if (parentId == 2)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  productDetails['productModel'].length,
                                  (index) {
                                    final model =
                                        productDetails['productModel'][index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Model: ${model['model']}, Boxes: ${model['boxCount']}',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              Text(
                                'Boxes: ${productDetails['boxCount']}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                ),
                              ),
                            const SizedBox(height: 5),
                            // Text(
                            //   'Weight: ${productDetails['weight']}',
                            //   style: const TextStyle(
                            //     fontFamily: 'Montserrat',
                            //     fontSize: 14,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // Product Thickness
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appColor, // Use your app color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${productDetails['thickness']}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (productDetails['productModel'] != null &&
                      productDetails['productModel'].isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Select Model',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown(
                      hintText: 'Select a model',
                      labelText: 'Model',
                      value: commonModels.any((model) =>
                              model['id'] ==
                              createOrderController.selectedModelId.value)
                          ? createOrderController.selectedModelId.value
                              .toString()
                          : null, // Only pass a value that exists in commonModels
                      items: commonModels.map((model) {
                        return DropdownMenuItem<String>(
                          value: model['id'].toString(),
                          child: Text(model['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        createOrderController.selectedModelId.value =
                            value != null ? int.tryParse(value) ?? 0 : 0;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a model';
                        }
                        return null; // Return null if valid
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Select number of boxes to proceed.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  CustomTextField(
                    labelText: 'No of Boxes',
                    hintText: 'Enter number of boxes',
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Only allow digits (0-9)
                    ],
                    controller: createOrderController.noOfBoxesController,
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    return createOrderController.isButtonLoading.value
                        ? Padding(
                            padding: EdgeInsets.only(bottom: h * 0.02),
                            child: const Center(child: AppLoadingWidget()),
                          )
                        : AppFilledButton(
                            title: 'Place Order',
                            buttonColor: appColor,
                            textColor: whiteColor,
                            fontSize: 16,
                            onPressed: () {
                              createOrderController.createOrder(
                                context: context,
                                productId: productId ?? 0,
                                createdBy: userId ?? 0,
                                createdOn: DateTime.now().toIso8601String(),
                                modifiedBy: userId ?? 0,
                                modifiedOn: DateTime.now().toIso8601String(),
                                modelId: parentId == 2
                                    ? createOrderController
                                        .selectedModelId.value
                                    : 6,
                              );
                            },
                          );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
