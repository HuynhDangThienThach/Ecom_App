import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/personalization/screens/settings/setting.dart';
import 'package:t_store/features/shop/screens/chatBot/chatBot.dart';
import 'package:t_store/features/shop/screens/home/home.dart';
import 'package:t_store/features/shop/screens/profileDS/profileDsScreen.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import 'features/shop/screens/store/store.dart';
import 'features/shop/screens/wishlist/wishlist.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    print(darkMode);
    return Scaffold(
      extendBody: true, // Ensures the background of the bottom app bar extends beyond the body
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: SpeedDial(
          backgroundColor: darkMode?  Colors.black: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: TColors.black,
          overlayOpacity: 0.5,
          closeManually: false,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.message),
              label: "Trợ lý AI",
              onTap: () => Get.to(const ChatBotScreen()),
            ),
            SpeedDialChild(
              child: const Icon(Icons.headset_mic),
              label: "Dược sĩ tư vấn",
              onTap: (){Get.to(const ProfileDsScreen());},
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: darkMode ? TColors.black : TColors.white,
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: NavigationBar(
                    selectedIndex: controller.selectedIndex.value,
                    onDestinationSelected: (index) => controller.selectedIndex.value = index,
                    backgroundColor: Colors.transparent, // Make the NavigationBar transparent
                    indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
                    destinations: const [
                      NavigationDestination(icon: Icon(Iconsax.home), label: 'Trang chủ'),
                      NavigationDestination(icon: Icon(Iconsax.shop), label: 'Danh mục'),
                      NavigationDestination(icon: Icon(Iconsax.heart), label: 'Yêu thích'),
                      NavigationDestination(icon: Icon(Iconsax.user), label: 'Cá nhân'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];
}
