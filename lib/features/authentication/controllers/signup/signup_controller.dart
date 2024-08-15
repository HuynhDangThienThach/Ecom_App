
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
  final privacyPolicy = true.obs;
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
      TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.docerAnimation);

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
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
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
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');
      //--- Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e){
      //--- Remove Loader
      TFullScreenLoader.stopLoading();
      //--- Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
