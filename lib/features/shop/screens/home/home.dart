import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/features/shop/screens/all_products/all_products.dart';
import 'package:t_store/features/shop/screens/home/widget/home_appbar.dart';
import 'package:t_store/features/shop/screens/home/widget/home_categories.dart';
import 'package:t_store/features/shop/screens/home/widget/promo_slider.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //--- Header container radius
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  //--- AppBar
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections,),

                  //--- SearchBar
                  TSearchContainer(text: 'Search in Store',),
                  SizedBox(height: TSizes.spaceBtwSections,),

                  //--- Categories -- Tutorial
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        //--- Heading
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBtwItems,),
                        //--- Categories
                        THomeCategories()
                      ],
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections,)
                ],
              ),
            ),
            //--- Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  //--- Carousel slider: thanh trượt băng chuyền
                  const TPromoSlider(),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  //--- Heading
                  TSectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => AllProducts(
                      title: 'Popular Products',
                      //--- Truyền vào tất cả sản phẩm
                      futureMethod: controller.fetchAllFeaturedProducts(),
                    )),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  //--- Popular Products
                  Obx( (){
                    if(controller.isLoading.value) return const TVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return TGrildLayout(itemCount: controller.featuredProducts.length, itemBuiler: (_, index) => TProductCardVertical(product: controller.featuredProducts[index],));
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

