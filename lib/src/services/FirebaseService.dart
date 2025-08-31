import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class FirebaseServices {
  static Future<void> run() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCGdshUog0aSImICPDs1epYFuaJbTqCAHU',
        appId: Platform.isIOS
            ?  '1:671405515090:ios:c34326a9fd8523264c5a8b'
            : '1:671405515090:android:08cd2a72403132074c5a8b',
        messagingSenderId: '671405515090',
        projectId: 'beans-alert-database',
        storageBucket: 'beans-alert-database.firebasestorage.app',
      ),
    );

    if (Firebase.apps.isEmpty) {
      print('Firebase is not initialized');
    } else {
      print('Firebase is initialized successfully');
    }
  }
}