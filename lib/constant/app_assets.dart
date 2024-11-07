import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const appLogo = "${imagePath}logo.gif";

  static const appLogoUrl =
      "https://cfdblob.blob.core.windows.net/logo/RD_Cera_Tilies_Logo.png";

  ///dummyImage
  static const dummyPhoneImage = "${imagePath}phone.png";
  static const dummyTabletImage = "${imagePath}tablet.jpg";
  static const gadgets = "${imagePath}gadgets.png";
  static const properties = "${imagePath}house.png";
  static const job = "${imagePath}job.png";
  static const furniture = "${imagePath}sofa.png";
  static const book = "${imagePath}book.png";
  static const sports = "${imagePath}sports.png";
  static const pets = "${imagePath}pets.png";
  static const fashion = "${imagePath}fashion.png";
  static const fleetCar = "${imagePath}fleetCar.png";
  static const commercial = "${imagePath}commercial.png";
  static const electronics = "${imagePath}electronics.png";
  static const profile = "${imagePath}profile.png";
  static const location = "${imagePath}location.png";
  static const mapBg = "${imagePath}maps.png";
  static const marker = "${imagePath}marker.png";
  static const tilesLogo = "${imagePath}tiles-logo.jpg";
  static const floor = "${imagePath}floor.png";
}

Widget assetImage(String image,
    {double? height, double? width, Color? color, double? scale}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    scale: scale,
  );
}

Widget cachedNetworkImage(
    {required String url, required double height, double? width}) {
  if (url.isEmpty) {
    return Image.asset(
      AppAssets.appLogo,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  } else {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fill,
      height: height,
      width: width,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      errorWidget: (context, url, error) {
        return Container(child: assetImage(AppAssets.appLogo));
      },
    );
  }
}
