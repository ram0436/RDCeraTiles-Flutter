import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/user_controllers/user_profile_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController userProfileController =
      Get.put(UserProfileController());
  int? userId;

  @override
  void initState() {
    super.initState();
    userId = preferences.getInt(SharedPreference.userId);
    if (userId != null) {
      userProfileController.getUserProfile(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: "My Profile",
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Obx(() {
              if (userProfileController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var userProfile = userProfileController.userProfile;
              if (userProfile.isEmpty) {
                return const Center(
                  child: Text("No user data available"),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.02),
                  // Heading
                  const Text(
                    "Manage Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  // Display user details
                  buildProfileRow("Name: ",
                      "${userProfile['firstName']} ${userProfile['lastName']}"),
                  buildProfileRow(
                      "Mobile Number: ", userProfile['mobile'] ?? 'N/A'),
                  buildProfileRow("Email: ", userProfile['email'] ?? 'N/A'),
                  buildProfileRow("Website: ", userProfile['website'] ?? 'N/A'),
                  buildProfileRow("Pincode: ", userProfile['pincode'] ?? 'N/A'),
                  buildProfileRow("City: ", userProfile['city'] ?? 'N/A'),
                  buildProfileRow("State: ", userProfile['state'] ?? 'N/A'),
                  buildProfileRow("GST No.: ", userProfile['gstNo'] ?? 'N/A'),
                  buildProfileRow("PAN: ", userProfile['pan'] ?? 'N/A'),
                  buildProfileRow("Address: ", userProfile['address'] ?? 'N/A'),

                  SizedBox(height: h * 0.04),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // Helper method to build each profile row
  Widget buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            // Make the value flexible to wrap
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Montserrat",
              ),
              softWrap: true, // Enable soft wrapping
            ),
          ),
        ],
      ),
    );
  }
}
