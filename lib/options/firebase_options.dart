
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
    apiKey: 'AIzaSyDZBEsDbBJZEXZ1j6EASVBkPFTq1-yXaf4',
    appId: '1:298814361262:web:74432964f649e44b8a273f',
    messagingSenderId: '298814361262',
    projectId: 'brisca-b8871',
    authDomain: 'brisca-b8871.firebaseapp.com',
    storageBucket: 'brisca-b8871.appspot.com',
    measurementId: 'G-KJ2TCGN10L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUtvkQ9xx69EbssxbgCDuIEfdTLeax0NM',
    appId: '1:298814361262:android:fe44396a47bc37d28a273f',
    messagingSenderId: '298814361262',
    projectId: 'brisca-b8871',
    storageBucket: 'brisca-b8871.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCd-J5juCUAScMmY-kSLKScwgRFXUqDe54',
    appId: '1:298814361262:ios:eae6bf091ebb37c88a273f',
    messagingSenderId: '298814361262',
    projectId: 'brisca-b8871',
    storageBucket: 'brisca-b8871.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCd-J5juCUAScMmY-kSLKScwgRFXUqDe54',
    appId: '1:298814361262:ios:eae6bf091ebb37c88a273f',
    messagingSenderId: '298814361262',
    projectId: 'brisca-b8871',
    storageBucket: 'brisca-b8871.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZBEsDbBJZEXZ1j6EASVBkPFTq1-yXaf4',
    appId: '1:298814361262:web:d6025e5f207b8a248a273f',
    messagingSenderId: '298814361262',
    projectId: 'brisca-b8871',
    authDomain: 'brisca-b8871.firebaseapp.com',
    storageBucket: 'brisca-b8871.appspot.com',
    measurementId: 'G-8ZNKMM09D3',
  );

}
