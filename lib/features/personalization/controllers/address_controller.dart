import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/loaders/circular_loader.dart';
import 'package:t_store/data/repositories/address_repository/address_repository.dart';
import 'package:t_store/utils/helpers/network_manager.dart';
import 'package:t_store/utils/popups/full_screen_load.dart';
import 'package:t_store/utils/popups/loaders.dart';

import '../../../utils/constants/image_strings.dart';
import '../models/addressModel/AddressModel.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  //--- Variables
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  //--- Get All User Address
  Future<List<AddressModel>> getAllUserAddress() async {
    try{
     final addresses = await addressRepository.fetchUserAddress();
     selectedAddress.value = addresses.firstWhere((element) => element.selectedAddress, orElse: () => AddressModel.empty());
     return addresses;
    } catch(e){
      TLoaders.errorSnackBar(title: "Address not found!", message: e.toString());
      return [];
    }
  }

  // Cập nhật selectedAddress trong csdl và chỉ ra địa chỉ được chọn hay không được chọn
  Future selectAddress(AddressModel newSelectedAddress) async{
    try {
      Get.defaultDialog(
        title: '',
        onWillPop: () async{return false;},
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const TCircularLoader(),
      );

      // Xóa địa chỉ đã chọn
      if(selectedAddress.value.id.isNotEmpty){
        await addressRepository.updateSelectedField(selectedAddress.value.id, false);
      }

      // Gán địa chỉ mới làm địa chỉ được chọn
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Cập nhật địa chỉ mới được chọn trong CSDL
      await addressRepository.updateSelectedField(selectedAddress.value.id, true);
      Get.back();
    }catch(e){
      Get.back();
      TLoaders.errorSnackBar(title: 'Error in Selection', message: e.toString());
    }
  }

  // Tạo địa chỉ mới cho người dùng
  Future addNewAddresses() async{
    try{
      // Start loading
      TFullScreenLoader.openLoadingDialog('Storing Address...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if(!addressFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Address Data
      final address = AddressModel(
        id:'',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );
      final id = await addressRepository.addAddress(address);
      
      // Update Selected Address Status
      address.id = id;
      selectedAddress(address);
      
      // Remove Loader
      TFullScreenLoader.stopLoading();
      
      // Show Success Message
      TLoaders.successSnackBar(title: "Congratulations", message: "Your address has been saved successfully");
      
      // Refresh Address Data
      refreshData.toggle();
      
      // Reset fields 
      resetFormFields();
      
      // Redirect
      Navigator.of(Get.context!).pop();
    } catch(e){
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Address not found", message: e.toString());
    }
  }

  /// Chức năng reset lại form khi tạo thành công
  void resetFormFields(){
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }

  // Remove addresses
  Future<void> deleteAddress(AddressModel address) async {
    try {
      // Hiển thị loading indicator
      Get.defaultDialog(
        title: '',
        onWillPop: () async{return false;},
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const TCircularLoader(),
      );

      // Xóa địa chỉ từ repository
      await addressRepository.deleteAddresses(address.id);

      // Ẩn loading indicator
      Get.back();

      // Làm mới danh sách địa chỉ
      refreshData.toggle();

      // Hiển thị thông báo thành công
      TLoaders.successSnackBar(
        title: "Deleted",
        message: "Address deleted successfully!",
      );
    } catch (e) {
      Get.back();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}