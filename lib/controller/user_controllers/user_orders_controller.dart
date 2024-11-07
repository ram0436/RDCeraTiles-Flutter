import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/user_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class UserOrdersController extends GetxController {
  var myOrders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // Single loading state

  var _isMyOrdersLoading = false;

  void _updateLoadingState() {
    isLoading(_isMyOrdersLoading);
  }

  getMyOrders(int id) async {
    _isMyOrdersLoading = true;
    _updateLoadingState();

    ResponseItem result = await GetMyOrdersRepo.getMyOrdersRepo(id: id);
    try {
      if (result.status && result.data != null) {
        myOrders.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR in getMyOrders: $e');
    } finally {
      _isMyOrdersLoading = false;
      _updateLoadingState();
    }

    update();
  }
}
