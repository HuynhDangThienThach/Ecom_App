import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/shimmers/shimmer.dart';
import '../../../../../common/images/t_rounded_image.dart';
import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/banner_controller.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(
      () {
          if (controller.isLoading.value) return const TShimmerEffect(width: double.infinity, height: 190);
          if (controller.banners.isEmpty){
            return const Center(child: Text('Không có dữ liệu'));
          } else{
            return Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    onPageChanged: (index, _) => controller.updatePageIndicator(index),
                  ),
                  items: controller.banners.map((banner) =>
                      Stack(
                        children: [
                          TRoundedImage(
                            imageUrl: banner.imageUrl,
                            isNetworkImage: true,
                            onPressed: () => Get.toNamed(banner.targetScreen),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'HOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ).toList(),
                ),

                const SizedBox(height: TSizes.spaceBtwItems,),
                Center(
                  child: Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < controller.banners.length; i++)
                              TCircularContainer(
                                width: 20,
                                height: 4,
                                margin: const EdgeInsets.only(right: 10),
                                backgroundColor: controller.carousalCurrentIndex.value == i ? TColors.primary : TColors.grey,
                              ),
                          ],
                    ),
                  ),
                )
              ],
            );
          }
        }
    );
  }
}
