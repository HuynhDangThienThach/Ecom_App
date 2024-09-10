import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> importJsonToFirestore() async {
  // Đọc file JSON từ assets
  final String response = await rootBundle.loadString('assets/addData.json');
  final data = await json.decode(response);

  // Lấy reference đến Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Thêm dữ liệu vào collection 'Products'
  data['Products'].forEach((key, value) async {
    await firestore.collection('Products').doc(key).set(value);
    print('Document $key successfully written!');
  });

  print('All documents successfully written!');
}
