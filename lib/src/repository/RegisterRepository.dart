import 'package:beans_alert/src/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterRepository {
  Future<bool> insertUser(
    String fullname,
    String email,
    String role,
    String password,
  );
  Future<List<UserModel>> getAllUsers();
  Future<bool> updateUser(
    String userId,
    String fullname,
    String email,
    String role,
  );
  Future<bool> deleteUser(String userId);
  Future<UserModel?> getUserById(String userId);
}

class RegisterRepositoryImpl implements RegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> insertUser(
    String fullname,
    String email,
    String role,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
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

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('User').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch users: $error');
    }
  }

  @override
  Future<bool> updateUser(
    String userId,
    String fullname,
    String email,
    String role,
  ) async {
    try {
      await _firestore.collection('User').doc(userId).update({
        'FullName': fullname,
        'Email': email,
        'Role': role,
        'UpdatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (error) {
      throw Exception('Failed to update user: $error');
    }
  }

  @override
  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection('User').doc(userId).delete();
      return true;
    } catch (error) {
      throw Exception('Failed to delete user: $error');
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('User')
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (error) {
      throw Exception('Failed to fetch user: $error');
    }
  }
}
