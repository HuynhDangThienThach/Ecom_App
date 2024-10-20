import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/common/widgets/texts/t_brand_card.dart';
import 'package:t_store/features/shop/controllers/brand_controller.dart';
import 'package:t_store/features/shop/screens/brand/brand_products.dart';
import 'package:t_store/utils/constants/sizes.dart';

import '../../../../common/widgets/shimmers/brands_shimmer.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: const TAppBar(title: Text('Thương hiệu'), showBackArrow: true,),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //--- Heading
              const TSectionHeading(title: "Tất cả thương hiệu thuốc", showActionButton: false,),
              const SizedBox(height: TSizes.spaceBtwItems,),

              // --- Brands GRID
              Obx(
                      (){
                    if(brandController.isLoading.value) return const TBrandsShimmer();
                    if(brandController.allBrands.isEmpty){
                      return Center(
                        child: Text('Chưa có sản phẩm!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),),
                      );
                    }
                    return TGrildLayout(
                        itemCount: brandController.allBrands.length,
                        mainAxisExtent: 80,
                        itemBuiler: (_, index) {
                          final brand = brandController.allBrands[index];
                          return TBrandCard(showBorder: true, brand: brand, onTap: () => Get.to(() => BrandProducts(brand: brand))
                          );
                        });
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}

