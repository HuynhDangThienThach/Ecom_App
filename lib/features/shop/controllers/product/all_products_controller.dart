import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  void fetchAllProducts() async {
    final allProducts = await repository.getAllFeaturedProducts();
    products.value = allProducts;
  }

  void searchProductByTitle(String title) async {
    final searchResults = await repository.fetchProductsByTitle(title);
    products.value = searchResults.isNotEmpty ? searchResults : [];
    if (searchResults.isEmpty) {
      TLoaders.errorSnackBar(title: 'Không có sản phẩm', message: 'Không tìm thấy sản phẩm nào với tên "$title".');
    }
  }

  void searchByImage({ImageSource source = ImageSource.camera}) async{
    var image = await ImagePicker().pickImage(source: source);

    if (image != null){
      final _image = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
          toolbarTitle: 'Điều chỉnh ảnh',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          ),
        ],
        maxHeight: 224,
        maxWidth: 224,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)

      );
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
