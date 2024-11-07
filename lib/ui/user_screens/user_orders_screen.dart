import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/user_controllers/user_orders_controller.dart';
import 'package:tiles_app/utils/shared_prefs.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_container.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  final UserOrdersController userOrdersController =
      Get.put(UserOrdersController());
  int userId = 0;

  // Function to format date
  String formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMMM dd, yyyy - hh:mm a');
    return formatter.format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    userId = preferences.getInt(SharedPreference.userId);
    userOrdersController.getMyOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AppContainer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: CommonAppBar(
            h: h,
            w: w,
            title: "My Orders",
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02), // Padding on top
                const Text(
                  "Recent Orders",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: h * 0.02),
                Expanded(
                  child: Obx(() {
                    if (userOrdersController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userOrdersController.myOrders.isEmpty) {
                      return const Center(
                        child: Text(
                          "No orders found.",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: userOrdersController.myOrders.length,
                      itemBuilder: (context, index) {
                        final order = userOrdersController.myOrders[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: h * 0.02),
                          padding: EdgeInsets.all(w * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                label: "Product Name: ",
                                value: order['productName'] ?? 'N/A',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: "Model Name: ",
                                value: order['modelName'] ?? 'N/A',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: "Number of Boxes: ",
                                value: order['numberOfBoxesOrdered'].toString(),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: "Delivery Location: ",
                                value: order['deliveryLocation'] ?? 'N/A',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: "Customer Name: ",
                                value: order['customerName'] ?? 'N/A',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                label: "Date of Order: ",
                                value: order['dateOfOrder'] != null
                                    ? formatDate(order['dateOfOrder'])
                                    : 'N/A',
                              ),
                              const SizedBox(height: 8),
                              _buildOrderStatusRow(order['orderStatus']),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusRow(int? status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = "Pending";
        statusColor = const Color.fromARGB(255, 184, 166, 3);
        break;
      case 1:
        statusText = "Approved";
        statusColor = Colors.green;
        break;
      case 2:
        statusText = "Rejected";
        statusColor = Colors.red;
        break;
      default:
        statusText = "Unknown";
        statusColor = Colors.grey;
    }

    return RichText(
      text: TextSpan(
        text: "Order Status: ",
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: statusText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
