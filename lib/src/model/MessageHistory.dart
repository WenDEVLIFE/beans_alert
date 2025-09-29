class MessageHistory {
  final String id;
  final String senderName;
  final String message;
  final String receiverName;
  final String receiverPhone;
  final DateTime timestamp;
  final bool sentSuccessfully;

  MessageHistory({
    required this.id,
    required this.senderName,
    required this.message,
    required this.receiverName,
    required this.receiverPhone,
    required this.timestamp,
    required this.sentSuccessfully,
  });

  factory MessageHistory.fromMap(Map<String, dynamic> map, String id) {
    return MessageHistory(
      id: id,
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPhone: map['receiverPhone'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      sentSuccessfully: map['sentSuccessfully'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'message': message,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'sentSuccessfully': sentSuccessfully,
    };
  }

  MessageHistory copyWith({
    String? id,
    String? senderName,
    String? message,
    String? receiverName,
    String? receiverPhone,
    DateTime? timestamp,
    bool? sentSuccessfully,
  }) {
    return MessageHistory(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      timestamp: timestamp ?? this.timestamp,
      sentSuccessfully: sentSuccessfully ?? this.sentSuccessfully,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageHistory &&
        other.id == id &&
        other.senderName == senderName &&
        other.message == message &&
        other.receiverName == receiverName &&
        other.receiverPhone == receiverPhone &&
        other.timestamp == timestamp &&
        other.sentSuccessfully == sentSuccessfully;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderName.hashCode ^
        message.hashCode ^
        receiverName.hashCode ^
        receiverPhone.hashCode ^
        timestamp.hashCode ^
        sentSuccessfully.hashCode;
  }

  @override
  String toString() {
    return 'MessageHistory(id: $id, senderName: $senderName, message: $message, receiverName: $receiverName, receiverPhone: $receiverPhone, timestamp: $timestamp, sentSuccessfully: $sentSuccessfully)';
  }
}
