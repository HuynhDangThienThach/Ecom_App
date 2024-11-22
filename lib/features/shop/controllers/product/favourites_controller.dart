import 'dart:convert';

import 'package:get/get.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/local_storage/storage_utility.dart';
import 'package:t_store/utils/popups/loaders.dart';

class FavouritesController  extends GetxController {
  static FavouritesController get instance => Get.find();

  //--- Variables
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourite();
  }

  //--- Method initialize favourite by reading from storage
  Future<void> initFavourite() async {
    final json = TLocalStorage.instance().readData('favorites');

    if (json != null){
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  // --- Find productId in product to see if it is in wishlist
  bool isFavorite(String productId){
    return favorites[productId]?? false;
  }

  // --- Thêm hoặc xóa sản phẩm ra khỏi danh sách
  void toggleFavouriteProduct(String productId){
    if(!favorites.containsKey(productId)){
      favorites[productId] = true;
      saveFavouritesToStorage();
      TLoaders.customToast(message: 'Sản phẩm đã được thêm vào danh sách mong muốn');
    }else{
      TLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavouritesToStorage();
      favorites.refresh();
      TLoaders.customToast(message: 'Sản phẩm đã được xóa khỏi danh sách mong muốn');
    }
  }

  void saveFavouritesToStorage(){
    final encodedFavorites = json.encode(favorites);
    TLocalStorage.instance().saveData('favorites', encodedFavorites);
  }
  // Lấy các sản phẩm yêu thích từ kho dữ liệu
  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance.getFavouriteProducts(favorites.keys.toList());
  }

}
