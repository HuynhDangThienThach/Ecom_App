
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/cateFeature_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloud_storage/firebase_storage_service.dart';

class CatefeatureRepository extends GetxController {
  static CatefeatureRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;


  //--- Get all categories
  Future<List<CatefeatureModel>> getAllCategories() async {
    try{
      final snapshot = await _db.collection('CateFeature').where("IsFeatured", isEqualTo: true).get();
      final list = snapshot.docs.map((document) => CatefeatureModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Something went wrong. Please try again';
    }
  }
}