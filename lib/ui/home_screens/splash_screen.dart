import 'package:tiles_app/constant/app_assets.dart';
import 'package:tiles_app/utils/app_routes.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.homeScreen);
    });
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Scaffold(
        backgroundColor: const Color(0xFF024756),
        body: Center(
          child: ClipOval(
            child: Image.network(
              AppAssets.appLogoUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
