import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/shimmers/category_shimmer.dart';
import 'package:t_store/features/shop/screens/sub_category/sub_categories.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../controllers/cateFeauture_controller.dart';
class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CateFeautureController());
    return Obx(() {
      if(categoryController.isLoading.value) return const TCategoryShimmer();

      if(categoryController.allCategories.isEmpty){
        return Center(child: Text('Không có dữ liệu!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
      }
      return SizedBox(
        height: 120,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryController.allCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final category = categoryController.allCategories[index];
              return TVerticalImageText(
                image: category.image,
                title: category.name,
                onTap: () => Get.toNamed(category.targetScreen)
              );
            }),


      //     return SizedBox(
      // height: 120,
      // child: ListView.builder(
      // shrinkWrap: true,
      // itemCount: categoryController.allCategories.length,
      // scrollDirection: Axis.horizontal,
      //     itemBuilder: (_, index) {
      //   final category = categoryController.allCategories[index];
      //   return TVerticalImageText(
      //     image: category.image,
      //     title: category.name,
      //     onTap: () => Get.to(() => SubCategoriesScreen(category: category,)),
      //   );
      // }),
      );
    }
    );
  }
}
