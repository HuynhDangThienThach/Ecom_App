import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/common/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/products/cart/product_cart_add_cartButton.dart';
import 'package:t_store/features/shop/controllers/product/product_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/features/shop/screens/product_details/product_detail.dart';
import 'package:t_store/utils/constants/enums.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified_icon.dart';
import '../favourite_icon/favourite_icon.dart';
import '../product_text/product_price_text.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);
    ///--- Container with side paddings, color, edges, radius and shadow.
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetail(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          children: [
            //--- Thumbnail, Wishlist, Button, Discount Tag
            TRoundedContainer(
              height: 170,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  //--- Thumbnail
                  Center(
                    child: TRoundedImage(
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                      isNetworkImage: true,
                    ),
                  ),
                  //--- Sale Tag
                  if(salePercentage !=null)
                  Positioned(
                    top: 12,
                    child: Padding(
                      padding: const EdgeInsets.only(left: TSizes.sm),
                      child: salePercentage != '0' ? TRoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: TColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: TSizes.xs),
                        child:Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),)
                      ): null,
                    ),
                  ),
                  //--- Favourite Icon Button
                  Positioned(
                      top: 0, right: 0,
                      child: TFavouriteIcon(productId: product.id,)
                  )
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2,),
            //--- Details
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: product.title, smallSize: true),
                  // --- Brand: nhãn hiệu
                  TBrandTitleWithVerifiedIcon(title: product.brand!.name),
                ],
              ),
            ),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //--- Giá
                Flexible(
                  child: Column(
                    children: [
                      if(product.productType == ProductType.single.toString() && product.salePrice >0)
                        Padding(
                            padding: const EdgeInsets.only(right: TSizes.md),
                            child: Text(
                              style: Theme.of(context).textTheme.labelLarge!.apply(decoration: TextDecoration.lineThrough, color: TColors.textSecondary),
                              '${NumberFormat('#,##0').format(product.price)}đ',
                            )),
                        Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: TProductPriceText(price: controller.getProductPrice(product),)),
                    ],
                  ),
                ),
                //--- Nút thêm giỏ hàng
                ProductCardAddToCartButton(product: product),
              ],
            )
          ],
        ),
      ),
    );
  }
}

