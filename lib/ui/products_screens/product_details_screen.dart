import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/products_controllers/product_details_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_button.dart';
import 'package:tiles_app/widgets/app_container.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsController productDetailsController =
      Get.put(ProductDetailsController());
  int productId = 0;
  int _selectedIndex = 0;
  int parentId = 0;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['id'] ?? 0;
    parentId = Get.arguments['parentId'] ?? 0;
    userId = preferences.getInt(SharedPreference.userId);
    productDetailsController.getProductDetails(productId);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'Product Details',
          ),
          body: Obx(() {
            final productDetails = productDetailsController.productDetails;
            if (productDetails.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = productDetails[0];

            return SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    child: Container(
                      height: 300,
                      child: PageView.builder(
                        itemCount: product['productImageList'].length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showFullScreenImage(
                                      context,
                                      product['productImageList'][index]
                                          ['imageURL']);
                                },
                                child: Image.network(
                                  product['productImageList'][index]
                                      ['imageURL'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(
                                        4), // Rounded corners
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.zoom_in,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      _showFullScreenImage(
                                          context,
                                          product['productImageList'][index]
                                              ['imageURL']);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                          // return Image.network(
                          //   product['productImageList'][index]['imageURL'],
                          //   fit: BoxFit.cover,
                          // );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      product['productImageList'].length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 20,
                        height: 5,
                        color: _selectedIndex == index ? appColor : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product Name and Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product['boxCount']} Boxes',
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ),
                            const SizedBox(
                                width: 8), // Space between text and label
                            if (product['boxCountOnTheWay'] > 0) ...[
                              const SizedBox(
                                  width: 8), // Optional space before the label
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .transparent, // Transparent background
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 230, 96, 13)), // Yellow border
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                                child: Text(
                                  '${product['boxCountOnTheWay']} Boxes on Way',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 230, 96, 13),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey, thickness: 1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (product['productModel'] != null &&
                      product['productModel'].isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Models',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: product['productModel'].length,
                            itemBuilder: (context, index) {
                              final model = product['productModel'][index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model['model'],
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${model['boxCount']} boxes',
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const Divider(color: Colors.grey, thickness: 1),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Overview Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Brand',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['brand'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weight',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['weight'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Punch',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['punch'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Coverage Area',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['coverageArea'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pieces per Box',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['piecesPerBox'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Increased gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thickness',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product['thickness'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppFilledButton(
              title: 'Order Now',
              onPressed: () {
                if (userId == 0) {
                  // Navigate to login screen if userId is 0 (user not logged in)
                  Get.toNamed('/loginScreen', arguments: {
                    'returnRoute': '/productDetailsScreen',
                    'productId': productId,
                  });
                } else {
                  // If userId is 1 (user already logged in), navigate directly to createOrder
                  Get.toNamed('/createOrderScreen', arguments: {
                    'productId': productId,
                    'productImageUrl': productDetailsController
                        .productDetails[0]['productImageList'][0]['imageURL'],
                    'parentId': parentId
                  });
                }
              },
              buttonColor: appColor,
              radius: 8,
              width: w,
              height: 50,
              textColor: whiteColor,
              fontSize: 16,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black.withOpacity(0.8),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  // Allows zooming and panning
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // Display full image within bounds
                    width: MediaQuery.of(context).size.width, // Full width
                    height: MediaQuery.of(context).size.height, // Full height
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
