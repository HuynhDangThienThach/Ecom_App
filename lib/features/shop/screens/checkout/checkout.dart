import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';
import 'package:t_store/features/shop/screens/cart/widget/cart_items.dart';
import 'package:t_store/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:t_store/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:t_store/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import 'package:t_store/utils/helpers/pricing_calculator.dart';
import 'package:t_store/utils/popups/loaders.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/order_controller.dart';
import '../../models/cart_item_model.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final List<CartItemModel>? tempCartItems = Get.arguments as List<CartItemModel>?;

    // Nếu có giỏ hàng tạm thời (buy now), sử dụng nó; nếu không thì dùng giỏ hàng từ cartController
    final List<CartItemModel> itemsToCheckout = tempCartItems ?? cartController.cartItems;

    // Tính tổng tiền từ các sản phẩm
    final subTotal = itemsToCheckout.fold(0.0, (total, item) => total + item.price * item.quantity);

    final orderController = Get.put(OrderController());
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'VN');
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Thanh toán đơn hàng', style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //--- Items in Cart
              TCartItems(
                showAddRemoveButtons: false,
                items: itemsToCheckout, // Truyền danh sách sản phẩm vào đây
              ),
              const SizedBox(height: TSizes.spaceBtwSections,),

              //--- Coupon TextField
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections,),

              //--- Billing Section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    //--- Pricing
                    TBillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwItems,),

                    //--- Divider
                    Divider(),
                    SizedBox(height: TSizes.spaceBtwItems,),

                    //--- Payment Methods
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems,),

                    //--- Address
                    TBillingAddressSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      //--- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subTotal > 0
              ? () => orderController.processOrder(totalAmount)
              : () => TLoaders.warningSnackBar(title: 'Giỏ hàng trống', message: 'Thêm các mặt hàng vào giỏ hàng để tiếp tục'),
          child: Text('Thanh toán ${NumberFormat('#,##0').format(totalAmount)}đ'),
        ),
      ),
    );
  }
}

