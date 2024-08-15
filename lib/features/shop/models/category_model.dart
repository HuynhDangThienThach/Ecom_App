import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = "",
  });

  /// Empty Helper Function
  static CategoryModel empty() => CategoryModel(id: '', name: '', isFeatured: false, image: '');

  /// Convert this model to Json and store data in Fb
  Map<String, dynamic> toJson(){
    return{
      'Name' : name,
      'Image' : image,
      'ParentId' : parentId,
      'IsFeatured' : isFeatured,
    };
  }

  /// Map Json document from Fb to UserModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if (document.data() != null){
      final data = document.data()!;

      // Map Json Record to the Model
      return CategoryModel(
          id: document.id,
          name: data['Name'] ?? '',
          image: data['Image'] ?? '',
          isFeatured: data['IsFeatured'] ?? '',
          parentId: data['ParentId'] ?? ''
      );
    } else{
      return CategoryModel.empty();
    }
  }
}