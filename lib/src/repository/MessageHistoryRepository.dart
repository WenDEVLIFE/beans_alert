import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/MessageHistory.dart';

class MessageHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _messageHistory =>
      _firestore.collection('messageHistory');

  // Get all message history ordered by timestamp (newest first)
  Stream<List<MessageHistory>> getMessageHistory() {
    return _messageHistory
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageHistory.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  // Add a new message history entry
  Future<void> addMessageHistory(MessageHistory messageHistory) async {
    await _messageHistory.doc(messageHistory.id).set(messageHistory.toMap());
  }

  // Delete a message history entry
  Future<void> deleteMessageHistory(String messageId) async {
    await _messageHistory.doc(messageId).delete();
  }

  // Search message history by receiver name or phone
  Stream<List<MessageHistory>> searchMessageHistory(String query) {
    return _messageHistory
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                return MessageHistory.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
              })
              .where(
                (message) =>
                    message.receiverName.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    message.receiverPhone.contains(query) ||
                    message.message.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
        });
  }

  // Get message history for a specific date range
  Stream<List<MessageHistory>> getMessageHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _messageHistory
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
        )
        .where('timestamp', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageHistory.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
}
