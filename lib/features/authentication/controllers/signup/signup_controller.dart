
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store/data/repositories/user/user_repository.dart';
import 'package:t_store/features/authentication/screens/signup/verify_email.dart';
import 'package:t_store/utils/popups/full_screen_load.dart';
import 'package:t_store/utils/popups/loaders.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../personalization/models/userModel/UserModel.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  //--- Variables
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  //--- Determine the status of registration form
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  //--- Signup
  void signup() async{
    try {
      //--- Start Loading
      TFullScreenLoader.openLoadingDialog('Chúng tôi đang xử lý thông tin của bạn...', TImages.docerAnimation);

      //--- Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      //--- Form Validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //--- Primary Policy Check
      if(!privacyPolicy.value){
        TLoaders.warningSnackBar(
          title: 'Chấp nhận chính sách bảo mật',
          message: 'Để tạo tài khoản, bạn phải đọc và chấp nhận Chính sách bảo mật & Điều khoản sử dụng.',
        );
        return;
      }
      //--- Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //--- Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);
      //--- Remove Loader
      TFullScreenLoader.stopLoading();
      //--- Save Success Message
      TLoaders.successSnackBar(title: 'Chúc mừng', message: 'Tài khoản của bạn đã được tạo! Xác minh email để tiếp tục.');
      //--- Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e){
      //--- Remove Loader
      TFullScreenLoader.stopLoading();
      //--- Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }
}