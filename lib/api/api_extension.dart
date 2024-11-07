import 'package:flutter/foundation.dart';

// import '../constant/requst_const.dart';

void printData({required dynamic tittle, dynamic val}) {
  if (kDebugMode) {
    print("$tittle:-$val");
  }
}

String errorText = "Something went wrong";
String statusText = "Success";

Map<String, String> requestHeader() {
  return {'accept': 'text/plain', 'Content-Type': 'application/json'};
}
