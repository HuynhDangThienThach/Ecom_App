import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/icons/t_circular_icon.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product);
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems, vertical: TSizes.defaultSpace /2),
      decoration: BoxDecoration(
        color: dark ? TColors.darkGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Obx(
       () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              children: [
                TCircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: TColors.darkGrey,
                  width: 40,
                  height: 40,
                  color: TColors.white,
                  onPressed: () => controller.productQuantityInCart.value < 0 ? null : controller.productQuantityInCart.value -= 1 ,
                ),
                const SizedBox(width: TSizes.spaceBtwItems,),
                Text(controller.productQuantityInCart.value.toString(), style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: TSizes.spaceBtwItems,),
                TCircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: TColors.black,
                  width: 40,
                  height: 40,
                  color: TColors.white,
                  onPressed: () => controller.productQuantityInCart.value += 1,
                ),
              ],
            ),
              ElevatedButton(
                onPressed: controller.productQuantityInCart.value < 1 ? null : () => controller.addToCart(product),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(TSizes.sm),
                  backgroundColor: controller.productQuantityInCart.value > 0 ? TColors.primary1 : TColors.white,
                  side: const BorderSide(color: TColors.black),
                ),
                child: Text(
                  'Thêm giỏ hàng',
                  style: TextStyle(
                    color: controller.productQuantityInCart.value > 0 ? TColors.white : TColors.black,
                    fontSize: 14
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: controller.productQuantityInCart.value < 1 ? null : () => controller.buyNow(product),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(TSizes.sm),
                      backgroundColor: TColors.black,
                      side: const BorderSide(color: TColors.black)
                  ),child: Text('Mua ngay', style: TextStyle(
                  color: controller.productQuantityInCart.value > 0 ? TColors.white : TColors.black,
                  fontSize: 14
              ),)),
            ],
            ),
      )
    );
  }
}
