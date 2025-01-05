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
    apiKey: 'AIzaSyB-fPRjwtoTz0x6PJZQB00RemQz4kkvDeo',
    appId: '1:464505140988:web:4e00dd486c09341ebec979',
    messagingSenderId: '464505140988',
    projectId: 'tripplaner-6fccd',
    authDomain: 'tripplaner-6fccd.firebaseapp.com',
    storageBucket: 'tripplaner-6fccd.firebasestorage.app',
    measurementId: 'G-J4W799BQ0P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnsayu1eFzw-ES2TKWa6nxa0b-uPQ1KhA',
    appId: '1:464505140988:android:5abbfc8d12195c09bec979',
    messagingSenderId: '464505140988',
    projectId: 'tripplaner-6fccd',
    storageBucket: 'tripplaner-6fccd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgR5At-mQrs4RWO8lL5T2NL88YPe3VUP8',
    appId: '1:464505140988:ios:a24f3bcff47ea7a2bec979',
    messagingSenderId: '464505140988',
    projectId: 'tripplaner-6fccd',
    storageBucket: 'tripplaner-6fccd.firebasestorage.app',
    iosBundleId: 'com.example.tripplaner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgR5At-mQrs4RWO8lL5T2NL88YPe3VUP8',
    appId: '1:464505140988:ios:a24f3bcff47ea7a2bec979',
    messagingSenderId: '464505140988',
    projectId: 'tripplaner-6fccd',
    storageBucket: 'tripplaner-6fccd.firebasestorage.app',
    iosBundleId: 'com.example.tripplaner',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB-fPRjwtoTz0x6PJZQB00RemQz4kkvDeo',
    appId: '1:464505140988:web:b67baf533c32efd2bec979',
    messagingSenderId: '464505140988',
    projectId: 'tripplaner-6fccd',
    authDomain: 'tripplaner-6fccd.firebaseapp.com',
    storageBucket: 'tripplaner-6fccd.firebasestorage.app',
    measurementId: 'G-47JHG0NWL8',
  );

}