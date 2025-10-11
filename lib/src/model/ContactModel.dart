class ContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String purokNumber;

  ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.purokNumber,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map, String id) {
    return ContactModel(
      id: id,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      purokNumber: map['purokNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'purokNumber': purokNumber,
    };
  }

  ContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? purokNumber,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      purokNumber: purokNumber ?? this.purokNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactModel &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.purokNumber == purokNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        purokNumber.hashCode;
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, purokNumber: $purokNumber)';
  }
}
