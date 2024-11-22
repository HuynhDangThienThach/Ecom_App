import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:t_store/features/personalization/controllers/user_controller.dart';
import 'package:t_store/utils/popups/full_screen_load.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/signup/signup.dart';
import '../../screens/signup/signup_google.dart';


enum SupportState {
  unknown,
  supported,
  unSupported,
}
class LoginController extends GetxController {

  //--- Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());



  // Biometric authentication variables
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    checkBiometricSupport();
    super.onInit();
  }


  Future<void> checkBiometricSupport() async {
    final isSupported = await auth.isDeviceSupported();
    supportState = isSupported ? SupportState.supported : SupportState.unSupported;
    if (supportState == SupportState.supported) {
      await getAvailableBiometrics();
    }
  }

  Future<void> getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Xác thực bằng vân tay hoặc Face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        googleSignIn();
        }
    } on PlatformException catch (e) {
      print(e);
      TLoaders.errorSnackBar(
        title: 'Authentication Error',
        message: 'Biometric authentication failed. Please try again.',
      );
    }
  }


  //--- Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async{
    try{
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      //--- Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      //--- Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Save Data if Remember Me is selected
      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      // Login User using Email and Password Authentication
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      // Remove Loader
      TFullScreenLoader.stopLoading();
      // Redirect - Chuyen den trang chu
      AuthenticationRepository.instance.screenRedirect();
    } catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }

  //--- Google SigIn Authentication
  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // Kiểm tra nếu thông tin người dùng đã đầy đủ
      final isUserInfoComplete = await userController.isUserInfoComplete(userCredentials?.user?.uid);

      // Dừng loader
      TFullScreenLoader.stopLoading();


      if (!isUserInfoComplete) {
        Get.offAll(() => const SignupGoogle());
      } else {
        // Nếu thông tin đầy đủ, điều hướng theo logic bình thường
        await AuthenticationRepository.instance.screenRedirect();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }

}
