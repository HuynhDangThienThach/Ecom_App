// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDlPD0BBzoR69mTw1Ea7vJa3nrKTHX13XE',
    appId: '1:411647451440:web:95bd33bacf91f4ddbda8f5',
    messagingSenderId: '411647451440',
    projectId: 'ecommerceapp-b5f5c',
    authDomain: 'ecommerceapp-b5f5c.firebaseapp.com',
    storageBucket: 'ecommerceapp-b5f5c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdUsKlDuzh27jfUE5lsvSa-3jNU2RzDFE',
    appId: '1:411647451440:android:69a11565bd88adecbda8f5',
    messagingSenderId: '411647451440',
    projectId: 'ecommerceapp-b5f5c',
    storageBucket: 'ecommerceapp-b5f5c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaHMlehQSUI8bPIKcFVl6BeiqnNKlVQY8',
    appId: '1:411647451440:ios:18ce3bac0fd83527bda8f5',
    messagingSenderId: '411647451440',
    projectId: 'ecommerceapp-b5f5c',
    storageBucket: 'ecommerceapp-b5f5c.appspot.com',
    androidClientId: '411647451440-sdpe4vah25dl9bmang45n1q55vbp8eo7.apps.googleusercontent.com',
    iosClientId: '411647451440-51e9a00r6ra3597sh2vsmi8nsd5oj864.apps.googleusercontent.com',
    iosBundleId: 'com.example.tStore',
  );

}