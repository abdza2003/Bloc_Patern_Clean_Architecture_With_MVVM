// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAHQQiSjZT9KrgGSC1NtTlcgr0x0E1An_I',
    appId: '1:280124347573:web:ab4e22f72b20a6caac5afc',
    messagingSenderId: '280124347573',
    projectId: 'medrese-a1ee0',
    authDomain: 'medrese-a1ee0.firebaseapp.com',
    storageBucket: 'medrese-a1ee0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKqMKDp41H1AiutmAYnp2m2qmGy3t6i9s',
    appId: '1:280124347573:android:7eb7f8365bfa268bac5afc',
    messagingSenderId: '280124347573',
    projectId: 'medrese-a1ee0',
    storageBucket: 'medrese-a1ee0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuUdDrlgrrBp9WffC5igeuTzAs_7oJEjQ',
    appId: '1:280124347573:ios:1e87f5df07da35eeac5afc',
    messagingSenderId: '280124347573',
    projectId: 'medrese-a1ee0',
    storageBucket: 'medrese-a1ee0.appspot.com',
    iosClientId: '280124347573-eef87rjrtmq9teaobpd69m6th1uhhc46.apps.googleusercontent.com',
    iosBundleId: 'com.yes.mederes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCuUdDrlgrrBp9WffC5igeuTzAs_7oJEjQ',
    appId: '1:280124347573:ios:1e87f5df07da35eeac5afc',
    messagingSenderId: '280124347573',
    projectId: 'medrese-a1ee0',
    storageBucket: 'medrese-a1ee0.appspot.com',
    iosClientId: '280124347573-eef87rjrtmq9teaobpd69m6th1uhhc46.apps.googleusercontent.com',
    iosBundleId: 'com.yes.mederes',
  );
}
