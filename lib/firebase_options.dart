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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDBx6iyq_OBsW0nuKNBXSy7z2-IK2B_zJs',
    appId: '1:447439854738:web:cbdaceb3c57f957dd25a4b',
    messagingSenderId: '447439854738',
    projectId: 'gradution-39820',
    authDomain: 'gradution-39820.firebaseapp.com',
    storageBucket: 'gradution-39820.firebasestorage.app',
    measurementId: 'G-5S96EKQMKQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuPWCaMq6bY_DPeyFZwJ8s_s3IyQw_1PY',
    appId: '1:447439854738:android:31bf558f04794bebd25a4b',
    messagingSenderId: '447439854738',
    projectId: 'gradution-39820',
    storageBucket: 'gradution-39820.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHyhB77ZFw_2sAA3slfp1PppiVJskSxQo',
    appId: '1:447439854738:ios:dea423f0dc4b05d3d25a4b',
    messagingSenderId: '447439854738',
    projectId: 'gradution-39820',
    storageBucket: 'gradution-39820.firebasestorage.app',
    iosBundleId: 'com.example.grow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHyhB77ZFw_2sAA3slfp1PppiVJskSxQo',
    appId: '1:447439854738:ios:dea423f0dc4b05d3d25a4b',
    messagingSenderId: '447439854738',
    projectId: 'gradution-39820',
    storageBucket: 'gradution-39820.firebasestorage.app',
    iosBundleId: 'com.example.grow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDBx6iyq_OBsW0nuKNBXSy7z2-IK2B_zJs',
    appId: '1:447439854738:web:00b50ab09a25d88fd25a4b',
    messagingSenderId: '447439854738',
    projectId: 'gradution-39820',
    authDomain: 'gradution-39820.firebaseapp.com',
    storageBucket: 'gradution-39820.firebasestorage.app',
    measurementId: 'G-LDTJ9C1FQN',
  );
}
