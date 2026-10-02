// PLACEHOLDER — replace this whole file with the output of:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --out=lib/integrations/firebase/firebase_options.dart
//
// The values below are fake so the project compiles. FirebasePushService
// detects them (see firebaseIsConfigured) and skips Firebase.initializeApp —
// push stays off, local notifications still work — until you run the command.
// Do NOT hand-edit real values in here: the iOS SDK aborts the process on an
// API key that merely looks wrong.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'run `flutterfire configure`.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform - '
          'run `flutterfire configure`.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'replace-me',
    storageBucket: 'replace-me.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'replace-me',
    storageBucket: 'replace-me.appspot.com',
    iosBundleId: 'com.pentacrew.pentaCrew',
  );
}
