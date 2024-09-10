import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/loaders/animation_loader.dart';
import 'package:t_store/features/shop/controllers/product/order_controller.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class TOderListItem extends StatelessWidget {
  const TOderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final dark = THelperFunctions.isDarkMode(context);
    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (_, snapshot) {
        final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops! No Orders Yet!',
            animation: TImages.orderCompletedAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () =>Get.off(() => const NavigationMenu()),
        );

        final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, nothingFound: emptyWidget);
        if (response != null) return response;

        final orders = snapshot.data!;
        return ListView.separated(
         shrinkWrap: true,
         itemCount: orders.length,
         separatorBuilder: (_,__) => const SizedBox(height: TSizes.spaceBtwItems,),
         itemBuilder: (_, index) {
           final order = orders[index];
           return TRoundedContainer(
             showBorder: true,
             padding: const EdgeInsets.all(TSizes.md),
             backgroundColor: dark ? TColors.dark : TColors.light,
             child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   //--- Row 1
                   Row(
                     children: [
                       //--- Icon
                       const Icon(Iconsax.ship),
                       const SizedBox(width: TSizes.spaceBtwItems / 2,),

                       //--- Status & Date
                       Expanded(
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(order.orderStatusText, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary, fontWeightDelta: 1)),
                             Text(order.formattedOrderDate, style: Theme.of(context).textTheme.headlineSmall,),
                           ],
                         ),
                       ),

                       //--- Icon
                       IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm,))
                     ],
                   ),
                   const SizedBox(height: TSizes.spaceBtwItems,),
                   //--- Row 2
                   Row(
                     children: [
                       Expanded(
                         child: Row(
                           children: [
                             //--- Icon
                             const Icon(Iconsax.tag),
                             const SizedBox(width: TSizes.spaceBtwItems / 2,),

                             //--- Status & Date
                             Expanded(
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Order", style: Theme.of(context).textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                   Text(order.id, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),

                       Expanded(
                         child: Row(
                           children: [
                             //--- Icon
                             const Icon(Iconsax.calendar),
                             const SizedBox(width: TSizes.spaceBtwItems / 2,),

                             //--- Status & Date
                             Expanded(
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Shipping Date", style: Theme.of(context).textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                   Text(order.formattedDeliveryDate, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ]
             ),
           );
         }
        );
      }
    );
  }
}
