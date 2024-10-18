import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import '../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../common/widgets/products/sortable/sortable_products.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/product/all_products_controller.dart';
import '../../models/product_model.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.title, this.query, this.futureMethod, required this.showAction});

  final String title;
  final Query? query;
  final bool showAction;
  final Future<List<ProductModel>>? futureMethod;


  @override
  Widget build(BuildContext context) {
    // Nạp controller để lấy các sản phẩm truy vấn
    final controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: TAppBar(title: Text(title), showBackArrow: true, action: showAction ?  const [
        TCartCounterIcon(
          counterBgColor: TColors.black,
          counterTextColor: TColors.white,
          iconColor: TColors.black,
        ),
      ] : null ,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
            //--- futureMethod: truyền vào tất cả sản phẩm || controller.fetchProductsByQuery(query): truyền vào các sản phẩm đã truy vấn(tìm kiếm)
            future: futureMethod ?? controller.fetchProductsByQuery(query),
            builder: (context, snapshot) {
              const loader = TVerticalProductShimmer();
              final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);

              if(widget !=null) return widget;

              final products = snapshot.data!;
              return TSortableProducts(products: products);
            }
          ),
        ),
      ),
    );
  }
}

