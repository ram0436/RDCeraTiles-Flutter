import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/api/api_firebase.dart';
import 'package:tiles_app/constant/app_assets.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_bottom_navigator.dart';
import 'package:tiles_app/widgets/app_button.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final HomeController homeController = Get.put(HomeController());
  // final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    super.initState();
    homeController.getCompanyDetail();
    // _firebaseApi.initNotifications();
    _checkUserLoginStatus();
    // Future.delayed(const Duration(seconds: 6), () {
    //   Get.offAllNamed(Routes.locationScreen);
    // });
  }

  Future<void> _checkUserLoginStatus() async {
    // Check if the user is logged in
    bool isLoggedIn = preferences.getBool(SharedPreference.isLogin);

    // Navigate based on login status
    if (isLoggedIn) {
      // User is logged in, move to LocationScreen
      Future.delayed(const Duration(seconds: 6), () {
        Get.offAllNamed(Routes.locationScreen);
      });
    } else {
      // User is not logged in, move to LoginScreen
      Future.delayed(const Duration(seconds: 6), () {
        Get.offAllNamed(
            Routes.loginScreen); // Make sure to define Routes.loginScreen
      });
    }
  }

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
            title: 'Home',
            backIcon: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Handle menu press here
              },
            ),
          ),
          body: Obx(() {
            if (homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Fetch company details dynamically
            var companyName =
                homeController.companyDetails['name'] ?? 'RD Cera Tiles';
            var logoUrl = homeController.companyDetails['logoURL'] ??
                AppAssets.appLogoUrl;

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.mapBg),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            logoUrl, // Dynamic logo URL
                            height: 65,
                            width: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Welcome to $companyName', // Dynamic company name
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
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
