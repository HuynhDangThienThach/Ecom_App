import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/utils/constants/enums.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> superDiscountProducts = <ProductModel>[].obs;
  RxList<ProductModel> topSalesProducts = <ProductModel>[].obs;
  RxList<ProductModel> newProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    getSuperDiscountProducts();
    getTopSalesProducts();
    getNewProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;
      // Fetch Products
      final products = await productRepository.getFeaturedProducts();
      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-- Lấy sản phẩm có top discount
  void getSuperDiscountProducts() async {
    try {
      isLoading.value = true;

      // Fetch all featured products from the repository
      final products = await productRepository.getFeaturedProducts();

      // Lọc sản phẩm có giảm giá hơn 50%
      final discountedProducts = products.where((product) {
        if (product.salePrice > 0) {
          final discountPercentage = calculateSalePercentage(product.price, product.salePrice);
          if (discountPercentage != null) {
            return double.parse(discountPercentage) >= 50;
          }
        }
        return false;
      }).toList();

      // Assign filtered products
      superDiscountProducts.assignAll(discountedProducts);

    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!',
          message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-- Lấy sản phẩm bán chạy toàn quốc
  void getTopSalesProducts() async {
    try {
      isLoading.value = true;

      // Fetch all featured products from the repository
      final products = await productRepository.getStockProducts();

      topSalesProducts.assignAll(products);

    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!',
          message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-- Lấy sản phẩm mới
  void getNewProducts() async {
    try {
      isLoading.value = true;

      // Fetch all featured products from the repository
      final products = await productRepository.getNewProducts();

      newProducts.assignAll(products);

    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!',
          message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // Fetch Products
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
      return [];
    }
  }

  /// Lấy giá sản phẩm hoặc xếp hạng sản phẩm
  String getProductPrice(ProductModel product){
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;
    final formatCurrency = NumberFormat('#,##0');

    // Nếu có 1 loại sản phẩm, trả về giá cơ bản, hoặc giảm giá
    if(product.productType == ProductType.single.toString()){
      return '${formatCurrency.format(product.salePrice > 0 ? product.salePrice : product.price)}đ';
    } else{
      for(var variation in product.productVariations!){
        // Nếu variation.salePrice > 0 trả về variation.salePrice ngược lại trả về variation.price
        double priceToConsider = variation.salePrice > 0.0? variation.salePrice : variation.price;

        // Cập nhật giá nhỏ nhất và lớn nhất
        if(priceToConsider < smallestPrice){
          smallestPrice = priceToConsider;
        }

        if(priceToConsider > largestPrice){
          largestPrice = priceToConsider;
        }
      }
      // Nếu smallestPrice và largestPrice bằng nhau thì trả về 1
      if(smallestPrice.isEqual(largestPrice)){
        return largestPrice.toString();
      }else{
        // Nếu smallestPrice và largestPrice khác nhau  trả về cả 2
        return '${formatCurrency.format(smallestPrice)}đ - ${formatCurrency.format(largestPrice)}đ';

      }
    }
  }

  /// Tính phần trăm giá khuyến mãi
  String? calculateSalePercentage(double originalPrice, double? salePrice){
    if (salePrice == null || salePrice <=0) return null;

    if(originalPrice <=0) return null;

    double percentage = (originalPrice - salePrice) / originalPrice * 100;
    return percentage.toStringAsFixed(0);
  }

  /// Kiểm tra trạng thái hàng trong kho
  String getProductStockStatus(int stock){
    return stock > 0 ? 'Còn hàng' : 'Hết hàng';
  }
}