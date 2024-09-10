import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/loaders/animation_loader.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';
import 'package:t_store/features/shop/screens/cart/widget/cart_items.dart';
import 'package:t_store/features/shop/screens/checkout/checkout.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall), ),
      body: Obx(
       () {
         final emptyWidget = TAnimationLoaderWidget(
           text: 'Whoops! Cart is EMPTY',
           animation: TImages.cartAnimation,
           showAction: true,
           actionText: 'Let\'s fill it',
           onActionPressed: () => Get.off(() => const NavigationMenu()),
         );
         
         if (controller.cartItems.isEmpty) {
           return emptyWidget;
         } else {
           return const SingleChildScrollView(
             child: Padding (
               padding: EdgeInsets.all(TSizes.defaultSpace),

               child: TCartItems()
                      ),
           );
         }
       }
      ),
      bottomNavigationBar: (controller.cartItems.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () => Get.to(() => const CheckoutScreen()),
                  child: Obx(() => Text('Checkout \$${controller.totalCartPrice.value.toStringAsFixed(1)}'))),
      ),
    );
  }
}
