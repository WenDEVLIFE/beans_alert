import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepository {
  Future<Map<String, dynamic>> login(String email, String password);
}

class LoginRepositoryImpl implements LoginRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('User').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }

}

