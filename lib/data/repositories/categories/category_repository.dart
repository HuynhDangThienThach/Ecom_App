
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;


  //--- Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try{
      final snapshot = await _db.collection('Categories').get();
      final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }

  //--- Get Sub Categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try{
      final snapshot = await _db.collection("Categories").where('ParentId', isEqualTo: categoryId).get();
      final result = snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e){
      throw ' Something went wrong. Please try again';
    }
  }


  //--- Upload Categories to the Cloud Firebase
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try{
      // Tạo biến để dùng các phương thức.
      final storage = Get.put(TFirebaseStorageService());

      // Lặp qua từng đối tượng của categoryModel
      for(var category in categories){
        // Tải dữ liệu hình ảnh từ cục bộ.
        final file = await storage.getImageDataFromAssets(category.image);

        // Tải hình ảnh lên Fbase Storage từ dữ liệu ảnh cục bộ
        final url = await storage.uploadImageData('Categories', file, category.name);

        // Cập nhật trong CategoryModel
        category.image = url;

        // Store Category in Firestore
        await _db.collection("Categories").doc(category.id).set(category.toJson());
      }
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TFirebaseException(e.code).message;
    } catch (e){
      throw ' Something went wrong. Please try again';
    }
  }

}