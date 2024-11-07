import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_assets.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/constant/app_string.dart';
import 'package:tiles_app/model/post_login_response_model.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_bottom_navigator.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/controller/location_controller.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _selectedIndex = 0;
  bool isRegisteredUser = false;
  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    locationController.getAllLocationData();
    checkRegisteredUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> checkRegisteredUser() async {
    if (preferences
        .getString(SharedPreference.userData)
        .toString()
        .isNotEmpty) {
      final userLoginResponseModel = UserLoginResponseModel.fromJson(
        json.decode(
            preferences.getString(SharedPreference.userData).toString()),
      );
      setState(() {
        isRegisteredUser = userLoginResponseModel.isRegisteredUser;
      });
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
            title: AppString.location,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02),
                Obx(() {
                  if (locationController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (locationController.locations.isEmpty) {
                    return const Center(
                      child: Text('No locations found.'),
                    );
                  } else if (!isRegisteredUser) {
                    return const Center(
                      child: Text(
                        'User is not registered, please contact app admin to register yourself.',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: locationController.locations.length,
                      itemBuilder: (context, index) {
                        final location = locationController.locations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.categoriesListScreen,
                                arguments: location["id"],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 247, 247, 247),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppAssets.marker,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        location["name"]!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
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
