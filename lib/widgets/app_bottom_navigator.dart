import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/model/post_login_response_model.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/utils/shared_prefs.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  // Future<String?> getRole() async {
  //   if (preferences
  //       .getString(SharedPreference.userData)
  //       .toString()
  //       .isNotEmpty) {
  //     final userLoginResponseModel = UserLoginResponseModel.fromJson(
  //       json.decode(
  //           preferences.getString(SharedPreference.userData).toString()),
  //     );

  //     return userLoginResponseModel.role;
  //   }
  //   return null;
  // }

  Future<String?> getRole() async {
    final userDataString = preferences.getString(SharedPreference.userData);
    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        final userLoginResponseModel = UserLoginResponseModel.fromJson(
          json.decode(userDataString),
        );
        return userLoginResponseModel.role;
      } catch (e) {
        log('Error decoding user data JSON: $e');
        return null;
      }
    } else {
      log('User data is empty or null');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          // } else if (snapshot.hasError) {
          //   return const Center(child: Text("Error loading role"));
        } else {
          String? role = snapshot.data;
          int userId = preferences.getInt(SharedPreference.userId);

          return Container(
            padding: const EdgeInsets.all(10),
            color: appColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(Icons.home, 'Home', 0, role),
                if (userId > 0)
                  _buildBottomNavItem(
                      Icons.person_rounded, 'My Profile', 4, role),
                if (role == 'User' || role == 'Admin')
                  _buildBottomNavItem(Icons.dashboard, 'Dashboard', 2, role),
                if (userId > 0)
                  _buildBottomNavItem(Icons.logout, 'Logout', 3, role)
                else
                  _buildBottomNavItem(Icons.person, 'Login', 3, role),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomNavItem(
      IconData icon, String label, int index, String? role) {
    return GestureDetector(
      onTap: () async {
        bool isLoggedIn = preferences.getBool(SharedPreference.isLogin);
        if (index == 0) {
          if (isLoggedIn) {
            Get.toNamed(Routes.locationScreen);
          } else {
            Get.toNamed(Routes.loginScreen);
          }
        } else if (index == 1) {
          Get.toNamed(Routes.adminDashboardScreen);
        } else if (index == 2) {
          if (role == 'User') {
            Get.toNamed(Routes.userDashboardScreen);
          } else if (role == 'Admin') {
            Get.toNamed(Routes.adminDashboardScreen);
          }
        } else if (index == 3) {
          int userId = preferences.getInt(SharedPreference.userId);
          if (userId > 0) {
            await preferences.logOut();
          } else {
            Get.toNamed(Routes.loginScreen);
          }
        } else if (index == 4) {
          Get.toNamed(Routes.userProfileScreen);
        } else {
          onItemTapped(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
