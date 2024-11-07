import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/user_controllers/login_controller.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/custom_text_fields.dart';
import 'package:tiles_app/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: 'Login',
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please sign in to continue',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                // const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'User ID',
                  hintText: 'Enter User ID',
                  controller: userIdController,
                ),
                CustomTextField(
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 30),
                AppFilledButton(
                  title: 'Sign In',
                  buttonColor: appColor,
                  textColor: whiteColor,
                  fontSize: 16,
                  onPressed: () async {
                    final loginSuccess = await loginController.postLogin(
                      userId: userIdController.text,
                      password: passwordController.text,
                    );

                    if (loginSuccess) {
                      // Check if there is a return route in the arguments
                      final returnRoute = Get.arguments?['returnRoute'];
                      final productId = Get.arguments?['productId'];

                      if (returnRoute != null && productId != null) {
                        // Navigate back to the ProductDetailsScreen after login
                        Get.offNamed(returnRoute, arguments: {
                          'id': productId,
                        });
                      } else {
                        // Handle other cases or navigate to the home screen
                        Get.offAllNamed('/locationScreen');
                      }
                    }
                  },
                ),
                const SizedBox(height: 40),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.toNamed('/registerScreen');
                //     },
                //     child: const Text(
                //       "Don't have an account? Sign up",
                //       style: TextStyle(
                //         fontFamily: 'Montserrat',
                //         fontSize: 14,
                //         color: appColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
