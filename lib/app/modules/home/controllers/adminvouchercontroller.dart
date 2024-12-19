import 'package:get/get.dart';
import '../models/voucher.dart';

class VoucherController extends GetxController {
  final vouchers = <Voucher>[].obs;

  void addVoucher(Voucher voucher) {
    vouchers.add(voucher);
  }

  void updateVoucher(Voucher oldVoucher, Voucher newVoucher) {
    final index = vouchers.indexOf(oldVoucher);
    if (index != -1) {
      vouchers[index] = newVoucher;
    }
  }

  void deleteVoucher(Voucher voucher) {
    vouchers.remove(voucher);
  }
}