import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../features/shop/models/product_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;
  //--- Functions
  Future<List<OrderModel>> fetchUserOrders() async {
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if(userId.isEmpty) throw 'Unable to find user information. Try again in few minutes.';
      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot)).toList();
  } catch(e){
     throw 'Something went wrong while fetching Order Information. Try again later';
    }
  }

  /// Store new user order
  Future<void> saveOrder(OrderModel order, String userId) async{
    try{
      await _db.collection('Users').doc(userId).collection('Orders').add(order.toJson());
    } catch (e){
      throw 'Something went wrong while fetching Order Information. Try again later';
    }
  }

  Future<void> updateProductStocks(List<ProductModel> updatedProducts) async {
    // Giả định bạn đang sử dụng Firestore hoặc một cơ sở dữ liệu tương tự
    for (var product in updatedProducts) {
      await FirebaseFirestore.instance.collection('Products').doc(product.id).update({
        'Stock': product.stock,
      });
    }
  }

  Future<ProductModel> fetchProductById(String productId) async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        return ProductModel.fromSnapshot(productDoc);
      } else {
        throw Exception('Sản phẩm không tồn tại');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy sản phẩm: ${e.toString()}');
    }
  }

}
