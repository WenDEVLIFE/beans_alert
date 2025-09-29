import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ScheduledMessage.dart';

class ScheduledMessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'scheduledMessages';

  // Get all scheduled messages as a stream
  Stream<List<ScheduledMessage>> getScheduledMessages() {
    return _firestore
        .collection(_collection)
        .orderBy('scheduledTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ScheduledMessage.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Get pending scheduled messages (not yet sent)
  Stream<List<ScheduledMessage>> getPendingScheduledMessages() {
    return _firestore
        .collection(_collection)
        .where('isSent', isEqualTo: false)
        .orderBy('scheduledTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ScheduledMessage.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Get scheduled messages for a specific date
  Stream<List<ScheduledMessage>> getScheduledMessagesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection(_collection)
        .where('scheduledTime', isGreaterThanOrEqualTo: startOfDay)
        .where('scheduledTime', isLessThanOrEqualTo: endOfDay)
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ScheduledMessage.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Add a new scheduled message
  Future<void> addScheduledMessage(ScheduledMessage scheduledMessage) async {
    await _firestore
        .collection(_collection)
        .doc(scheduledMessage.id)
        .set(scheduledMessage.toMap());
  }

  // Update a scheduled message
  Future<void> updateScheduledMessage(ScheduledMessage scheduledMessage) async {
    await _firestore
        .collection(_collection)
        .doc(scheduledMessage.id)
        .update(scheduledMessage.toMap());
  }

  // Delete a scheduled message
  Future<void> deleteScheduledMessage(String messageId) async {
    await _firestore.collection(_collection).doc(messageId).delete();
  }

  // Mark message as sent
  Future<void> markAsSent(String messageId, DateTime sentAt) async {
    await _firestore.collection(_collection).doc(messageId).update({
      'isSent': true,
      'sentAt': sentAt.toIso8601String(),
    });
  }

  // Search scheduled messages
  Stream<List<ScheduledMessage>> searchScheduledMessages(String query) {
    return _firestore
        .collection(_collection)
        .orderBy('scheduledTime', descending: false)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs.map((doc) {
            return ScheduledMessage.fromMap(doc.data(), doc.id);
          }).toList();

          if (query.isEmpty) {
            return messages;
          }

          return messages.where((message) {
            final lowerQuery = query.toLowerCase();
            return message.senderName.toLowerCase().contains(lowerQuery) ||
                message.message.toLowerCase().contains(lowerQuery) ||
                message.recipientNames.any(
                  (name) => name.toLowerCase().contains(lowerQuery),
                ) ||
                message.recipientPhones.any((phone) => phone.contains(query));
          }).toList();
        });
  }
}
