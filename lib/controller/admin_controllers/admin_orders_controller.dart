import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:tiles_app/api/repo/user_repo.dart';
import 'package:tiles_app/model/response_item.dart';
import 'package:tiles_app/theme/app_layout.dart';

class AdminOrdersController extends GetxController {
  var allOrders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  var _isAllOrdersLoading = false;
  var storedDaysCount;

  void _updateLoadingState() {
    isLoading(_isAllOrdersLoading);
  }

  getAllOrders(int daysCount) async {
    _isAllOrdersLoading = true;
    storedDaysCount = daysCount;
    _updateLoadingState();

    ResponseItem result =
        await GetCustomerOrdersRepo.getCustomerOrdersRepo(daysCount: daysCount);
    try {
      if (result.status && result.data != null) {
        allOrders.value = (result.data as List).cast<Map<String, dynamic>>();
      } else {
        showBottomSnackBar(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      log('ERROR in getMyOrders: $e');
    } finally {
      _isAllOrdersLoading = false;
      _updateLoadingState();
    }

    update();
  }

  Future<bool> approveOrder({
    required int orderId,
    required int orderStatus,
  }) async {
    ResponseItem result;
    result = await OrderApprovedByAdminRepo.orderApprovedByAdminRepo(
      orderId: orderId,
      orderStatus: orderStatus,
    );

    try {
      if (result.status) {
        if (result.data != null) {
          showSuccessSnackBar('Action Taken Successfully');
          getAllOrders(storedDaysCount);
          return true;
        }
      } else {
        showSuccessSnackBar('Error While Taking Action');
        return false; // Return false for failed login
      }
    } catch (e) {
      log('Error While Taking Order Action: $e');
      return false; // Return false in case of an error
    } finally {
      update();
    }

    return false; // Default return false if not already handled
  }
}
