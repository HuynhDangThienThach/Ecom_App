import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/loaders.dart';
import '../../custom_shapes/containers/rounded_container.dart';


class TCouponCode extends StatelessWidget {
  const TCouponCode({super.key,});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? TColors.dark : TColors.white,
      padding: const EdgeInsets.only(top: TSizes.sm, bottom: TSizes.sm, right: TSizes.sm, left: TSizes.md),
      child: Row(
        children: [
          //--- TextFiled
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Có mã khuyến mại? Nhập vào đây",
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

          //--- Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () => TLoaders.warningSnackBar(title: "Chà, rất tiếc!", message: "Mã của bạn không chính xác"),
              style: ElevatedButton.styleFrom(
                foregroundColor: dark ? TColors.white.withOpacity(0.5) : TColors.dark.withOpacity(0.5),
                backgroundColor: Colors.blue.withOpacity(0.2),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: const Text("Xác nhận"),
            ),
          )
        ],
      ),
    );
  }
}