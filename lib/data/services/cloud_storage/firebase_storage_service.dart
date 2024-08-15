import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TFirebaseStorageService extends GetxController{
  static TFirebaseStorageService get instance => Get.find();

  final _firebaseStorage = FirebaseStorage.instance;

  /// Upload Local Assets from Ide
  /// Tải dữ liệu hình ảnh cục bộ trong dự án.
  Future<Uint8List> getImageDataFromAssets(String path) async{
    try{
      final byteData = await rootBundle.load(path);
      final imageData = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return imageData;
    } catch (e){
      // Handle exceptions gracefully
      throw 'Error loading image data: $e';
    }
  }
  /// Upload Image using ImageData on Cloud Firebase Storage
  /// Tải dử liệu lên Fbase và trả về đường dẫn URL
  Future<String> uploadImageData(String path, Uint8List image, String name) async{
    try{
      final ref = _firebaseStorage.ref(path).child(name);
      await ref.putData(image);
      final url = await ref.getDownloadURL();
      return  url;
    } catch (e){
      // Handle exceptions gracefully
      if(e is FirebaseException){
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException){
        throw ' NetWork Error: ${e.message}';
      } else {
        throw 'Something Went Wrong! Please try again.';
      }
    }
  }
  /// Upload Image on Cloud Firebase Storage
  /// Tải tệp hình ảnh lên Fb và trả URL tải xuống
  Future<String> uploadImageFile(String path, XFile image) async{
    try{
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e){
      // Handle exceptions gracefully
      if(e is FirebaseException){
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException){
        throw ' NetWork Error: ${e.message}';
      } else {
        throw 'Something Went Wrong! Please try again.';
      }
    }
  }

}