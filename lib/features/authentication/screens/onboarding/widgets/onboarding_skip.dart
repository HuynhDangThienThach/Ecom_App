import 'package:flutter/material.dart';
import 'package:t_store/features/authentication/controllers/onboarding/onboarding_controller.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

// ---OnBoardingPageButtonSkip
class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: TSizes.defaultSpace,
        top: TDeviceUtils.getAppBarHeight(),
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),
        ));
  }
}