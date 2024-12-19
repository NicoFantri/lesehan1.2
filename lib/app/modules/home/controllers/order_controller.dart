import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;

  void addOrder(Map<String, dynamic> order) {
    orders.insert(0, order);
  }

  void editOrder(String orderId, double newTotal) {
    final index = orders.indexWhere((o) => o['id'] == orderId);
    if (index != -1) {
      orders[index]['total'] = newTotal;
    }
  }

  void cancelOrder(String orderId) {
    final index = orders.indexWhere((o) => o['id'] == orderId);
    if (index != -1) {
      orders[index]['status'] = 'Dibatalkan';
    }
  }
  // Di OrderController
  void updateOrderQuantity(String orderId, int quantity) {
    // Update quantity logic here
    // Contoh:
    final orderIndex = orders.indexWhere((order) => order['id'] == orderId);
    if (orderIndex != -1) {
      final updatedOrder = Map<String, dynamic>.from(orders[orderIndex]);
      updatedOrder['quantity'] = quantity;
      // Hitung ulang total berdasarkan quantity baru
      updatedOrder['total'] = quantity * updatedOrder['price'];
      orders[orderIndex] = updatedOrder;
      orders.refresh();
    }
  }
}