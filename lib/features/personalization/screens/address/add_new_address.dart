import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/validators/validation.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text("Thêm địa chỉ mới"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) => TValidator.validateEmptyText("Tên", value),
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: "Tên"),),
                const SizedBox(height: TSizes.spaceBtwInputFields,),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: TValidator.validatePhoneNumber,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: "Số điện thoại"),),
                const SizedBox(height: TSizes.spaceBtwInputFields,),
                Row(
                  children: [
                    Expanded(flex: 5 ,child: TextFormField(
                      controller: controller.street,
                      validator: (value) => TValidator.validateEmptyText("Địa chỉ", value),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building_31), labelText: "Địa chỉ"),)),
                    const SizedBox(width: TSizes.spaceBtwInputFields,),
                    Expanded(flex: 5,child: TextFormField(
                      controller: controller.postalCode,
                      validator: (value) => TValidator.validateEmptyText("Mã bưu chính", value),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.code), labelText: "Mã bưu chính"),)),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields,),
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: controller.city,
                      validator: (value) => TValidator.validateEmptyText("Thành phố", value),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: "Thành phố"),)),
                    const SizedBox(width: TSizes.spaceBtwInputFields,),
                    Expanded(child: TextFormField(
                      controller: controller.state,
                      validator: (value) => TValidator.validateEmptyText("Đường", value),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.activity), labelText: "Đường"),)),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields,),
                TextFormField(
                  controller: controller.country,
                  validator: (value) => TValidator.validateEmptyText("Quốc gia", value),
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: "Quốc gia"),),
                const SizedBox(height: TSizes.defaultSpace,),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.addNewAddresses(), child: const Text('Lưu'),),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}