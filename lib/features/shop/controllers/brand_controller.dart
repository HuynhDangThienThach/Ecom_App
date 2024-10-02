import 'package:get/get.dart';
import 'package:t_store/data/repositories/brands/brand_repository.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/brand_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/popups/loaders.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //--- Variables
  RxBool isLoading = true.obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featureBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  //--- Get FeaturedBrands
  Future<void> getFeaturedBrands() async {
    try{
     // Show loader while loading Brands
      isLoading.value = true;
     // get AllBrands
      final brands = await brandRepository.getAllBrands();
     // assign to properties
      allBrands.assignAll(brands);
      featureBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    }catch (e){
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  //--- Get Products For Brand (Associate Product for brand)
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async{
    try{
      final products = await ProductRepository.instance.getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    } catch(e){
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
      return [];
    }
  }

  //--- Get Brands for Category
  Future<List<BrandModel>> getBrandsCategory(String categoryId) async{
    try{
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch(e){
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
      return [];
    }
  }
}
