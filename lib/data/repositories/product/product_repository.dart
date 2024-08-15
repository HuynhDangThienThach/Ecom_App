import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store/utils/constants/enums.dart';

import '../../../features/shop/models/product_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async{
    try {
      final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).limit(4).get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get limited featured products
  Future<List<ProductModel>> getAllFeaturedProducts() async{
    try {
      final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Products based on the Brand
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async{
    try{
      // Thực hiện truy vấn và chờ kết quả
      final querySnapshot = await query.get();
      // Chuyển đổi kết quả truy vấn thành danh sách các đối tượng ProductModel
      final List<ProductModel> productList = querySnapshot.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();
      return productList;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Products based on the Brand
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async{
    try{
      // Thực hiện truy vấn và chờ kết quả
      final snapshot = await _db.collection('Products').where(FieldPath.documentId, whereIn: productIds).get();
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }


  /// Lấy sản phẩm cho brand
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async{
    try{
      final querySnapshot = limit == -1
          ? await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).get()
          : await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).limit(limit).get();
      final products = querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
      return products;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }

  /// Lấy sản phẩm cho category
  Future<List<ProductModel>> getProductsForCategory({required String categoryId, int limit = 4}) async{
    try{
      QuerySnapshot productCategoryQuery = limit == -1
          ? await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).get()
          : await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).limit(limit).get();

      // Trích xuất productIds từ tài liệu đã truy vấn ở trên.
      List<String> productIds = productCategoryQuery.docs.map((doc) => doc['productId'] as String ).toList();

      // Truy vấn để lấy tất cả các document có productId nằm trong danh sách productIds, FieldPath.documentId để truy vấn các document trong Product mà có trùng với productIds
      final productsQuery = await _db.collection('Products').where(FieldPath.documentId,whereIn: productIds).get();

      // Trích xuất tên sản phẩm hoặc dữ liệu liên quan khác từ tài liệu
      List<ProductModel> products = productsQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
      return products;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }


  /// Upload dummy data to the Cloud Firebase
  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      // Lấy đối tượng dịch vụ Fb
      final storage = Get.put(TFirebaseStorageService());
      // Lặp qua từng sp
      for (var product in products) {
        // Lấy dữ liệu từ local asset project
        final thumbnail = await storage.getImageDataFromAssets(product.thumbnail);
        // Tải hình ảnh lên firebase
        final url = await storage.uploadImageData('Products/Images', thumbnail, product.thumbnail.toString());
        // Nhận lại đường dẫn
        product.thumbnail = url;

        // Xử lý danh sách sản phẩm
        if (product.images != null && product.images!.isNotEmpty) {
          List<String> imagesUrl = [];
          for (var image in product.images!) {
            // Lấy dữ liệu từ local asset project
            final assetImage = await storage.getImageDataFromAssets(image);
            // Tải hình ảnh lên firebase
            final url = await storage.uploadImageData('Products/Images', assetImage, image);
            // Nhận lại đường dẫn
            imagesUrl.add(url);
          }
          product.images!.clear();
          product.images!.addAll(imagesUrl);
        }

        // Upload Variation Images
        if (product.productType == ProductType.variable.toString()) {
          for (var variation in product.productVariations!) {
            // Get image data link from local assets
            final assetImage = await storage.getImageDataFromAssets(variation.image);
            // Upload image and get its URL
            final url = await storage.uploadImageData('Products/Images', assetImage, variation.image);
            // Assign URL to variation.image attribute
            variation.image = url;
          }
        }

        // Store product in Firestore
        await _db.collection("Products").doc(product.id).set(product.toJson());
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}