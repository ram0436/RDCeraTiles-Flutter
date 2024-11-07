import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:tiles_app/api/api_exeception.dart';
import 'package:tiles_app/api/api_extension.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BaseApiHelper {
  static Future<ResponseItem> postRequest(String requestUrl,
      [Map<String, dynamic> requestData = const {}]) async {
    log("request:$requestUrl");
    log("headers:${requestHeader()}");
    log("body:${json.encode(requestData)}");
    return await http
        .post(Uri.parse(requestUrl),
            // body: requestData,
            body: json.encode(requestData),

            // encoding: Encoding.getByName('utf-8'),
            headers: requestHeader())
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<ResponseItem> putRequest(String requestUrl,
      [Map<String, dynamic> requestData = const {}]) async {
    log("request:$requestUrl");
    log("headers:${requestHeader()}");
    log("body:${json.encode(requestData)}");
    return await http
        .put(Uri.parse(requestUrl),
            // body: requestData,
            body: json.encode(requestData),

            // encoding: Encoding.getByName('utf-8'),
            headers: requestHeader())
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<dynamic> getRequest(String requestUrl,
      {Map<String, dynamic>? params}) async {
    log("request:$requestUrl");
    // log("headers:${requestHeader(passAuthToken)}");

    return await http
        .get(
          Uri.parse(requestUrl),
          // headers: requestHeader(passAuthToken)
        )
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<ResponseItem> deleteRequest(String requestUrl) async {
    log("request:$requestUrl");
    // log("headers:${requestHeader(passAuthToken)}");

    return await http
        .delete(
          Uri.parse(requestUrl),
          // headers: requestHeader(passAuthToken)
        )
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<ResponseItem> patchRequest(String requestUrl,
      Map<String, dynamic> requestData, bool passAuthToken) async {
    log("request:$requestUrl");
    // log("headers:${requestHeader(passAuthToken)}");

    return await http
        .patch(
          Uri.parse(requestUrl), body: json.encode(requestData),
          // headers: requestHeader(passAuthToken)
        )
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<ResponseItem> uploadFormData(
      {required String requestUrl,
      required Map<String, String> requestData}) async {
    var request = http.MultipartRequest("POST", Uri.parse(requestUrl));

    // request.headers.addAll(requestHeader(true));
    request.fields.addAll(requestData);

    log(request.toString(), name: "REQUEST");
    // log(profileImage!.field.toString());
    // log("body:${json.encode(requestData)}");
    return await request.send().then((streamedResponse) {
      return http.Response.fromStream(streamedResponse)
          .then((value) => onValue(value));
    }).onError((error, stackTrace) => onError(error));
  }

  static Future<ResponseItem> uploadImages(
      {required String requestUrl, required List<File> requestData}) async {
    var request = http.MultipartRequest("POST", Uri.parse(requestUrl));
    request.headers.addAll({"accept": "text/plain"});

    for (var element in requestData) {
      request.files
          .add(await http.MultipartFile.fromPath('files', element.path));
    }

    return await request.send().then((streamedResponse) {
      return http.Response.fromStream(streamedResponse).then((value) {
        log('value---------->>>>>> $value');

        return onValue(value);
      });
    }).onError((error, stackTrace) => onError(error));
  }

  static Future uploadStatus(
      {required String requestUrl,
      required Map<String, String> requestData}) async {
    var request = http.MultipartRequest("POST", Uri.parse(requestUrl));

    // request.headers.addAll(requestHeader(true));
    request.fields.addAll(requestData);

    log(request.toString(), name: "REQUEST");
    // log(profileImage!.field.toString());
    // log("body:${json.encode(requestData)}");
    return await request.send().then((streamedResponse) {
      return http.Response.fromStream(streamedResponse)
          .then((value) => uploadOnStatus(value));
    });
  }

  static Future uploadOnStatus(http.Response response) async {
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Success");
    } else {}
  }

  String base64Decode(String encoded) {
    return utf8.decode(base64.decode(encoded));
  }

  static Future onValue(http.Response response) async {
    log(response.statusCode.toString());
    log(response.body.toString());

    final ResponseItem result =
        ResponseItem(status: false, message: "Something went wrong.");
    dynamic data;
    if (response.body.isNotEmpty) {
      data = json.decode(response.body);
    }
    log("responseCode---: ${response.statusCode}", name: "response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      result.status = true;
      result.data = data;
      log("Success");
    } else if (response.statusCode == 400) {
      showAppSnackBar("Invalid Status");
      Get.back();
    } else {
      result.message = data["message"] ?? "";
      print("result.message --> ${result.message}");
      log("response: $data");
    }

    return result;
  }

  // static Future baseOnValue(http.Response response) async {
  //   ResponseItem result;
  //   final Map<String, dynamic> responseData = json.decode(response.body);
  //   String status;
  //   String message;
  //   dynamic data = responseData;
  //
  //   log("responseCode: ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     message = "Ok";
  //     status = "Success";
  //     data = responseData;
  //   } else {
  //     log("response: $data", name: 'error');
  //     message = "Something went wrong.";
  //   }
  //   result = ResponseItem(data: data, message: message, status: status);
  //   log("response: {data: ${result.data}, message: $message, status: $status}",
  //       name: APP_NAME);
  //   return result;
  // }

  static onError(error) {
    log("Error caused: $error");
    String message = "Unsuccessful request";
    if (error is SocketException) {
      message = ResponseException("No internet connection").toString();
    } else if (error is FormatException) {
      // message = ResponseException("Something wrong in response.").toString() +
      //     error.toString();
    }
    return ResponseItem(data: null, message: message, status: false);
  }
}
