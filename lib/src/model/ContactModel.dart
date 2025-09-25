class ContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String purokNumber;

  ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.purokNumber,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map, String id) {
    return ContactModel(
      id: id,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      purokNumber: map['purokNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'purokNumber': purokNumber,
    };
  }

  ContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? purokNumber,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
        other.purokNumber == purokNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        purokNumber.hashCode;
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, phoneNumber: $phoneNumber, purokNumber: $purokNumber)';
  }
}
