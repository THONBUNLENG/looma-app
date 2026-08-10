import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for web. '
        'Please run `flutterfire configure` to generate this file.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6lI3ThjwE5p7itoXlscDIr197nZ84ZGw',
    appId: '1:561028849572:android:cd07543f315a7b4ef2eb31',
    messagingSenderId: '561028849572',
    projectId: 'ecommers-62c2d',
    storageBucket: 'ecommers-62c2d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6lI3ThjwE5p7itoXlscDIr197nZ84ZGw',
    appId: '1:561028849572:ios:cd07543f315a7b4ef2eb31',
    messagingSenderId: '561028849572',
    projectId: 'ecommers-62c2d',
    storageBucket: 'ecommers-62c2d.firebasestorage.app',
    iosBundleId: 'com.example.shoppingApp',
  );
}
