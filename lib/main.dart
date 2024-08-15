import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

//--- Entry point of Flutter App
Future<void> main() async {
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

  runApp(const App());
}
