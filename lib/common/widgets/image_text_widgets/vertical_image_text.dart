import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = TColors.white,
    this.isNetworkImage = false,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TCircularImage(
                image: image,
                fit: BoxFit.fitWidth,
                padding: TSizes.sm * 1.4,
                isNetworkImage: isNetworkImage,
                backgroundColor: backgroundColor,
              ),
              //--- Text
              const SizedBox(
                height: TSizes.spaceBtwItems / 4,
              ),
              SizedBox(
                  width: 70,
                  height: 40,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall!.apply(color: textColor),
                    maxLines: null,
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
    );
  }
}
