class ScheduledMessage {
  final String id;
  final String senderName;
  final String message;
  final List<String> recipientPhones; // List of phone numbers
  final List<String> recipientNames; // List of recipient names
  final DateTime scheduledTime;
  final DateTime createdAt;
  final bool isSent;
  final DateTime? sentAt;

  ScheduledMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.recipientPhones,
    required this.recipientNames,
    required this.scheduledTime,
    required this.createdAt,
    this.isSent = false,
    this.sentAt,
  });

  factory ScheduledMessage.fromMap(Map<String, dynamic> map, String id) {
    return ScheduledMessage(
      id: id,
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      recipientPhones: List<String>.from(map['recipientPhones'] ?? []),
      recipientNames: List<String>.from(map['recipientNames'] ?? []),
      scheduledTime: DateTime.parse(map['scheduledTime']),
      createdAt: DateTime.parse(map['createdAt']),
      isSent: map['isSent'] ?? false,
      sentAt: map['sentAt'] != null ? DateTime.parse(map['sentAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'message': message,
      'recipientPhones': recipientPhones,
      'recipientNames': recipientNames,
      'scheduledTime': scheduledTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isSent': isSent,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  ScheduledMessage copyWith({
    String? id,
    String? senderName,
    String? message,
    List<String>? recipientPhones,
    List<String>? recipientNames,
    DateTime? scheduledTime,
    DateTime? createdAt,
    bool? isSent,
    DateTime? sentAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      recipientPhones: recipientPhones ?? this.recipientPhones,
      recipientNames: recipientNames ?? this.recipientNames,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      createdAt: createdAt ?? this.createdAt,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduledMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScheduledMessage(id: $id, senderName: $senderName, message: $message, recipientPhones: $recipientPhones, scheduledTime: $scheduledTime, isSent: $isSent)';
  }
}
