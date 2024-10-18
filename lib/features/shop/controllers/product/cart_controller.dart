import 'package:get/get.dart';
import 'package:t_store/features/shop/controllers/product/variation_controller.dart';
import 'package:t_store/features/shop/models/cart_item_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constants/enums.dart';
import 'package:t_store/utils/local_storage/storage_utility.dart';
import 'package:t_store/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  //--- Variables
  /// Save cartitem
  RxInt noOfCartItem = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;

  CartController(){
    loadCartItems();
  }


// Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product) {
    if (!_isProductValidForCart(product)) return;

    final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == selectedCartItem.productId && cartItem.variationId == selectedCartItem.variationId);

    // Kiểm tra sản phẩm trong giỏ hàng
    if (index >= 0) {
      // Cập nhật số lượng
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: "Sản phẩm đã thêm vào giỏ hàng");
  }

// Mua ngay sản phẩm
  void buyNow(ProductModel product) {
    if (!_isProductValidForCart(product)) return;

    final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);
    final List<CartItemModel> tempCartItems = [selectedCartItem];

    Get.toNamed('/checkout', arguments: tempCartItems);
  }

  // Kiểm tra tính hợp lệ của sản phẩm
  bool _isProductValidForCart(ProductModel product) {
    if (productQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Chọn số lượng');
      return false;
    }

    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      TLoaders.customToast(message: 'Chọn biến thể');
      return false;
    }

    if (product.productType == ProductType.single.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      TLoaders.customToast(message: 'Chọn biến thể');
      return false;
    }

    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.stock < 1) {
      TLoaders.warningSnackBar(message: "Biến thể đã chọn đã hết hàng.", title: 'Chà, thật đáng tiếc!');
      return false;
    } else if (product.stock < 1) {
      TLoaders.warningSnackBar(message: 'Sản phẩm đã chọn hiện hết hàng', title: 'Chà, thật đáng tiếc!');
      return false;
    }

    if (product.productType == ProductType.single.toString() &&
        variationController.selectedVariation.value.stock < 1) {
      TLoaders.warningSnackBar(message: "Biến thể đã chọn đã hết hàng.", title: 'Chà, thật đáng tiếc!');
      return false;
    } else if (product.stock < 1) {
      TLoaders.warningSnackBar(message: 'Sản phẩm đã chọn hiện hết hàng', title: 'Chà, thật đáng tiếc!');
      return false;
    }

    return true;
  }

  void addOneToCart(CartItemModel item){
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId && cartItem.variationId == item.variationId);
    if (index >=0){
      cartItems[index].quantity += 1;
    } else{
      cartItems.add(item);
    }
    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId && cartItem.variationId == item.variationId);

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        // Giảm số lượng sản phẩm
        cartItems[index].quantity -= 1;
      } else {
        // Xóa sản phẩm nếu số lượng bằng 1
        removeFromCartDialog(index);
      }
    } else {
      // Xử lý nếu không tìm thấy sản phẩm trong giỏ hàng
      print('Sản phẩm không được tìm thấy!');
    }

    updateCart();
  }

  void removeFromCartDialog(int index){
    Get.defaultDialog(
      title: 'Xóa sản phẩm',
      middleText: 'Bạn có chắc sẽ xóa sản phẩm khỏi giỏ hàng',
      onConfirm: (){
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Sản phẩm đã được xóa khỏi giỏ hàng');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  // Khởi tạo đã thêm số lương sản phẩm vào giỏ hàng
  void updateAlreadyAddedProductCount(ProductModel product){
    // Nếu sản phẩm không có biến thể thì tính toán CartEntries và hiển thị tổng số.
    // Ngược lại đặt các mục nhập mặc đinh thành 6 và hiển thị CartEntries khi biến thể được chọn
    if (product.productType == ProductType.single.toString()){
      productQuantityInCart.value == getProductQuantityInCart(product.id);
    } else {
      final variationId = variationController.selectedVariation.value.id;
      if(variationId.isNotEmpty){
        productQuantityInCart.value = getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }



  // This function converts a ProductModel to a CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity){
    if (product.productType == ProductType.single.toString()){
      // Reset variation in case product single
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.id.isNotEmpty;
    final price = isVariation
        ? variation.salePrice > 0.0
          ? variation.salePrice
          : variation.price
        : product.salePrice > 0.0
          ? product.salePrice
          : product.price;

    return CartItemModel(
      productId: product.id,
      title: product.title,
      price: price,
      quantity: quantity,
      variationId: variation.id,
      image: isVariation ? variation.image : product.thumbnail,
      brandName: product.brand != null ? product.brand!.name : '',
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  /// Update Cart Values
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals(){
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems){
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItem.value = calculatedNoOfItems;
  }

  void saveCartItems(){
    final cartItemString = cartItems.map((item) => item.toJson()).toList();
    TLocalStorage.instance().writeData('cartItems', cartItemString);
  }

  void loadCartItems(){
    final cartItemStrings = TLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null){
      cartItems.assignAll(cartItemStrings.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId){
    final foundItem = cartItems.where((item) => item.productId == productId).fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId){
    final foundItem = cartItems.firstWhere((item) => item.productId == productId && item.variationId == variationId, orElse: () => CartItemModel.empty());
    return foundItem.quantity;
  }

  void clearCart(){
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
