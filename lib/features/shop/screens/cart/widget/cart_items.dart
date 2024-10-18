import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/products/product_text/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/cart_item_model.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showAddRemoveButtons = true,
    required this.items, // Thêm danh sách sản phẩm cần hiển thị
  });

  final bool showAddRemoveButtons;
  final List<CartItemModel> items; // Danh sách sản phẩm

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections,),
      itemBuilder: (_, index) {
        final item = items[index];
        return Column(
          children: [
            //--- Cart Item
            TCartItem(cartItem: item,),
            if (showAddRemoveButtons) const SizedBox(height: TSizes.spaceBtwItems),
            if (showAddRemoveButtons) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 70,),
                    //--- Add Remove Buttons
                    TProductQuantityWidthAddRemoveButton(
                      quantity: item.quantity,
                      add: () => CartController.instance.addOneToCart(item),
                      remove: () => CartController.instance.removeOneFromCart(item),
                    ),
                  ],
                ),
                //--- Product total price
                TProductPriceText(price: '${NumberFormat('#,##0').format(item.price * item.quantity)}đ',),
              ],
            ),
          ],
        );
      },
    );
  }
}

