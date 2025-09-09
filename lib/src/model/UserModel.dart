import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      fullname: doc['FullName'] ?? '',
      email: doc['Email'] ?? '',
      role: doc['Role'] ?? '',
    );
  }
}