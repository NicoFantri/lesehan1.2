import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/adminvouchercontroller.dart';
import '../theme/app_colors.dart';
import '../models/voucher.dart';

class AdminVoucherView extends StatelessWidget {
  final VoucherController controller = Get.put(VoucherController());
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _validUntilController = TextEditingController();
  final _quotaController = TextEditingController();
  final _minPurchaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher Management'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.vouchers.length,
              itemBuilder: (context, index) {
                final voucher = controller.vouchers[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${voucher.code} - ${voucher.discountPercent}% OFF',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Max Discount: Rp ${voucher.maxDiscount.toStringAsFixed(0)}'),
                        Text('Min Purchase: Rp ${voucher.minPurchase.toStringAsFixed(0)}'),
                        Text('Valid Until: ${voucher.validUntil.toString().split(' ')[0]}'),
                        Text('Remaining Quota: ${voucher.quota}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(voucher),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteVoucher(voucher),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _showAddVoucherDialog,
              child: Text('Add New Voucher'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVoucherDialog() {
    Get.defaultDialog(
      title: 'Add New Voucher',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                  labelText: 'Voucher Code',
                  hintText: 'e.g., SUMMER50'
              ),
            ),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(
                  labelText: 'Discount Percentage',
                  hintText: 'e.g., 50'
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _maxDiscountController,
              decoration: InputDecoration(
                  labelText: 'Maximum Discount (Rp)',
                  hintText: 'e.g., 100000'
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minPurchaseController,
              decoration: InputDecoration(
                  labelText: 'Minimum Purchase (Rp)',
                  hintText: 'e.g., 200000'
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quotaController,
              decoration: InputDecoration(
                  labelText: 'Voucher Quota',
                  hintText: 'e.g., 100'
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _validUntilController,
              decoration: InputDecoration(
                  labelText: 'Valid Until',
                  hintText: 'YYYY-MM-DD'
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now().add(Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  _validUntilController.text = date.toString().split(' ')[0];
                }
              },
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            final newVoucher = Voucher(
              code: _codeController.text,
              discountPercent: double.parse(_discountController.text),
              maxDiscount: double.parse(_maxDiscountController.text),
              minPurchase: double.parse(_minPurchaseController.text),
              quota: int.parse(_quotaController.text),
              validUntil: DateTime.parse(_validUntilController.text),
            );
            controller.addVoucher(newVoucher);
            Get.back();
            _clearControllers();
          },
        ),
      ],
    );
  }

  void _showEditDialog(Voucher voucher) {
    _codeController.text = voucher.code;
    _discountController.text = voucher.discountPercent.toString();
    _maxDiscountController.text = voucher.maxDiscount.toString();
    _minPurchaseController.text = voucher.minPurchase.toString();
    _quotaController.text = voucher.quota.toString();
    _validUntilController.text = voucher.validUntil.toString().split(' ')[0];

    Get.defaultDialog(
      title: 'Edit Voucher',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Voucher Code'),
            ),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(labelText: 'Discount Percentage'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _maxDiscountController,
              decoration: InputDecoration(labelText: 'Maximum Discount (Rp)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minPurchaseController,
              decoration: InputDecoration(labelText: 'Minimum Purchase (Rp)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quotaController,
              decoration: InputDecoration(labelText: 'Voucher Quota'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _validUntilController,
              decoration: InputDecoration(labelText: 'Valid Until'),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: voucher.validUntil,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  _validUntilController.text = date.toString().split(' ')[0];
                }
              },
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            final updatedVoucher = Voucher(
              code: _codeController.text,
              discountPercent: double.parse(_discountController.text),
              maxDiscount: double.parse(_maxDiscountController.text),
              minPurchase: double.parse(_minPurchaseController.text),
              quota: int.parse(_quotaController.text),
              validUntil: DateTime.parse(_validUntilController.text),
            );
            controller.updateVoucher(voucher, updatedVoucher);
            Get.back();
            _clearControllers();
          },
        ),
      ],
    );
  }

  void _deleteVoucher(Voucher voucher) {
    Get.defaultDialog(
      title: 'Delete Voucher',
      middleText: 'Are you sure you want to delete this voucher?',
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            controller.deleteVoucher(voucher);
            Get.back();
          },
        ),
      ],
    );
  }

  void _clearControllers() {
    _codeController.clear();
    _discountController.clear();
    _maxDiscountController.clear();
    _minPurchaseController.clear();
    _quotaController.clear();
    _validUntilController.clear();
  }
}