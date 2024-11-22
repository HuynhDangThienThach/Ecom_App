import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import 'notifycation_screen.dart';

class TNotifyCationIcon extends StatefulWidget {
  const TNotifyCationIcon(
      {super.key, this.iconColor, this.counterBgColor, this.counterTextColor});

  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  State<TNotifyCationIcon> createState() => _TNotifyCationIconState();
}

class _TNotifyCationIconState extends State<TNotifyCationIcon> {


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
            onPressed: () {
              Get.to(() => const NotifyCationScreen());
            },
            icon: Icon(
              Iconsax.notification,
              color: widget.iconColor,
            )),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: widget.counterBgColor ??
                  (dark ? TColors.white : TColors.black),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
                child: Text("0",
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: widget.counterTextColor ??
                            (dark ? TColors.black : TColors.white),
                        fontSizeFactor: 0.8))),
          ),
        ),
      ],
    );
  }
}
