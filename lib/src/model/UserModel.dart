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

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullname: map['FullName'] ?? '',
      email: map['Email'] ?? '',
      role: map['Role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'FullName': fullname, 'Email': email, 'Role': role};
  }

  UserModel copyWith({
    String? id,
    String? fullname,
    String? email,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.fullname == fullname &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^ fullname.hashCode ^ email.hashCode ^ role.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullname: $fullname, email: $email, role: $role)';
  }
}