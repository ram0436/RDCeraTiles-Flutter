import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tiles_app/constant/app_color.dart';
import 'package:tiles_app/controller/admin_controllers/admin_orders_controller.dart';
import 'package:tiles_app/widgets/app_appbar.dart';
import 'package:tiles_app/widgets/app_button.dart';
import 'package:tiles_app/widgets/app_container.dart';
import 'package:tiles_app/widgets/custom_dropdown.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final AdminOrdersController adminOrdersController =
      Get.put(AdminOrdersController());

  int userId = 0;
  String selectedTimeframe = 'Today';

  // Function to format date
  String formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMMM dd, yyyy - hh:mm a');
    return formatter.format(parsedDate);
  }

  // Function to map selected timeframe to daysCount
  int _getDaysCount(String timeframe) {
    switch (timeframe) {
      case 'Today':
        return 0;
      case 'Yesterday':
        return 1;
      case 'Last Week':
        return 7;
      case 'Last Two Weeks':
        return 14;
      case 'Last One Month':
        return 30;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch orders with the default selection (Today)
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
            title: "Customer Orders",
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02), // Padding on top
                const Text(
                  "Select Orders Timeframe",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: h * 0.02),
                CustomDropdown(
                  hintText: "Select Timeframe",
                  labelText: "Timeframe",
                  items: const [
                    DropdownMenuItem(value: 'Today', child: Text('Today')),
                    DropdownMenuItem(
                        value: 'Yesterday', child: Text('Yesterday')),
                    DropdownMenuItem(
                        value: 'Last Week', child: Text('Last Week')),
                    DropdownMenuItem(
                        value: 'Last Two Weeks', child: Text('Last Two Weeks')),
                    DropdownMenuItem(
                        value: 'Last One Month', child: Text('Last One Month')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTimeframe = value!;
                      adminOrdersController
                          .getAllOrders(_getDaysCount(selectedTimeframe));
                    });
                  },
                ),
                SizedBox(height: h * 0.02),
                Expanded(
                  child: Obx(() {
                    if (adminOrdersController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (adminOrdersController.allOrders.isEmpty) {
                      return const Center(
                        child: Text(
                          "No orders found",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: adminOrdersController.allOrders.length,
                      itemBuilder: (context, index) {
                        final order = adminOrdersController.allOrders[index];
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
                                offset: Offset(0, 3),
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
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  if (order['orderStatus'] != 1 &&
                                      order['orderStatus'] != 2) ...[
                                    Expanded(
                                      child: AppFilledButton(
                                        title: "Approve Now",
                                        buttonColor: Colors.green,
                                        textColor: whiteColor,
                                        borderColor: Colors.transparent,
                                        fontSize: 16,
                                        height: 24,
                                        onPressed: () async {
                                          await adminOrdersController
                                              .approveOrder(
                                            orderId: order['orderId'],
                                            orderStatus: 1,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8), // Spacer between the buttons
                                    Expanded(
                                      child: AppFilledButton(
                                        title: "Reject Now",
                                        buttonColor: Colors.red,
                                        borderColor: Colors.transparent,
                                        textColor: whiteColor,
                                        fontSize: 16,
                                        height: 24,
                                        onPressed: () async {
                                          adminOrdersController.approveOrder(
                                            orderId: order['orderId'],
                                            orderStatus: 2,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              )
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
