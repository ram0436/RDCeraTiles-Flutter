import 'package:tiles_app/constant/app_color.dart';
import 'package:flutter/cupertino.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const AppContainer({super.key, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? appColor,
      child: child,
    );
  }
}
