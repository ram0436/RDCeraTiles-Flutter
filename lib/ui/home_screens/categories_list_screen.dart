import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_assets.dart';
import 'package:tiles_app/controller/category_list_controller.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_bottom_navigator.dart';
import 'package:tiles_app/widgets/app_container.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  final CategoryListController categoryListController =
      Get.put(CategoryListController());

  @override
  void initState() {
    super.initState();
    final int locationId = Get.arguments ?? 0;
    categoryListController.getParentCategory(locationId);
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
            title: 'Tiles Categories',
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Category List with fallback messages
                Expanded(
                  child: Obx(() {
                    if (categoryListController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // If no parent categories are found, show "No tiles found"
                    if (categoryListController.parentCategories.isEmpty) {
                      return const Center(child: Text('No tiles found.'));
                    }

                    return ListView.builder(
                      itemCount: categoryListController.parentCategories.length,
                      itemBuilder: (context, index) {
                        final parentCategory =
                            categoryListController.parentCategories[index];
                        final parentId = parentCategory['id'];
                        final categories =
                            categoryListController.categoryMap[parentId] ?? [];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display parent category name
                              Text(
                                parentCategory['name'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Check if subcategories exist
                              Obx(() {
                                if (categoryListController
                                        .isCategoryLoading[parentId] ??
                                    true) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                // If no subcategories are found for the parent category
                                if (categories.isEmpty) {
                                  return const Text(
                                    'No tile categories found.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: categories.length,
                                  itemBuilder: (context, subIndex) {
                                    final category = categories[subIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to ProductsScreen with category ID
                                        Get.toNamed(Routes.productScreen,
                                            arguments: {
                                              'categoryId': category['id'],
                                              'categoryName': category['name'],
                                              'parentId': parentCategory['id'],
                                            });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AppAssets.floor,
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                category['name'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                              const SizedBox(
                                  height: 20), // Space between categories
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBarWidget(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
