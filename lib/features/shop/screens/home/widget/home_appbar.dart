import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/notifycation/notify_menu_icon.dart';
import 'package:t_store/features/personalization/controllers/user_controller.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: TColors.darkerGrey),
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimmerEffect(width: 80, height: 15);
            } else {
              print("Full Name: ${controller.user.value.fullName}");
              return Text(
                controller.user.value.fullName,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: TColors.white),
              );
            }
          }),
        ],
      ),
      action: const [
        TNotifyCationIcon(
          iconColor: TColors.white,
          counterTextColor: TColors.white,
          counterBgColor: TColors.black,
        ),
        TCartCounterIcon(
          counterBgColor: TColors.black,
          counterTextColor: TColors.white,
          iconColor: TColors.white,
        ),
      ],
    );
  }
}
