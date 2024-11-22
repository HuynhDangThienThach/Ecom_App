import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/app.dart';
import 'package:t_store/features/shop/screens/chatBot/consts.dart';
import 'package:t_store/features/shop/screens/paymentStripe/const.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

//--- Entry point of Flutter App
Future<void> main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Thông báo Mediquick',
          channelDescription: 'Nhắc nhở uống thuốc'
      ),
    ],
    debug: true
  );

  // Todo: Add Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Todo: Init Local Storage
  await GetStorage.init();

  // Todo: Await Splash until other items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Todo: Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
        (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  // Todo: Initialize Authentication
  Gemini.init(apiKey: GEMINI_API_KEY);
  await setup();
  runApp(const App());
}

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}
void initState() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}
