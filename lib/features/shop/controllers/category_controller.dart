import 'package:get/get.dart';
import 'package:t_store/data/repositories/categories/category_repository.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/popups/loaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  //--- Variables
  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  // RxList sẽ tự đông cập nhật khi có sự thay đổi trong danh sách
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit(){
    fetchCategories();
    super.onInit();
  }

  //--- Load category data
  Future<void> fetchCategories() async {
    try{
      // Hiển thị loader khi cập nhật
      isLoading.value = true;
      // Lấy loại hàng từ Fb
      final categories = await _categoryRepository.getAllCategories();
      // Cập nhật danh sách loại hàng
      allCategories.assignAll(categories);
      // Bộ lọc các loại hàng đặt trưng
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(7).toList());
    }catch (e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  } finally {
      // Remove Loader
      isLoading.value = false;
    }
  }

  // Get Sub category Product
  Future<List<CategoryModel>> getSubCategory(String categoryId) async{
    try{
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }


  // Get Product Category from database
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async{
    // Nạp tối đa là 4 sản phẩm theo từng danh mục
    final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit:limit);
    return products;
  }
}
