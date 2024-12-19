class Voucher {
  final String code;
  final double discountPercent;
  final double maxDiscount;
  final double minPurchase;
  final int quota;
  final DateTime validUntil;

  Voucher({
    required this.code,
    required this.discountPercent,
    required this.maxDiscount,
    required this.minPurchase,
    required this.quota,
    required this.validUntil,
  });
}