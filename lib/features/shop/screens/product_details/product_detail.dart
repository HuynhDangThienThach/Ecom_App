import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:t_store/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:t_store/utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/cart_controller.dart';
import '../../models/product_model.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //--- 1. Product Image Slider
            TProductImageSlider(product: product,),

            //--- 2. Product Details
            Padding(
              padding: const EdgeInsets.only(right: TSizes.defaultSpace, left: TSizes.defaultSpace, bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  //--- Rating & Share Button
                  const TRatingAndShare(),

                  //--- Price, Title, Stack & Brand
                  TProductMetaData(product: product,),

                  //--- Attributes variable
                  if(product.productType == ProductType.variable.toString()) TProductAttributes(product: product,),
                  if(product.productType == ProductType.variable.toString()) const SizedBox(height: TSizes.spaceBtwSections,),
                  //--- Attributes single
                  if(product.productType == ProductType.single.toString()) TProductAttributes(product: product,),
                  if(product.productType == ProductType.single.toString()) const SizedBox(height: TSizes.spaceBtwSections,),
                  const SizedBox(height: TSizes.spaceBtwSections,),
                  //--- Description
                  const TSectionHeading(title: 'Mô tả', showActionButton: false,),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                   ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Mở rộng',
                    trimExpandedText: 'Thu gọn',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  //--- Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(title: 'Đánh giá (199)', showActionButton: false,),
                      IconButton(onPressed: () =>  Get.to(() => const TProductReviewsScreen()), icon: const Icon(Iconsax.arrow_right_3, size: 18))
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

