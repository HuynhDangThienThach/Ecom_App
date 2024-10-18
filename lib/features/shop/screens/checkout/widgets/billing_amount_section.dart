import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/features/shop/controllers/product/cart_controller.dart';
import 'package:t_store/utils/helpers/pricing_calculator.dart';

import '../../../../../utils/constants/sizes.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final subTotal = controller.totalCartPrice.value;


    return Column(
      children: [
        //--- SubTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tổng: ', style: Theme.of(context).textTheme.bodyMedium,),
            Text('${NumberFormat('#,##0').format(subTotal)}đ', style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),

        //--- Shipping Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển: ', style: Theme.of(context).textTheme.bodyMedium,),
            Text(TPricingCalculator.calculateShippingCost(subTotal, 'VN'), style: Theme.of(context).textTheme.labelLarge,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),

        //--- Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí thuế: ', style: Theme.of(context).textTheme.bodyMedium,),
            Text(TPricingCalculator.calculateTax(subTotal, 'VN'), style: Theme.of(context).textTheme.labelLarge,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),

        //--- Oder Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Thành tiền: ', style: Theme.of(context).textTheme.bodyMedium,),
            Text('${NumberFormat('#,##0').format(TPricingCalculator.calculateTotalPrice(subTotal, 'VN'))}đ', style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),
      ],
    );
  }
}
