// import '../../features/shop/models/cart_model.dart';

class TPricingCalculator {
  /// Tính toán giá tổng cộng dựa trên thuế và phí vận chuyển
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return double.parse(totalPrice.toStringAsFixed(2));
  }

  /// Tính toán chi phí vận chuyển
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  /// Tính toán thuế
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  /// Lấy tỷ lệ thuế cho vị trí cụ thể
  static double getTaxRateForLocation(String location) {
    // Tra cứu tỷ lệ thuế cho vị trí nhất định từ cơ sở dữ liệu hoặc API.
    // Trả về tỷ lệ thuế phù hợp.
    return 0.10; // Ví dụ tỷ lệ thuế là 10%
  }

  /// Lấy chi phí vận chuyển cho vị trí cụ thể
  static double getShippingCost(String location) {
    // Tra cứu chi phí vận chuyển cho vị trí nhất định bằng cách sử dụng API vận chuyển.
    // Tính toán chi phí vận chuyển dựa trên các yếu tố như khoảng cách, trọng lượng, v.v.
    return 5.00; // Ví dụ chi phí vận chuyển là $5
  }

  /// Tính tổng giá của tất cả các mặt hàng trong giỏ hàng và trả về tổng số tiền
  // static double calculateCartTotal(CartModel cart) {
  //   return cart.items.map((e) => e.price).fold(0,
  //       (previousPrice, currentPrice) => previousPrice + (currentPrice ?? 0));
  // }
}
