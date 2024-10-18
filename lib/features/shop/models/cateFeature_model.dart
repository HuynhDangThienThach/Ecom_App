import 'package:cloud_firestore/cloud_firestore.dart';

class CatefeatureModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  String targetScreen; // New Property

  CatefeatureModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.targetScreen = "", // Default value if not provided
  });

  /// Empty Helper Function
  static CatefeatureModel empty() => CatefeatureModel(id: '', name: '', isFeatured: false, image: '', targetScreen: '');

  /// Convert this model to Json and store data in Fb
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Image': image,
      'IsFeatured': isFeatured,
      'TargetScreen': targetScreen, // Include targetScreen in JSON
    };
  }

  /// Map Json document from Fb to UserModel
  factory CatefeatureModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map Json Record to the Model
      return CatefeatureModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
        targetScreen: data['TargetScreen'] ?? '',
      );
    } else {
      return CatefeatureModel.empty();
    }
  }
}
