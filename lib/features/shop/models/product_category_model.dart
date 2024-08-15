import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel{
  final String productId;
  final String categoryId;

  ProductCategoryModel({
    required this.productId,
    required this.categoryId,
  });

  // Chuyển instance thành môt dạng dữ liệu dưới dạng MapString để lưu vào CSDL()
  Map<String, dynamic> toJson(){
    return {
      'productId': productId,
      'categoryId': categoryId,
    };
  }

  // Truy xuất dữ liệu từ Fb về instance
  factory ProductCategoryModel.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductCategoryModel(
      productId: data['productId'] as String,
        categoryId: data['categoryId'] as String,
    );
  }
}