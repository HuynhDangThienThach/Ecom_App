import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:t_store/features/shop/models/product_model.dart';


class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  //--- Variables
  RxString selectedProductImage = ''.obs;


  // Lấy tất cả ảnh từ sản phẩm và biến thể
  List<String> getAllProductImages(ProductModel product) {
    // Sử dụng Set để thêm ảnh
    Set<String> images = {};

    // Cập nhật ảnh đại diện
    images.add(product.thumbnail);

    // Gán ảnh đại diện với selected image
    selectedProductImage.value = product.thumbnail;

    // Lấy tất cả ảnh từ Product Model nếu không null
    if (product.images != null) {
      images.addAll(product.images!);
    }

    // Lấy tất cả ảnh từ Product Variations nếu không null
    if (product.productVariations != null || product.productVariations!.isNotEmpty) {
      images.addAll(product.productVariations!.map((variation) => variation.image));
    }
    return images.toList();
  }

  // Show image Popup
  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
          () => Dialog.fullscreen(
        child: Stack(
          children: [
            Center(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(image),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}