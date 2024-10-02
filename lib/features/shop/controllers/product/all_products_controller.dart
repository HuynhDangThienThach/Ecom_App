import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store/utils/popups/loaders.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  //--- Variables
  final repository = ProductRepository.instance;
  // --- Default is 'Name'
  final RxString selectedSortOption = 'Name'.obs;
  //--- Change obs for every time search product
  final RxList<ProductModel> products = <ProductModel>[].obs;

  //--- Functions
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try{
      if(query == null) return [];

      final products = await repository.fetchProductsByQuery(query);

      return products;
    } catch(e){
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
      return [];
    }
  }

  void sortProducts (String sortOption){
    selectedSortOption.value = sortOption;

    switch(sortOption){
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0){
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0 ){
            return -1;
          } else{
            return 1;
          }
        });
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Popularity':
        products.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      default:
      // Default sorting option: Name
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }
  void assignProducts(List<ProductModel> products){
    // assign products to the 'products' list
    this.products.assignAll(products);
    sortProducts('Name');
  }

}