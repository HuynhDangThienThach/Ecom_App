import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';

import '../../../features/personalization/models/addressModel/AddressModel.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  //--- Variables
  final _db = FirebaseFirestore.instance;
  //--- Functions
  Future<List<AddressModel>> fetchUserAddress() async {
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if(userId.isEmpty) throw 'Unable to find user information. Try again in few minutes';

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    }catch(e){
      throw 'Something went wrong while fetching Address Information. Try again later';
    }
  }

  // Clear the "selected" field for all address
  Future<void> updateSelectedField(String addressId, bool selected) async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection("Users").doc(userId).collection("Addresses").doc(addressId).update({"SelectedAddress": selected});
    } catch (e){
      throw "Unable to update your address selection. Try again later";
    }
  }

  // Store new address
  Future<String> addAddress(AddressModel address) async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db.collection("Users").doc(userId).collection("Addresses").add(address.toJson());
      return currentAddress.id;
    }catch (e){
      throw 'Something went wrong while fetching Address Infomation. Try again later';
    }
  }

  // Delete Address
  Future<void> deleteAddresses(String addressId) async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final deleteAddress = await _db.collection("Users").doc(userId).collection("Addresses").doc(addressId).delete();
    }catch(e){
      throw 'Error deleting address: $e';
    }
  }
}