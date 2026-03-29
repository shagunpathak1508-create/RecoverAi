// File generated manually from Firebase Console web config.
// Project: recoverai-af95c

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for the RecoverAI project.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not configured for this project.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS is not configured for this project.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows is not configured for this project.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux is not configured for this project.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  // ── Web Configuration ──────────────────────────────────────────────────
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUJF3aSrV0hPt9XB903P5C2RzdrnuiAU4',
    appId: '1:126265986939:web:d095a2f1b6d151ef0037de',
    messagingSenderId: '126265986939',
    projectId: 'recoverai-af95c',
    authDomain: 'recoverai-af95c.firebaseapp.com',
    storageBucket: 'recoverai-af95c.firebasestorage.app',
  );

  // ── Android Configuration ─────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNnXfBDIpmWZqGMVllFZ5v_6GlgNnLWF8',
    appId: '1:126265986939:android:459ae759ae1054ce0037de',
    messagingSenderId: '126265986939',
    projectId: 'recoverai-af95c',
    storageBucket: 'recoverai-af95c.firebasestorage.app',
  );
}
