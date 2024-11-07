import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/products_controllers/products_controller.dart';
import 'package:tiles_app/model/post_login_response_model.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_bottom_navigator.dart';
import 'package:tiles_app/widgets/app_container.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductsController productsController = Get.put(ProductsController());
  int categoryId = 0;
  int parentId = 0;
  String categoryName = '';
  int? selectedSubCategoryId;
  String? userRole = '';

  @override
  void initState() {
    super.initState();
    categoryId = Get.arguments['categoryId'] ?? 0;
    categoryName = Get.arguments['categoryName'] ?? '';
    parentId = Get.arguments['parentId'] ?? 0;
    productsController.getSubCategory(categoryId);
    productsController.getAllProducts(categoryId);
    selectedSubCategoryId = -1;
    getUserRole();
  }

  Future<void> getUserRole() async {
    if (preferences
        .getString(SharedPreference.userData)
        .toString()
        .isNotEmpty) {
      final userLoginResponseModel = UserLoginResponseModel.fromJson(
        json.decode(
            preferences.getString(SharedPreference.userData).toString()),
      );
      setState(() {
        userRole = userLoginResponseModel.role;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            title: categoryName.isNotEmpty ? categoryName : 'Products',
          ),
          body: Obx(() {
            if (productsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Prepend "All" to subcategories
            final subCategoriesWithAll = [
              {'name': 'All', 'id': 0}, // Add All option
              ...productsController.subCategories,
            ];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (subCategoriesWithAll.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSubCategoryId =
                                      -1; // Update selected ID to "All"
                                });
                                productsController.getAllProducts(
                                    categoryId); // Fetch all products
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selectedSubCategoryId == -1
                                      ? appColor
                                      : const Color.fromARGB(
                                          255, 238, 238, 238),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedSubCategoryId == -1
                                        ? Colors.white
                                        : const Color.fromARGB(255, 0, 0, 0),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            ...productsController.subCategories
                                .map((subCategory) {
                              final isSelected =
                                  selectedSubCategoryId == subCategory['id'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSubCategoryId =
                                        subCategory['id']; // Update selected ID
                                  });
                                  productsController.getProductsBySubCategoryId(
                                      subCategory[
                                          'id']); // Fetch products for selected subcategory
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? appColor
                                        : const Color.fromARGB(
                                            255, 238, 238, 238),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    subCategory['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (productsController.products.isNotEmpty) ...[
                        Text(
                          "Total products: ${productsController.products.length}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (productsController.products.isEmpty) ...[
                    const Center(
                        child: Text(
                      "No products found",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )),
                  ] else ...[
                    Expanded(
                      child: GridView.builder(
                        itemCount: productsController.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = productsController.products[index];
                          final imageUrl =
                              product['productImageList']?.isNotEmpty == true
                                  ? product['productImageList'][0]['imageURL']
                                  : 'https://placeholder.com/placeholder.png';
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.productDetailsScreen,
                                arguments: {
                                  'id': product['id'],
                                  'parentId': parentId
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 224, 224, 224)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        height: 200,
                                        width: double.infinity,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product['name'] != null &&
                                                      product['name'].length >
                                                          14
                                                  ? '${product['name'].substring(0, 14)}...'
                                                  : product['name'] ??
                                                      'Product Name',
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // const SizedBox(height: 4),
                                        // Text(
                                        //   '${product['size'] ?? 'N/A'}',
                                        //   style: const TextStyle(
                                        //     fontFamily: 'Montserrat',
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product['boxCount'] ?? '0'} Boxes',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${product['weight'] ?? 'N/A'}',
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                color: Colors.green,
                                              ),
                                            ),
                                            if (userRole == 'Admin')
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        Routes.addProductScreen,
                                                        arguments: {
                                                          'isFrom':
                                                              "editScreen",
                                                          'productId':
                                                              product["id"],
                                                          'productDetails':
                                                              product,
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Confirm Deletion"),
                                                            content: const Text(
                                                                "Do you want to delete this product?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "No"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  productsController
                                                                      .deleteProduct(
                                                                          product[
                                                                              "id"]);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog after deletion
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Yes"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            // Text(
                                            //   '${product['thickness'] ?? 'N/A'}',
                                            //   style: const TextStyle(
                                            //     fontFamily: 'Montserrat',
                                            //     fontSize: 14,
                                            //     fontWeight: FontWeight.bold,
                                            //     color: Colors.green,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          bottomNavigationBar: BottomNavigationBarWidget(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
