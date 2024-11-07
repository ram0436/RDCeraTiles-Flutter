import 'package:tiles_app/api/api_helpers.dart';
import 'package:tiles_app/constant/app_request.dart';
import 'package:tiles_app/model/response_item.dart';

class AuthLogin {
  static Future<ResponseItem> authLoginRepo({
    required String userId,
    required String password,
  }) async {
    ResponseItem result = ResponseItem();
    String requestUrl =
        "${AppUrls.BASE_URL}${MethodNames.authLogin}?userId=$userId&password=$password";
    result = await BaseApiHelper.postRequest(requestUrl, {});
    return result;
  }
}
