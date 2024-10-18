import 'package:get/get.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';
import 'package:t_store/features/shop/controllers/product/images_controller.dart';
import '../../models/product_model.dart';
import '../../models/product_variation_model.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;

  // Chọn thuộc tính và cập nhật
  void onAttributeSelected(ProductModel product, attributeName, attributeValue) {
    // Khi thuộc tính được chọn chúng ta phải thêm nó vào biến được chọn
    final selectedAttributes = Map<String, dynamic>.from(this.selectedAttributes);
    // Xác định giá trị được chọn
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;
    
    // Tạo biến để lặp các giá trị trong productVariations để xác định xem có trùng không?
    final selectedVariation = product.productVariations!.firstWhere((variation) => _isSameAttributesValues(variation.attributeValues, selectedAttributes),
      orElse: () => ProductVariationModel.empty(),
    );

    // Hiển thị hình ảnh của Variation đã chọn
    if(selectedVariation.image.isNotEmpty){
      ImagesController.instance.selectedProductImage.value = selectedVariation.image;
    }

    // Hiển thị số lượng của Variation đã chọn thêm vào giỏ hàng
    if(selectedVariation.image.isNotEmpty){
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value = cartController.getVariationQuantityInCart(product.id, selectedVariation.id);
    }

    // Gán Selected Variation
    this.selectedVariation.value = selectedVariation;

    // Cập nhật trạng thái sản phẩm variation được chọn
    getProductVariationStockStatus();
  }

  // Kiểm tra xem thuộc tính được chọn có trung với thuộc tính attributes không?
  bool _isSameAttributesValues(Map<String, dynamic> variationAttributes, Map<String, dynamic> selectedAttributes){
    // Độ dài 2 biến khác nhau thì trả về false
    if(variationAttributes.length != selectedAttributes.length) return false;

    // Kiểm tra giá trị của 2 biến, nếu khác nhau thì trả về false và ngược lại
    for(final key in variationAttributes.keys){
      //// Key: green, small, cotton etc
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }
    return true;
  }

  // Kiểm tra thuộc tính có còn khả dụng hay không (loại sản phẩm còn hay hết)
  Set<String?> getAttributesAvailabilityInVariation(List<ProductVariationModel> variations, String attributeName) {
    // Lấy hết các thuộc tính của variations kiểm tra
    final availableVariationAttributeValues = variations.where((variation) =>
      // Kiểm tra key rỗng hay Hết hàng không
      variation.attributeValues[attributeName] != null && variation.attributeValues[attributeName]!.isNotEmpty && variation.stock > 0)
      // Nạp tất cả các thuộc tính không rỗng
      .map((variation) => variation.attributeValues[attributeName]).toSet();
    return availableVariationAttributeValues;
  }

  // Nhận variation price
  int getVariationPrice() {
    return (selectedVariation.value.salePrice > 0 ? selectedVariation.value.salePrice : selectedVariation.value.price).toInt();
  }


  // Check Product Variation Stock Status
  void getProductVariationStockStatus() {
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'Còn hàng' : 'Hết hàng';
  }

  // Reset Selected Attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
