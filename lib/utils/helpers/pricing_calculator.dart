// import '../../features/shop/models/cart_model.dart';

import 'package:intl/intl.dart';

class TPricingCalculator {
  /// Tính toán giá tổng cộng dựa trên thuế và phí vận chuyển
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }


  /// Tính toán chi phí vận chuyển
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return '${NumberFormat('#,##0').format(shippingCost)}đ';
  }


  /// Tính toán thuế
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return '${NumberFormat('#,##0').format(taxAmount)}đ';
  }

  /// Lấy tỷ lệ thuế cho vị trí cụ thể
  static double getTaxRateForLocation(String location) {
    return 0.01;
  }

  /// Lấy chi phí vận chuyển cho vị trí cụ thể
  static double getShippingCost(String location) {
    return 10000;
  }

  /// Tính tổng giá của tất cả các mặt hàng trong giỏ hàng và trả về tổng số tiền
  // static double calculateCartTotal(CartModel cart) {
  //   return cart.items.map((e) => e.price).fold(0,
  //       (previousPrice, currentPrice) => previousPrice + (currentPrice ?? 0));
  // }
}
