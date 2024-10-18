import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store/features/shop/models/brand_model.dart';
import 'package:t_store/utils/exceptions/format_exceptions.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;

  //--- Get all Brands
  Future<List<BrandModel>> getAllBrands() async {
    try{
      final snapshot = await _db.collection('Brands').get();
      final result = snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong while fetching Banners.';
    }
  }

  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async{
    try{
      // Truy vấn để lấy tất cả các tài liệu trong đó 'categoryId' khớp với categoryId được cung cấp
      QuerySnapshot brandCategoryQuery = await _db.collection("BrandCategory").where('categoryId', isEqualTo: categoryId).get();

      // Trích xuất brandIds từ tài liệu đã truy vấn ở trên.
      List<String> brandIds = brandCategoryQuery.docs.map((doc) => doc['brandId'] as String).toList();

      // Truy vấn để lấy tất cả các document có brandId nằm trong danh sách brandIds, FieldPath.documentId để truy vấn các document trong Brands mà có trùng với brandIds
        final brandsQuery = await _db.collection('Brands').where(FieldPath.documentId, whereIn: brandIds).limit(2).get();

      // Trích xuất tên thương hiệu hoặc dữ liệu liên quan khác từ tài liệu
      List<BrandModel> brands = brandsQuery.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
      return brands;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong while fetching Banners.';
    }
  }
}