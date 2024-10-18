import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';

/// A utility class for managing a full-screen loading dialog
class TFullScreenLoader{
  /// Open a full-screen loading dialog with a give text and animation.
  /// This method doesn't return anything.
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation){
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: THelperFunctions.isDarkMode(Get.context!) ? TColors.dark : TColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 250,),
                 TAnimationLoaderWidget(text: text, animation: animation,)
                ],
              ),
            )

        )
    );
}
    /// Stop the currently open loading dialog.
    /// This method doesn't return anything.
    static stopLoading(){
      Navigator.of(Get.overlayContext!).pop();
    }

}