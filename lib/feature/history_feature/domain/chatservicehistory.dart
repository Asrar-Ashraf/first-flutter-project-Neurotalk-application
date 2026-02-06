import 'package:cloud_firestore/cloud_firestore.dart';

class Chatservicehistory {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔥 1. نیا Session بنائیں
  Future<String> createSession(String firstMessage, String userId) async {
    final sessionId = _firestore.collection('sessions').doc().id;

    // Session info save
    await _firestore.collection('sessions').doc(sessionId).set({
      'title': firstMessage.length > 25
          ? firstMessage.substring(0, 25)
          : firstMessage,
      'userId': userId,
      'firstMessage': firstMessage,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // پہلا message save
    await _firestore.collection('chats').doc(userId).collection(sessionId).add({
      'text': firstMessage,
      'isUser': true,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return sessionId;
  }

  // 🔥 2. Session میں message add کریں
  Future<void> addToSession(
    String message,
    bool isUser,
    String userId,
    String sessionId,
  ) async {
    await _firestore.collection('chats').doc(userId).collection(sessionId).add({
      'text': message,
      'isUser': isUser,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 3. Session messages load کریں
  Stream<QuerySnapshot> getSessionMessages(String userId, String sessionId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection(sessionId)
        .orderBy('timestamp')
        .snapshots();
  }

  // 🔥 4. تمام sessions list
  Stream<QuerySnapshot> getAllSessions(String userId) {
    return _firestore
        .collection('sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
