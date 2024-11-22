import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/common/widgets/shimmers/shimmer.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/personalization/controllers/user_controller.dart';
import 'package:t_store/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:t_store/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
        appBar: const TAppBar(showBackArrow: true, title: Text('Hồ sơ'),),
        //--- Body
        body: SingleChildScrollView(
          child: Padding(
            padding : const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                //--- Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Obx(() {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty? networkImage : TImages.user;
                        return controller.imageUploading.value ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                            : TCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty,);
                      }),
                      TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: const Text('Thay đổi ảnh đại diện')),
                    ],
                  ),
                ),

                //--- Details
                const SizedBox(height: TSizes.spaceBtwItems / 2,),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                //--- Heading Profile Info
                const TSectionHeading(title: 'Thông tin hồ sơ', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Tên', value: controller.user.value.fullName,),
                TProfileMenu(onPressed: () {}, title: 'Tên người dùng', value: controller.user.value.userName,),

                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                //--- Heading Personal Info
                const TSectionHeading(title: 'Thông tin cá nhân', showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                TProfileMenu(onPressed: () {}, title: 'ID người dùng', value: controller.user.value.id, icon: Iconsax.copy,),
                TProfileMenu(onPressed: () {}, title: 'Email', value: controller.user.value.email,),
                TProfileMenu(onPressed: () {}, title: 'Số điện thoại', value: controller.user.value.phoneNumber,),
                TProfileMenu(onPressed: () {}, title: 'Giới tính', value: 'Male',),
                TProfileMenu(onPressed: () {}, title: 'Ngày sinh', value: '04, 12, 2003',),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                Center(
                    child: TextButton(
                      onPressed: () => controller.deleteAccountWarningPopup(),
                      child: const Text('Xóa tài khoản', style: TextStyle(color: Colors.red),),
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}