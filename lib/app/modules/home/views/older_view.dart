import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lesehan/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'notificationview.dart';


class OlderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) =>
                  SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
              children: [
                SizedBox(height: 20),
                _buildOrderDetails(),
                SizedBox(height: 20),
                _buildDiscountBanner(),
                SizedBox(height: 20),
                _buildOrderItems(),
                SizedBox(height: 20),
                _buildAddMoreItems(),
                SizedBox(height: 20),
                _buildPaymentMethod(),
                SizedBox(height: 20),
                _buildPriceSummary(),
                SizedBox(height: 30),
                _buildOrderButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: _buildBackIcon(),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Detail Pesanan",
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22, // Adjusted font size for better balance
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBackIcon() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.arrow_back, color: AppColors.primary),
    );
  }

  Widget _buildOrderDetails() {
    // Mendapatkan waktu sekarang
    final now = DateTime.now();
    // Format tanggal menjadi string, misalnya "Hari, DD Bulan YYYY"
    final dateFormatter = DateFormat('dd MMMM yyyy');
    final formattedDate = dateFormatter.format(now);
    // Format jam menjadi string, misalnya "HH:mm"
    final timeFormatter = DateFormat('HH:mm');
    final formattedTime = timeFormatter.format(now);

    return CustomCard(
      padding: EdgeInsets.all(16), // Added padding for consistency
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Pesanan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildOrderDetailRow("ID Pesanan", "FDS-2983-3787-FFV"),
          SizedBox(height: 8),
          _buildOrderDetailRow("Tanggal", "$formattedDate, $formattedTime"), // Menggunakan waktu sekarang
        ],
      ),
    );
  }


  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountBanner() {
    final controller = Get.find<HomeController>();

    return Obx(() {
      bool isCouponApplied = controller.discountAmount.value > 0;
      // Get the discount percentage from the amount
      int discountPercentage = isCouponApplied
          ? ((controller.discountAmount.value / controller.totalAmount.value) * 100).round()
          : 0;

      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIconContainer(Icons.local_offer, Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCouponApplied
                        ? "Diskon ${discountPercentage}% Diterapkan"
                        : "Voucher Tersedia",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isCouponApplied
                        ? "Hemat Rp ${controller.discountAmount.value.toStringAsFixed(0)}"
                        : "Klik untuk menggunakan voucher",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isCouponApplied) {
                  // Remove the coupon
                  controller.removeCoupon();
                } else {
                  // Navigate to notifications/voucher view
                  Get.to(() => NotificationView());
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCouponApplied ? "Hapus" : "Gunakan",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildUseButton() {
    final controller = Get.find<HomeController>();

    return GestureDetector(
      onTap: () {
        // Use GetX snackbar directly
        Get.snackbar(
          'Diskon Berhasil',
          'Diskon 30% telah diterapkan pada pesanan Anda',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          icon: Icon(
            Icons.local_offer,
            color: Colors.white,
            size: 28,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Gunakan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    final controller = Get.find<HomeController>();

    return Obx(() =>
        CustomCard(
          child: Column(
            children: controller.orderItems.map((item) =>
                _buildOrderItem(
                  image: item.foodItem.image,
                  name: item.foodItem.name,
                  price: item.foodItem.price,
                  quantity: item.quantity,
                  onIncrease: () => controller.addToCart(item.foodItem),
                  onDecrease: () => controller.removeFromCart(item),
                )).toList(),
          ),
        ));
  }

  Widget _buildOrderItem({
    required String image,
    required String name,
    required double price,
    required int quantity,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildItemImage(image),
          SizedBox(width: 16),
          Expanded(child: _buildItemDetails(name, price)), // Remove the type cast
          _buildQuantityControl(quantity, onIncrease, onDecrease),
        ],
      ),
    );
  }

  Widget _buildItemImage(String image) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildItemDetails(String name, double price) { // Change parameter type to double
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Rp ${price.toStringAsFixed(0)}", // This will properly handle double prices
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponButton(HomeController controller, bool isCouponApplied) {
    return GestureDetector(
      onTap: () {
        if (!isCouponApplied) {
          // Apply discount
          controller.applyCoupon();
        } else {
          // Remove discount
          controller.removeCoupon();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isCouponApplied ? "Hapus" : "Gunakan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  Widget _buildQuantityControl(int quantity,
      VoidCallback onIncrease,
      VoidCallback onDecrease,) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: AppColors.primary),
            onPressed: onDecrease,
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: onIncrease,
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }


  Widget _buildAddMoreItems() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mau tambah pesanan?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8), // Space between question and description
            Text(
              "Kamu masih bisa tambah makanan lain ya",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 12), // Space before the button
            _buildAddMenuButton(),
          ],
        ),
      ),
    );
  }


  Widget _buildAddMenuButton() {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          // Navigate back to the home screen or menu selection
          Get.back();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: AppColors.secondary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Tambah Menu",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Metode Pembayaran",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            _buildPaymentOption("Dana", Icons.payment),
            SizedBox(height: 12),
            _buildPaymentOption("ShopeePay", Icons.shopping_cart),
            SizedBox(height: 12),
            _buildPaymentOption("QRIS", Icons.qr_code),
            SizedBox(height: 12),
            Divider(color: AppColors.dividerColor),
            SizedBox(height: 12),
            Text(
              "Pilihan pembayaran yang aman dan terpercaya.",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Use GetX snackbar directly
        Get.snackbar(
          'Metode Pembayaran',
          '$title dipilih sebagai metode pembayaran',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue.withOpacity(0.9),
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          icon: Icon(
            Icons.payment,
            color: Colors.white,
            size: 28,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.iconColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppColors.iconColor),
          ],
        ),
      ),
    );
  }


  Widget _buildPriceSummary() {
    final controller = Get.find<HomeController>();

    return Obx(() =>
        CustomCard(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryRow(
                  "Subtotal",
                  "Rp ${controller.totalAmount.value.toStringAsFixed(0)}"
              ),
              SizedBox(height: 8),
              _buildSummaryRow(
                  "Diskon",
                  "- Rp ${controller.discountAmount.value.toStringAsFixed(0)}"
              ),
              SizedBox(height: 8),
              Divider(color: AppColors.textSecondary.withOpacity(0.5)),
              SizedBox(height: 8),
              _buildSummaryRow(
                  "Total",
                  "Rp ${(controller.totalAmount.value -
                      controller.discountAmount.value).toStringAsFixed(0)}",
                  isTotal: true
              ),
            ],
          ),
        ));
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton() {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Pesan Sekarang",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}