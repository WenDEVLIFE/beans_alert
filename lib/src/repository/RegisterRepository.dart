import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterRepository {

  Future<bool> insertUser(String fullname, String email, String role, String password);
}

class RegisterRepositoryImpl implements RegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> insertUser(String fullname, String email, String role,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('User').doc(user.uid).set({
          'FullName': fullname,
          'Email': email,
          'Role': role,
          'Uid': user.uid,
          'CreatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (error) {
      throw Exception('Failed to register user: $error');
    }
  }
}