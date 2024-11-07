import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/utils/extension.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_bottom_navigator.dart';
import 'package:tiles_app/widgets/app_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAddBrand() {
    Get.toNamed(Routes.addBrandScreen);
  }

  void _navigateToAddProduct() {
    Get.toNamed(
      Routes.addProductScreen,
      arguments: {
        'isFrom': "formScreen",
        'productDetails': <String, dynamic>{},
      },
    );
  }

  void _navigateToManageOrders() {
    Get.toNamed(Routes.adminOrdersScreen);
  }

  void _navigateToAddParentCategory() {
    Get.toNamed(Routes.addParentCategoryScreen);
  }

  void _navigateToAddCategory() {
    Get.toNamed(Routes.addCategoryScreen);
  }

  void _navigateToAddSubCategory() {
    Get.toNamed(Routes.addSubCategoryScreen);
  }

  void _navigateToAddLocation() {
    Get.toNamed(Routes.addLocationScreen);
  }

  void _navigateToAddCompanyDetails() {
    Get.toNamed(Routes.addCompanyDetailScreen);
  }

  void _navigateToUpdatePurchase() {
    Get.toNamed(Routes.updatePurchaseScreen);
  }

  void _navigateToUpdateSale() {
    Get.toNamed(Routes.updateSaleScreen);
  }

  void _navigateToAddOnTheWayBoxes() {
    Get.toNamed(Routes.updateOnTheWayBoxScreen);
  }

  void _navigateToAddUser() {
    Get.toNamed(Routes.registerScreen);
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
            title: 'Admin Dashboard',
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.0.addHSpace(),
                'Manage App'.boldMontserratTextStyle(
                  fontSize: 24,
                  fontColor: Colors.black,
                ),
                10.0.addHSpace(),
                'Select options below to manage:'.regularMontserratTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black54,
                ),
                30.0.addHSpace(),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildGridItem(
                        icon: Icons.local_shipping,
                        title: 'Manage Orders',
                        onTap: _navigateToManageOrders,
                      ),
                      _buildGridItem(
                        icon: Icons.add_shopping_cart,
                        title: 'Add Product',
                        onTap: _navigateToAddProduct,
                      ),
                      _buildGridItem(
                        icon: Icons.playlist_add,
                        title: 'Purchase Stock',
                        onTap: _navigateToUpdatePurchase,
                      ),
                      _buildGridItem(
                        icon: Icons.sell,
                        title: 'Sales Stock',
                        onTap: _navigateToUpdateSale,
                      ),
                      _buildGridItem(
                        icon: Icons.add_box_rounded,
                        title: 'Update On The Way Boxes',
                        onTap: _navigateToAddOnTheWayBoxes,
                      ),
                      _buildGridItem(
                        icon: Icons.person_add_alt_1_rounded,
                        title: 'Register User',
                        onTap: _navigateToAddUser,
                      ),
                      _buildGridItem(
                        icon: Icons.store,
                        title: 'Add Brand',
                        onTap: _navigateToAddBrand,
                      ),
                      _buildGridItem(
                        icon: Icons.location_on,
                        title: 'Add Location',
                        onTap: _navigateToAddLocation,
                      ),
                      _buildGridItem(
                        icon: Icons.category,
                        title: 'Add Parent Category',
                        onTap: _navigateToAddParentCategory,
                      ),
                      _buildGridItem(
                        icon: Icons.my_library_add_outlined,
                        title: 'Add Category',
                        onTap: _navigateToAddCategory,
                      ),
                      _buildGridItem(
                        icon: Icons.ballot_outlined,
                        title: 'Add Sub Category',
                        onTap: _navigateToAddSubCategory,
                      ),
                      _buildGridItem(
                        icon: Icons.business_center,
                        title: 'Add Company Details',
                        onTap: _navigateToAddCompanyDetails,
                      ),
                    ],
                  ),
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

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(
            color: Colors.grey[300]!,
          ),
        ),
        child: Padding(
          // Add padding here
          padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: appColor, // Using appColor for the icon color
              ),
              10.0.addHSpace(),
              Center(
                // Ensure the text is centered
                child: title.w500MontserratTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
