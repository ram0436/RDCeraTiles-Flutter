import 'package:tiles_app/constant/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        height: h * 0.05,
        width: h * 0.05,
        decoration: BoxDecoration(
          border: Border.all(color: appColor, width: 0.5),
          color: appColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: SpinKitSpinningLines(
            color: whiteColor,
            size: 25,
          ),
        ),
      ),
    );
  }
}
