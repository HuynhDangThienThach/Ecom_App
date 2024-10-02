import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/banner_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;
  //--- Get all order related to current User
  Future<List<BannerModel>> fetchBanners() async {
    try{
      // --- Láy các banner có active là true ở fbase
      final result = await _db.collection('Banners').where('Active', isEqualTo: true).get();
      // Chuyển đổi thành danh sách đối tượng thông qua fromSnapshot
      return result.docs.map((documentSnapshot) => BannerModel.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }
}