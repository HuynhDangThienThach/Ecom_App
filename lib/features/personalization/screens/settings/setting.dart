import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/list_titles/settings_menu_title.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/map/screen/map_page.dart';
import 'package:t_store/features/personalization/screens/address/address.dart';
import 'package:t_store/features/personalization/screens/profile/profile.dart';
import 'package:t_store/features/shop/screens/cart/cart.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';

import '../../../../common/addData/addData.dart';
import '../../../../common/widgets/list_titles/user_profile_title.dart';
import '../../../shop/screens/order/order.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          //--- Header
          TPrimaryHeaderContainer(child: Column(
            children: [
              TAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white) ),),


            //--- User Profile Card
              TUserProfileTitle( onPressed: () => Get.to(() => const ProfileScreen()),),
              const SizedBox(height: TSizes.spaceBtwSections,),
            ],
          )),
          //--- Body
          Padding(
            padding:  const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
              //--- Account Settings
                const TSectionHeading(title: 'Account Settings', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                TSettingMenuTitle(icon: Iconsax.safe_home, title: 'My Addresses', subTitle: 'Set shopping delivery address', onTap: () => Get.to(() => const UserAddressScreen()),),
                TSettingMenuTitle(icon: Iconsax.shopping_cart, title: 'My Cart', subTitle: 'Add, remove products and move to checkout', onTap: () => Get.to(() => const CartScreen()),),
                TSettingMenuTitle(icon: Iconsax.location, title: 'Location', subTitle: 'Determine by exact coordinates on the map.', onTap: () => Get.to(() => const Map_Page()),),
                TSettingMenuTitle(icon: Iconsax.bag_tick, title: 'My Orders', subTitle: 'In-progress and Completed Orders', onTap: () => Get.to(() => const OrderScreen()),),
                const TSettingMenuTitle(icon: Iconsax.bank, title: 'Bank Account', subTitle: 'Withdraw balance to registered bank account'),
                const TSettingMenuTitle(icon: Iconsax.discount_shape, title: 'My Coupons', subTitle: 'List of all the discounted coupons'),
                const TSettingMenuTitle(icon: Iconsax.notification, title: 'Notifications', subTitle: 'Set any kind of notification message'),
                const TSettingMenuTitle(icon: Iconsax.security_card, title: 'Account Privacy', subTitle: 'Manage data usage and connected accounts'),
              //--- App Settings
                const SizedBox(height: TSizes.spaceBtwSections),
                const TSectionHeading(title: 'App Settings', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TSettingMenuTitle(icon: Iconsax.document_upload, title: 'Load Data', subTitle: "Upload Data to your Cloud Firebase", onTap: (){importJsonToFirestore();},),
                TSettingMenuTitle(icon: Iconsax.document_upload, title: 'Geolocation', subTitle: "Set recommendation based on location", trailing: Switch(value: true, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.security_user, title: 'Safe Mode', subTitle: "Search result is safe for all ages", trailing: Switch(value: false, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.image, title: 'HD Image Quality', subTitle: "Set image quality to be seen", trailing: Switch(value: false, onChanged: (value) {}),),
              //--- Logout Button
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () => Get.offAll(AuthenticationRepository.instance.logout()), child: const Text('Logout'),),
                ),
                const SizedBox(height: TSizes.spaceBtwSections * 2.5),
              ],
            ), ),
          ],
        ),
      ),
    );
  }
}
