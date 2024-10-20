
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store/features/shop/models/product_variation_model.dart';
import 'package:t_store/features/shop/models/product_attribute_model.dart';

import 'brand_model.dart';

class ProductModel{
  // Khai báo các thuộc tính của class
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductAttributeModel>? productAttributes; // Đại diện cho màu sắc : đỏ
  List<ProductVariationModel>? productVariations; // Đại diện cho màu sắc, kích cỡ

  // Constructor để khởi tạo đối tượng ProductModel
  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
  });

  // Phương thức tạo một đối tượng ProductModel trống
  static ProductModel empty() => ProductModel(id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '');

  // Phương thức chuyển đổi đối tượng ProductModel thành JSON
  toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand!.toJson(),
      'Description': description,
      'ProductType': productType,
      'Date': date?.toIso8601String(),
      'ProductAttributes': productAttributes != null ? productAttributes!.map((e) => e.toJson()).toList() : [],
      'ProductVariations': productVariations != null ? productVariations!.map((e) => e.toJson()).toList() : [],
    };
  }

  // Factory method để chuyển đổi từ DocumentSnapshot thành đối tượng ProductModel
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if(document.data() == null) return ProductModel.empty();
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      sku: data['SKU'],
      title: data['Title'],
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      date: data['Date'] != null ? DateTime.parse(data['Date']) : null,
      brand: BrandModel.fromJson(data['Brand']),
      images: data['Images'] != null ? List<String>.from(data['Images']): [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
    );
  }

  // Factory method để chuyển đổi DocumentSnapshot từ Firebase thành đối tượng ProductModel
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      date: data['Date'] != null ? DateTime.parse(data['Date']) : null,
      brand: BrandModel.fromJson(data['Brand']),
      images: data['Images'] != null ? List<String>.from(data['Images']): [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>).map((e) => ProductAttributeModel.fromJson(e)).toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
    );
  }


}

