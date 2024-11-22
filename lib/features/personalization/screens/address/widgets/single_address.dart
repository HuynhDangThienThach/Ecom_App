import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../models/addressModel/AddressModel.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({super.key, required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = AddressController.instance;
    return Obx(() {
      final selectedAddressId = controller.selectedAddress.value.id;
      final selectedAddress = selectedAddressId == address.id;

      return Dismissible(
        key: Key(address.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Xác nhận xóa"),
                content: const Text("Bạn có chắc chắn muốn xóa địa chỉ này không?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Xóa"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) async {
          await controller.deleteAddress(address);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: InkWell(
          onTap: onTap,
          child: TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            width: double.infinity,
            backgroundColor: selectedAddress
                ? TColors.primary.withOpacity(0.5)
                : Colors.transparent,
            borderColor: selectedAddress
                ? Colors.transparent
                : dark
                ? TColors.darkGrey
                : TColors.grey,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Stack(
              children: [
                Positioned(
                  right: 5,
                  top: 0,
                  child: Icon(
                    selectedAddress ? Iconsax.tick_circle5 : null,
                    color: selectedAddress
                        ? dark
                        ? TColors.light
                        : TColors.dark
                        : null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Text(
                      address.phoneNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Text(address.toString(), softWrap: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}