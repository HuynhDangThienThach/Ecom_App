import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TDeviceUtils {
  // Ẩn bàn phím ảo
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // Đặt màu cho thanh trạng thái
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  // Kiểm tra thiết bị có ở chế độ ngang không
  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  // Kiểm tra thiết bị có ở chế độ dọc không
  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  // Đặt chế độ hiển thị toàn màn hình
  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
        enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  // Lấy chiều cao của màn hình
  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  // Lấy chiều rộng của màn hình
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Lấy tỉ lệ pixel của thiết bị
  static double getPixelRatio() {
    return MediaQuery.of(Get.context!).devicePixelRatio;
  }

  // Lấy chiều cao của thanh trạng thái
  static double getStatusBarHeight() {
    return MediaQuery.of(Get.context!).padding.top;
  }

  // Lấy chiều cao của thanh điều hướng dưới cùng
  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  // Lấy chiều cao của thanh ứng dụng
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  // Lấy chiều cao của bàn phím ảo
  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets;
    return viewInsets.bottom;
  }

  // Kiểm tra xem bàn phím ảo có hiển thị hay không
  static Future<bool> isKeyboardVisible() async {
    final viewInsets = View.of(Get.context!).viewInsets;
    return viewInsets.bottom > 0;
  }

  // Kiểm tra xem ứng dụng đang chạy trên thiết bị vật lý hay không
  static Future<bool> isPhysicalDevice() async {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // Kích hoạt phản hồi rung
  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  // Đặt các hướng màn hình ưa thích
  static Future<void> setPreferredOrientations(
      List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  // Ẩn thanh trạng thái
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  // Hiển thị lại thanh trạng thái
  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  // Kiểm tra kết nối internet
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Kiểm tra xem ứng dụng đang chạy trên hệ điều hành iOS hay không
  static bool isIOS() {
    return Platform.isIOS;
  }

  // Kiểm tra xem ứng dụng đang chạy trên hệ điều hành Android hay không
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  // Mở một URL trên trình duyệt mặc định của thiết bị
  static void launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Thêm các phương thức tiện ích thiết bị khác theo yêu cầu cụ thể của bạn
}
