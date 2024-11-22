import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
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
        child: Column(
          children: [
            const SizedBox(height: TSizes.spaceBtwSections),
            TSearchContainer(
              hintText: 'Tên thuốc, triệu chứng,...',
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  controller.fetchAllProducts();
                } else {
                  controller.searchProductByTitle(value);
                }
              },
              onSubmittedImage: () { _showBottomSheetPickImage(); },
            ),

            SizedBox(
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
          ],
        ),
      ),
    );
  }
}

_showBottomSheetPickImage(){
  final controller = Get.put(AllProductsController());
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
      ),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Chọn ảnh từ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(onPressed: () {
                    if (Get.isBottomSheetOpen ?? false) Get.back();
                    controller.searchByImage(source: ImageSource.camera);
                  }, icon: const Icon(Icons.camera_alt)),
                  const Text("Camera")
                ],
              ),
              Column(
                children: [
                  IconButton(onPressed: () {
                    if (Get.isBottomSheetOpen ?? false) Get.back();
                    controller.searchByImage(source: ImageSource.gallery);
                  }, icon: const Icon(Icons.image)),
                  const Text("Thư viện")
                ],
              )
            ],
          )
        ],
      ),
    )
  );
}


// import 'dart:ffi';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:t_store/common/widgets/appbar/appbar.dart';
// import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
// import 'package:t_store/utils/constants/sizes.dart';
// import 'package:get/get.dart';
// import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
// import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
// import '../../../../common/widgets/products/cart/cart_menu_icon.dart';
// import '../../../../common/widgets/products/sortable/sortable_products.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../controllers/product/all_products_controller.dart';
// import '../../models/product_model.dart';
//
// class AllProducts extends StatelessWidget {
//   const AllProducts({super.key, required this.title, this.query, this.futureMethod, required this.showAction});
//
//   final String title;
//   final Query? query;
//   final bool showAction;
//   final Future<List<ProductModel>>? futureMethod;
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Nạp controller để lấy các sản phẩm truy vấn
//     final controller = Get.put(AllProductsController());
//
//     return Scaffold(
//       appBar: TAppBar(title: Text(title), showBackArrow: true, action: showAction ?  const [
//         TCartCounterIcon(
//           counterBgColor: TColors.black,
//           counterTextColor: TColors.white,
//           iconColor: TColors.black,
//         ),
//       ] : null ,),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TSearchContainer(hintText: 'Tên thuốc, triệu chứng,...', onSubmitted: (value){},),
//             Padding(
//               padding: const EdgeInsets.all(TSizes.defaultSpace),
//               child: FutureBuilder(
//                 //--- futureMethod: truyền vào tất cả sản phẩm || controller.fetchProductsByQuery(query): truyền vào các sản phẩm đã truy vấn(tìm kiếm)
//                   future: futureMethod ?? controller.fetchProductsByQuery(query),
//                   builder: (context, snapshot) {
//                     const loader = TVerticalProductShimmer();
//                     final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
//
//                     if(widget !=null) return widget;
//
//                     final products = snapshot.data!;
//                     return TSortableProducts(products: products);
//                   }
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


