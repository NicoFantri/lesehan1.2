import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/order_controller.dart';
import '../theme/app_colors.dart';
import '../models/food_item.dart';
import 'vocher_admin_view.dart';

class AdminDashboardView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final OrderController orderController = Get.put(OrderController());
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  // Expense tracking
  final RxList<Map<String, dynamic>> expenses = <Map<String, dynamic>>[].obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble totalExpenses = 0.0.obs;

  // Constructor with automatic expense tracking
  AdminDashboardView() {
    // Listen to orders and automatically create expenses
    ever(orderController.orders, (List<Map<String, dynamic>> orders) {
      _processOrderExpenses(orders);
    });
  }

  // Process orders and create corresponding expenses
  void _processOrderExpenses(List<Map<String, dynamic>> orders) {
    for (var order in orders) {
      if (order['processed'] != true) { // Check if order hasn't been processed
        // Calculate raw materials cost (30% of order total)
        double rawMaterialsCost = (order['total'] as double) * 0.3;

        // Add expense for raw materials
        expenses.add({
          'date': order['date'],
          'category': 'Bahan Baku',
          'amount': rawMaterialsCost,
          'description': 'Bahan baku untuk pesanan ${order['id']}',
          'orderId': order['id']
        });

        // Add operational cost (10% of order total)
        double operationalCost = (order['total'] as double) * 0.1;
        expenses.add({
          'date': order['date'],
          'category': 'Operasional',
          'amount': operationalCost,
          'description': 'Biaya operasional pesanan ${order['id']}',
          'orderId': order['id']
        });

        // Update the order to mark it as processed
        order['processed'] = true;

        // Update total calculations
        totalRevenue.value += order['total'] as double;
        totalExpenses.value += (rawMaterialsCost + operationalCost);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.local_offer),
            onPressed: () => Get.to(() => AdminVoucherView()),
            tooltip: 'Kelola Voucher',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFinancialSummary(),
            _buildExpensesList(),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Keuangan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Pendapatan',
                  totalRevenue.value,
                  Icons.trending_up,
                  AppColors.primary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Pengeluaran',
                  totalExpenses.value,
                  Icons.trending_down,
                  Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildProfitCard(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Rp ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCard() {
    final profit = totalRevenue.value - totalExpenses.value;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keuntungan Bersih',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Rp ${profit.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Pengeluaran',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(
                      expense['category'] == 'Bahan Baku'
                          ? Icons.restaurant
                          : Icons.build,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    expense['category'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(expense['description']),
                      Text(
                        'Order ID: ${expense['orderId']}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    'Rp ${(expense['amount'] as double).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Menu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.popularItems.length,
            itemBuilder: (context, index) {
              final item = controller.popularItems[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Image.asset(item.image, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.primary),
                        onPressed: () => _showEditDialog(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(FoodItem item) {
    _nameController.text = item.name;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toString();
    _imageController.text = item.image;

    Get.defaultDialog(
      title: 'Edit Food Item',
      content: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Item Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(hintText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(hintText: 'Image Path'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            final index = controller.popularItems.indexOf(item);
            controller.popularItems[index] = FoodItem(
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              image: _imageController.text,
            );
            Get.back();
            _clearControllers();
          },
        ),
      ],
    );
  }

  void _deleteItem(FoodItem item) {
    controller.popularItems.remove(item);
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageController.clear();
  }
}