import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/common/widgets/products/product_text/product_price_text.dart';
import 'package:t_store/common/widgets/texts/product_title_text.dart';
import 'package:t_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:t_store/features/shop/controllers/product/product_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constants/enums.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--- Title
        TProductTitleText(title: product.title),
        const SizedBox(height: TSizes.spaceBtwItems/ 1.5,),
        //--- Price & Sale Price
        Row(
          children: [
            //--- Sale Tag
            TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
              child: Text('$salePercentage%',style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),),
            ),
            const SizedBox(width: TSizes.spaceBtwItems,),

            //--- Price
            if (product.productType == ProductType.single.toString() && product.salePrice > 0)
              Text('${NumberFormat('#,##0').format(product.price)}đ', style: Theme.of(context).textTheme.labelLarge!.apply(decoration: TextDecoration.lineThrough),),
            if (product.productType == ProductType.single.toString() && product.salePrice > 0)  const SizedBox(width: TSizes.spaceBtwItems,),
            TProductPriceText(price: controller.getProductPrice(product), isLarge: true,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems/ 1.5),

        //--- Stack Status
        Row(
          children: [
            const TProductTitleText(title: 'Trạng thái:'),
            const SizedBox(width: TSizes.spaceBtwSections),
            Text(controller.getProductStockStatus(product.stock), style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems/1.5),
        
        //--- Brand
        Row(
          children: [
            const TProductTitleText(title:"Nhà sản xuất:"),
            TCircularImage(image: product.brand != null ? product.brand!.image : '', width: 40, height: 40, overlayColor: dark ? TColors.white : TColors.black),
            TBrandTitleWithVerifiedIcon(title: product.brand != null ? product.brand!.name : '', brandTextSize: TextSizes.medium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems/1.5),
      ],
    );
  }
}
