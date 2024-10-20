import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart';

import '../../../../../utils/constants/sizes.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection ({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSectionHeading(title: "Địa chỉ giao hàng", buttonTitle: "Thay đổi", onPressed: () => addressController.selectNewAddressPopup(context),),
          addressController.selectedAddress.value.id.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressController.selectedAddress.value.name, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.spaceBtwItems / 2,),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 16,),
                    const SizedBox(width: TSizes.spaceBtwItems,),
                    Text(addressController.selectedAddress.value.phoneNumber, style: Theme.of(context).textTheme.bodyMedium,),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2,),
                Row(
                  children: [
                    const Icon(Icons.location_history, color: Colors.grey, size: 16),
                    const SizedBox(width: TSizes.spaceBtwItems,),
                    Expanded(child: Text(addressController.selectedAddress.value.toString(), style: Theme.of(context).textTheme.bodyMedium, softWrap: true,))
                  ],
                )
              ],
            )
          : Text('Chọn địa chỉ', style: Theme.of(context).textTheme.bodyMedium,)
        ],
      ),
    );
  }
}
