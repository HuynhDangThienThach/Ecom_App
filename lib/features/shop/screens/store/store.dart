import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/controllers/brand_controller.dart';
import 'package:t_store/features/shop/controllers/category_controller.dart';
import 'package:t_store/features/shop/screens/brand/all_brands.dart';
import 'package:t_store/features/shop/screens/store/widgets/category_tab.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/shimmers/brands_shimmer.dart';
import '../../../../common/widgets/texts/t_brand_card.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final brandController = Get.put(BrandController());
    final controller = Get.put(CategoryController());
    final categories = controller.featuredCategories;
    return Scaffold(
      appBar: TAppBar(
        title: Text('Danh mục', style: Theme.of(context).textTheme.headlineMedium,),
        action: const [TCartCounterIcon()],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.featuredCategories.isEmpty) {
          return Center(
            child: Text('Không có loại sản phẩm nào!', style: Theme.of(context).textTheme.bodyMedium),
          );
        }
        return DefaultTabController(
          length: categories.length,  // Dùng số lượng chính xác từ categories
          child: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: dark ? TColors.black : TColors.white,
                  expandedHeight: 430,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const TSearchContainer(
                          text: 'Tên thuốc, triệu chứng,... ',
                          showBackground: false,
                          showBorder: true,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        TSectionHeading(
                            title: 'Thương hiệu đặc trưng', onPressed: () => Get.to(() => const AllBrandsScreen())),
                        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                        Obx(() {
                          if (brandController.isLoading.value) {
                            return const TBrandsShimmer();
                          }
                          if (brandController.featureBrands.isEmpty) {
                            return Center(
                              child: Text('Không có sản phẩm!',
                                style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                              ),
                            );
                          }
                          return TGrildLayout(
                            itemCount: brandController.featureBrands.length,
                            mainAxisExtent: 80,
                            itemBuiler: (_, index) {
                              final brand = brandController.featureBrands[index];
                              return TBrandCard(showBorder: true, brand: brand);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  bottom: TTabBar(
                    tabs: categories.map((category) => Tab(child: Text(category.name))).toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: categories.map((category) => TCategoryTab(category: category)).toList(),
            ),
          ),
        );
      }),
    );
  }

}




