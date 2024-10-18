import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/products/product_text/product_price_text.dart';
import 'package:t_store/common/widgets/texts/product_title_text.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/controllers/product/variation_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../utils/constants/sizes.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VariationController());
    controller.resetSelectedAttributes();
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(
          () {
        // Kiểm tra điều kiện có thuộc tính đã chọn
        bool hasSelectedVariation = controller.selectedVariation.value.id.isNotEmpty;

        return Column(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.productAttributes!.map((attribute) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TSectionHeading(title: attribute.name ?? '', showActionButton: false),
                      const SizedBox(height: TSizes.spaceBtwItems / 2,),
                      Obx(() {
                        return Wrap(
                          spacing: 8,
                          children: attribute.values!.map((attributeValue) {
                            final isSelected = controller.selectedAttributes[attribute.name] == attributeValue;
                            final available = controller.getAttributesAvailabilityInVariation(product.productVariations!, attribute.name!).contains(attributeValue);
                            return TChoiceChip(
                              text: attributeValue,
                              selected: isSelected,
                              onSelected: available
                                  ? (selected) {
                                if (selected) {
                                  controller.onAttributeSelected(product, attribute.name ?? '', attributeValue);
                                } else {
                                  controller.selectedAttributes.remove(attribute.name);
                                  controller.resetSelectedAttributes();
                                  controller.getProductVariationStockStatus();
                                }
                              }
                                  : null,
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: TSizes.spaceBtwItems),
            if (hasSelectedVariation)
            TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
                child: Column(
                  children: [
                    //--- Title, Price and Stock Status
                    Row(
                      children: [
                        const TSectionHeading(title: 'Đặc điểm', showActionButton: false),
                        const SizedBox(width: TSizes.spaceBtwItems,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const TProductTitleText(title: 'Giá: ', smallSize: true),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                TProductPriceText(price: '${NumberFormat('#,##0').format(controller.getVariationPrice())}đ', isLarge: false),
                              ],
                            ),
                            Row(
                              children: [
                                const TProductTitleText(title: 'Kho: ', smallSize: true),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Text(controller.variationStockStatus.value, style: Theme.of(context).textTheme.titleMedium),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // TProductTitleText(
                    //   title: controller.selectedVariation.value.description ?? '',
                    //   smallSize: true,
                    //   maxLines: 4,
                    // ),
                  ],
                ),
              ),


            //--- Attributes

          ],
        );
      },
    );
  }
}


