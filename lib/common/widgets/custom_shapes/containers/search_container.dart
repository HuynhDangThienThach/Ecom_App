import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    required this.hintText,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onSubmitted,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
    required this.onSubmittedImage,
  });

  final String hintText;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final Function() onSubmittedImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  prefixIcon: GestureDetector(
                    onTap: onSubmitted != null
                        ? () => onSubmitted!(controller?.text ?? "")
                        : null,
                    child: Icon(icon, color: TColors.darkGrey),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => onSubmittedImage(),
                    child: const Icon(Iconsax.camera, color: TColors.darkerGrey),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
    );

  }
}


// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/device/device_utility.dart';
// import '../../../../utils/helpers/helper_functions.dart';
//
// class TSearchContainer extends StatelessWidget {
//   const TSearchContainer({
//     super.key,
//     required this.text,
//     this.icon = Iconsax.search_normal,
//     this.showBackground = true,
//     this.showBorder = true,
//     this.onTap,
//     this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//   });
//
//   final String text;
//   final IconData? icon;
//   final bool showBackground, showBorder;
//   final VoidCallback? onTap;
//   final EdgeInsetsGeometry padding;
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: padding,
//         child: Container(
//           width: TDeviceUtils.getScreenWidth(context),
//           padding: const EdgeInsets.all(TSizes.md),
//           decoration: BoxDecoration(
//             color: showBackground
//                 ? dark
//                 ? TColors.black
//                 : TColors.light
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
//             border: showBorder ? Border.all(color: TColors.grey) : null,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 color: TColors.darkGrey,
//               ),
//               const SizedBox(
//                 width: TSizes.spaceBtwItems,
//               ),
//               Text(
//                 text,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const Spacer(),
//               const Icon(
//                 Iconsax.camera,
//                 color: TColors.darkerGrey,
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


