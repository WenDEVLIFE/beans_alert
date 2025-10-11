class ScheduledMessage {
  final String id;
  final String senderName;
  final String senderRole;
  final String message;
  final List<String> recipientPhones; // List of phone numbers
  final List<String> recipientEmails; // List of email addresses
  final List<String> recipientNames; // List of recipient names
  final bool sendSMS; // Whether to send SMS
  final bool sendEmail; // Whether to send Email
  final DateTime scheduledTime;
  final DateTime createdAt;
  final bool isSent;
  final DateTime? sentAt;

  ScheduledMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.recipientPhones,
    required this.recipientEmails,
    required this.recipientNames,
    required this.sendSMS,
    required this.sendEmail,
    required this.scheduledTime,
    required this.createdAt,
    this.isSent = false,
    this.sentAt,
  });

  factory ScheduledMessage.fromMap(Map<String, dynamic> map, String id) {
    return ScheduledMessage(
      id: id,
      senderName: map['senderName'] ?? '',
      senderRole: map['senderRole'] ?? '',
      message: map['message'] ?? '',
      recipientPhones: List<String>.from(map['recipientPhones'] ?? []),
      recipientEmails: List<String>.from(map['recipientEmails'] ?? []),
      recipientNames: List<String>.from(map['recipientNames'] ?? []),
      sendSMS: map['sendSMS'] ?? true,
      sendEmail: map['sendEmail'] ?? true,
      scheduledTime: DateTime.parse(map['scheduledTime']),
      createdAt: DateTime.parse(map['createdAt']),
      isSent: map['isSent'] ?? false,
      sentAt: map['sentAt'] != null ? DateTime.parse(map['sentAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderRole': senderRole,
      'message': message,
      'recipientPhones': recipientPhones,
      'recipientEmails': recipientEmails,
      'recipientNames': recipientNames,
      'sendSMS': sendSMS,
      'sendEmail': sendEmail,
      'scheduledTime': scheduledTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isSent': isSent,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  ScheduledMessage copyWith({
    String? id,
    String? senderName,
    String? senderRole,
    String? message,
    List<String>? recipientPhones,
    List<String>? recipientEmails,
    List<String>? recipientNames,
    bool? sendSMS,
    bool? sendEmail,
    DateTime? scheduledTime,
    DateTime? createdAt,
    bool? isSent,
    DateTime? sentAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      message: message ?? this.message,
      recipientPhones: recipientPhones ?? this.recipientPhones,
      recipientEmails: recipientEmails ?? this.recipientEmails,
      recipientNames: recipientNames ?? this.recipientNames,
      sendSMS: sendSMS ?? this.sendSMS,
      sendEmail: sendEmail ?? this.sendEmail,
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
    return 'ScheduledMessage(id: $id, senderName: $senderName, senderRole: $senderRole, message: $message, recipientPhones: $recipientPhones, recipientEmails: $recipientEmails, sendSMS: $sendSMS, sendEmail: $sendEmail, scheduledTime: $scheduledTime, isSent: $isSent)';
  }
}
