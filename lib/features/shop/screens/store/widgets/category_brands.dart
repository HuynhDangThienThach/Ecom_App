import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/shimmers/list_title_shimmer.dart';
import 'package:t_store/features/shop/controllers/brand_controller.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../common/widgets/shimmers/boxes_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({
    super.key,
    required this.category
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(
        // future để lấy dữ liệu category.id và sẽ cập nhật cho builer dựa trên dữ liệu đã lấy
        future: controller.getBrandsCategory(category.id),
        builder: (context, snapshot){
          // Xử lý loader, no record, error message
          const loader = Column(
            children: [
              TListTitleShimmer(),
              SizedBox(height: TSizes.spaceBtwItems,),
              TBoxesShimmer(),
              SizedBox(height: TSizes.spaceBtwItems,)
            ],
          );
          final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
          if(widget != null) return widget;

          // Record Found!
          final brands = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: brands.length,
            itemBuilder: (_, index){
              final brand = brands[index];
              return FutureBuilder(
                  future: controller.getBrandProducts(brandId: brand.id, limit: 3),
                  builder: (context, snapshot){
                    final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;

                    final products = snapshot.data!;
                    final images = products
                        .where((e) => e.images != null)
                        .expand((e) => e.images!).take(3)
                        .toList();
                    // return TBrandShowcase( brand: brand, images: products.map((e) => e.thumbnail).toList());
                    return TBrandShowcase( brand: brand, images: images);
                  },
              );
            }
          );
        }
    );
  }
}
