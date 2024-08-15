import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/shimmers/shimmer.dart';
import 'package:t_store/features/shop/screens/brand/brand_products.dart';
import '../../../features/shop/models/brand_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../texts/t_brand_card.dart';
class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key,
    required this.images, required this.brand, this.isNetworkImage = true,
  });
  final bool isNetworkImage;
  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: TRoundedContainer(
        showBorder: true,
        borderColor: TColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        child: Column(
          children: [
            //--- Brand with products count
            TBrandCard(showBorder: false, brand: brand,),
            const SizedBox(height: TSizes.spaceBtwItems),
            //--- Brand top 3 product images
            Row(children: images.map((image) => brandTopProductImageWidget(image, context)).toList())
          ],
        ),
      ),
    );
  }
  Widget brandTopProductImageWidget(String image, context){
    final dark = THelperFunctions.isDarkMode(context);
    return  Expanded(
        child: TRoundedContainer(
          height: 80,
          backgroundColor: dark ? TColors.darkGrey : TColors.light,
          margin: const EdgeInsets.only(right: TSizes.sm),
          padding: const EdgeInsets.all(TSizes.sm),
          child: isNetworkImage ? CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) => const TShimmerEffect(width: 100, height: 100),
            errorWidget: (context, url, error) => const Icon(Icons.error)) : Image(fit: BoxFit.contain, image: AssetImage(image),),

        )
    );
  }
}