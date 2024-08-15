import 'package:get/get.dart';
import 'package:t_store/utils/constants/enums.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
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
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Lấy giá sản phẩm hoặc xếp hạng sản phẩm
  String getProductPrice(ProductModel product){
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // Nếu không có sp tồn tại, trả về giá cơ bản, hoặc giảm giá
    if(product.productType == ProductType.single.toString()){
      return (product.salePrice > 0 ? product.salePrice : product.price).toString();
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
        return '$smallestPrice - \$$largestPrice';

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
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}