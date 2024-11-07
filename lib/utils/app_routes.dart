import 'package:get/get.dart';
import 'package:tiles_app/ui/admin_screens/add_brand_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_category_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_company_detail_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_location_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_parent_category_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_product_screen.dart';
import 'package:tiles_app/ui/admin_screens/add_sub_category_screen.dart';
import 'package:tiles_app/ui/admin_screens/admin_dashboard_screen.dart';
import 'package:tiles_app/ui/admin_screens/admin_orders_screen.dart';
import 'package:tiles_app/ui/admin_screens/update_boxes_screen.dart';
import 'package:tiles_app/ui/admin_screens/update_purchase_screen.dart';
import 'package:tiles_app/ui/admin_screens/update_sales_screen.dart';
import 'package:tiles_app/ui/home_screens/categories_list_screen.dart';
import 'package:tiles_app/ui/products_screens/create_order_screen.dart';
import 'package:tiles_app/ui/home_screens/home_screen.dart';
import 'package:tiles_app/ui/home_screens/location_screen.dart';
import 'package:tiles_app/ui/user_screens/login_screen.dart';
import 'package:tiles_app/ui/products_screens/product_details_screen.dart';
import 'package:tiles_app/ui/products_screens/products_screen.dart';
import 'package:tiles_app/ui/user_screens/register_screen.dart';
import 'package:tiles_app/ui/home_screens/splash_screen.dart';
import 'package:tiles_app/ui/user_screens/user_dashboard_screen.dart';
import 'package:tiles_app/ui/user_screens/user_orders_screen.dart';
import 'package:tiles_app/ui/user_screens/user_profile_screen.dart';

class Routes {
  static String splashScreen = "/";
  static String homeScreen = "/homeScreen";
  static String locationScreen = "/locationScreen";
  static String categoriesListScreen = "/categoriesListScreen";
  static String productScreen = "/productScreen";
  static String productDetailsScreen = "/productDetailsScreen";
  static String addProductScreen = "/addProductScreen";
  static String loginScreen = "/loginScreen";
  static String registerScreen = "/registerScreen";
  static String adminDashboardScreen = "/adminDashboardScreen";
  static String addBrandScreen = "/addBrandScreen";
  static String addLocationScreen = "/addLocationScreen";
  static String adminOrdersScreen = "/adminOrdersScreen";
  static String createOrderScreen = "/createOrderScreen";
  static String userDashboardScreen = "/userDashboardScreen";
  static String userProfileScreen = "/userProfileScreen";
  static String userOrdersScreen = "/userOrdersScreen";
  static String addParentCategoryScreen = "/addParentCategoryScreen";
  static String addCategoryScreen = "/addCategoryScreen";
  static String addSubCategoryScreen = "/addSubCategoryScreen";
  static String addCompanyDetailScreen = "/addCompanyDetailScreen";
  static String updatePurchaseScreen = "/updatePurchaseScreen";
  static String updateSaleScreen = "/updateSaleScreen";
  static String updateOnTheWayBoxScreen = "/updateOnTheWayBoxScreen";

  static List<GetPage> routes = [
    GetPage(
        name: splashScreen,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: homeScreen,
        page: () => const HomeScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: locationScreen,
        page: () => const LocationScreen(),
        transition: Transition.downToUp),
    GetPage(
        name: categoriesListScreen,
        page: () => const CategoriesListScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: productScreen,
        page: () => const ProductsScreen(),
        transition: Transition.upToDown),
    GetPage(
        name: productDetailsScreen,
        page: () => const ProductDetailsScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addProductScreen,
        page: () => const AddProductScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: loginScreen,
        page: () => const LoginScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: registerScreen,
        page: () => const RegisterScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: adminDashboardScreen,
        page: () => const AdminDashboardScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addBrandScreen,
        page: () => const AddBrandScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addLocationScreen,
        page: () => const AddLocationScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: createOrderScreen,
        page: () => const CreateOrderScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: userDashboardScreen,
        page: () => const UserDashboardScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: userProfileScreen,
        page: () => const UserProfileScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: userOrdersScreen,
        page: () => const UserOrdersScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: adminOrdersScreen,
        page: () => const AdminOrdersScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addParentCategoryScreen,
        page: () => const AddParentCategoryScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addCategoryScreen,
        page: () => const AddCategoryScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addSubCategoryScreen,
        page: () => const AddSubCategoryScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: addCompanyDetailScreen,
        page: () => const AddCompanyDetailScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: updatePurchaseScreen,
        page: () => const UpdatePurchaseScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: updateSaleScreen,
        page: () => const UpdateSaleScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: updateOnTheWayBoxScreen,
        page: () => const UpdateOnTheWayBoxesScreen(),
        transition: Transition.fadeIn),
  ];
}
