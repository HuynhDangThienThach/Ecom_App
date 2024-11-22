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
import '../../../../common/widgets/notifycation/notificationRemind.dart';
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
              TAppBar(title: Text('Tài khoản', style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white) ),),


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
                const TSectionHeading(title: 'Cài đặt tài khoản', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                TSettingMenuTitle(icon: Iconsax.safe_home, title: 'Địa chỉ của tôi', subTitle: 'Đặt địa chỉ giao hàng mua sắm', onTap: () => Get.to(() => const UserAddressScreen()),),
                TSettingMenuTitle(icon: Iconsax.shopping_cart, title: 'Giỏ hàng của tôi', subTitle: 'Thêm, xóa sản phẩm và chuyển đến trang thanh toán', onTap: () => Get.to(() => const CartScreen()),),
                TSettingMenuTitle(icon: Iconsax.bag_tick, title: 'Đơn hàng của tôi', subTitle: 'Đơn hàng đang thực hiện và đã hoàn thành', onTap: () => Get.to(() => const OrderScreen()),),
                TSettingMenuTitle(icon: Iconsax.notification, title: 'Đặt nhắc nhở dùng thuốc', subTitle: 'Đặt bất kỳ loại tin nhắn thông báo nào', onTap: () => Get.to(() => const NotifyCationRemindScreen()),),
                const TSettingMenuTitle(icon: Iconsax.bank, title: 'Tài khoản ngân hàng', subTitle: 'Rút số dư về tài khoản ngân hàng đã đăng ký'),
                const TSettingMenuTitle(icon: Iconsax.discount_shape, title: 'Phiếu giảm giá của tôi', subTitle: 'Danh sách tất cả các phiếu giảm giá'),
                const TSettingMenuTitle(icon: Iconsax.security_card, title: 'Account Privacy', subTitle: 'Quản lý việc sử dụng dữ liệu và các tài khoản được kết nối'),
              //--- App Settings
                const SizedBox(height: TSizes.spaceBtwSections),
                const TSectionHeading(title: 'Cài đặt ứng dụng', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TSettingMenuTitle(icon: Iconsax.document_upload, title: 'Tải dữ liệu', subTitle: "Tải dữ liệu lên Cloud Firebase của bạn", onTap: (){importJsonToFirestore();},),
                TSettingMenuTitle(icon: Iconsax.document_upload, title: 'Vị trí địa lý', subTitle: "Đặt đề xuất dựa trên vị trí", trailing: Switch(value: true, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.security_user, title: 'Chế độ an toàn', subTitle: "Kết quả tìm kiếm an toàn cho mọi lứa tuổi", trailing: Switch(value: false, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.image, title: 'Chất lượng hình ảnh HD', subTitle: "Đặt chất lượng hình ảnh để xem", trailing: Switch(value: false, onChanged: (value) {}),),
              //--- Logout Button
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () => Get.offAll(AuthenticationRepository.instance.logout()), child: const Text('Đăng xuất'),),
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
