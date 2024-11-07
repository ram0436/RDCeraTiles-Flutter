import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:intl/intl.dart';
import 'package:tiles_app/api/repo/user_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/utils/shared_prefs.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Get the FCM token
    String? fCMToken = await _firebaseMessaging.getToken();
    if (fCMToken != null) {
      _checkAndAddFCMToken(fCMToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _updateToken(newToken);
    });

    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> _checkAndAddFCMToken(String token) async {
    int loggedInUserId = 0;
    bool tokenExists = false;
    String? userDataJson = preferences.getString(SharedPreference.userData);
    if (userDataJson != null) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);
      loggedInUserId = userData['id'];
    }

    // Fetch existing tokens
    try {
      ResponseItem result = await GetAllFCMTokenRepo.getAllFCMTokenRepo();
      if (result.status && result.data != null) {
        // Extract existing tokens for the logged-in user
        List<dynamic> tokens = result.data;
        for (var item in tokens) {
          if (item['loggedInUserId'] == loggedInUserId) {
            if (item['token'] == token) {
              tokenExists = true;
              break;
            }
          }
        }

        if (!tokenExists) {
          await _addFCMToken(token);
        } else {
          log('FCM Token already exists for this user.');
        }
      } else {
        log('Failed to fetch existing tokens or no tokens found');
      }
    } catch (e) {
      log('Error checking existing tokens: $e');
    }
  }

  Future<void> _addFCMToken(String token) async {
    String userRole = 'User';
    int loggedInUserId = 0;
    String? userDataJson = preferences.getString(SharedPreference.userData);
    if (userDataJson != null) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);
      loggedInUserId = userData['id'];
      userRole = userData['role'] ?? '';
    }

    if (userRole == 'Admin') {
      final fcmTokenData = {
        "token": token,
        "loggedInUserId": loggedInUserId,
        "loggedInDateTime":
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
      };

      try {
        ResponseItem result =
            await AddFCMTokenRepo.addFCMTokenRepo(fcmTokenData: fcmTokenData);
        if (result.status == true) {
          log('FCM Token Added Successfully');
        } else {
          log('Failed to add FCM Token');
        }
      } catch (e) {
        log('ERROR while Adding FCM Token: $e');
      }
    }
  }

  Future<void> _updateToken(String token) async {
    String userRole = 'User';
    int loggedInUserId = 0;
    String? userDataJson = preferences.getString(SharedPreference.userData);
    if (userDataJson != null) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);
      userRole = userData['role'] ?? '';
      loggedInUserId = userData['id'];
    }

    if (userRole == 'Admin') {
      try {
        ResponseItem result = await UpdateFCMToken.updateFCMToken(
            loggedInUserId: loggedInUserId, fcmToken: token);
        if (result.status == true) {
          log('FCM Token Updated Successfully');
        } else {}
      } catch (e) {
        log('ERROR while Adding FCM Token: $e');
      } finally {}
    }
    ;
  }
}

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = jsonDecode(dotenv.env['SERVICE_ACCOUNT_JSON']!);

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToAdmin(String deviceToken) async {
    final String serverAccessTokenKey = await getAccessToken();
    print(serverAccessTokenKey);

    String fullName = 'User';

    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/push-notifications-185cf/messages:send';

    String? userDataJson = preferences.getString(SharedPreference.userData);
    if (userDataJson != null) {
      Map<String, dynamic> userData = jsonDecode(userDataJson);

      // Extract first name and last name and combine them
      String firstName = userData['firstName'] ?? '';
      String lastName = userData['lastName'] ?? '';
      fullName = '$firstName $lastName';
    }

    final Map<String, dynamic> notification = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': 'New order',
          'body': '$fullName has placed Order',
        },
      },
    };

    // print(notification);

    final http.Response response =
        await http.post(Uri.parse(endpointFirebaseCloudMessaging),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $serverAccessTokenKey'
            },
            body: jsonEncode(notification));

    if (response.statusCode == 200) {
      print("notification sent successfully");
    } else {
      print("Error while sending Notification");
    }
  }
}
