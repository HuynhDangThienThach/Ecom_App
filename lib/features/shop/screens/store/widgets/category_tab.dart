import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/controllers/category_controller.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:get/get.dart';
import 'package:t_store/features/shop/screens/all_products/all_products.dart';
import 'package:t_store/features/shop/screens/store/widgets/category_brands.dart';
import '../../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:[
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //--- Brand
              CategoryBrands(category: category),
              const SizedBox(height: TSizes.spaceBtwItems),
              //--- Products
              FutureBuilder(
                future: controller.getCategoryProducts(categoryId: category.id),
                builder: (context, snapshot) {
                  final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: const TVerticalProductShimmer());
                  if (response != null) return response;

                  final products = snapshot.data!;

                  return Column(
                    children: [
                      TSectionHeading(
                        title: 'Có thể bạn thích',
                        showActionButton: true, 
                        onPressed: () => Get.to(AllProducts(
                          title: category.name, 
                          futureMethod: controller.getCategoryProducts(categoryId: category.id, limit: -1), showAction: false,
                        )),),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TGrildLayout(itemCount: products.length, itemBuiler: (_, index) => TProductCardVertical(product: products[index])),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ]
    );
  }
}
