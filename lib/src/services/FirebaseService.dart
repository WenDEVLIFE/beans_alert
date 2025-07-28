import 'package:firebase_core/firebase_core.dart';

class FirebaseServices {
  static Future<void> run() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCGdshUog0aSImICPDs1epYFuaJbTqCAHU',
        appId: '1:671405515090:android:08cd2a72403132074c5a8b',
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