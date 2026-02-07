import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // API KEY
  static const String _apiKey = 'Enter you own API key';

  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ FIXED: Content object pass
  Future<String> sendMessage(String message, {String? userId}) async {
    try {
      final uid = userId ?? _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) return '❌ Please login first';

      // 1️⃣ User message save
      await _saveMessage(uid, message, true);

      // 2️⃣ FIXED: Content.text() use
      final chat = _model.startChat();
      final content = Content.text(message); // ✅ Fixed line
      final response = await chat.sendMessage(content); // ✅ Content pass
      final botReply = response.text ?? '🤖 No response received';

      // 3️⃣ Bot reply save
      await _saveMessage(uid, botReply, false);

      return botReply;
    } catch (e) {
      print('❌ Error: $e');
      return '❌ Error: ${e.toString()}';
    }
  }

  // 💾 Save message to Firestore
  Future<void> _saveMessage(String userId, String text, bool isUser) async {
    await _firestore.collection('chats').doc(userId).collection('messages').add(
      {
        'text': text,
        'isUser': isUser,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  // 📋 Get chat history Stream
  Stream<QuerySnapshot> getChatStream(String userId) {
    return _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  // 🗑️ Clear chat history
  Future<void> clearHistory(String userId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearChat(String userId) async {
    try {
      print('🗑️ Deleting chat for user: $userId');

      // آپ کا exact structure (getChatStream سے match)
      final messagesRef = _firestore
          .collection('chat_history')
          .doc(userId)
          .collection('messages');

      final snapshot = await messagesRef.get();
      print('📊 Found ${snapshot.docs.length} messages');

      if (snapshot.docs.isEmpty) {
        print('ℹ️ No messages to delete');
        return;
      }

      // Batch delete
      WriteBatch batch = _firestore.batch();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
        print('🗑️ Deleting: ${doc.id}');
      }

      await batch.commit();
      print('✅ ALL MESSAGES DELETED!');
    } catch (e) {
      print('❌ DELETE ERROR: $e');
      rethrow;
    }
  }

  Future<void> deleteAllUserData(String userId) async {
    print('🗑️ Deleting ALL data for user: $userId');

    final batch = _firestore.batch();

    try {
      // 1. Delete ALL sessions
      final sessionsSnapshot = await _firestore
          .collection('sessions')
          .where('userId', isEqualTo: userId)
          .get();

      for (var sessionDoc in sessionsSnapshot.docs) {
        batch.delete(sessionDoc.reference);

        // 2. Delete chats for this session
        final chatCollection = _firestore
            .collection('chats')
            .doc(userId)
            .collection(sessionDoc.id);
        final chatSnapshot = await chatCollection.get();

        for (var chatDoc in chatSnapshot.docs) {
          batch.delete(chatDoc.reference);
        }
      }

      // 🔥 Commit batch (max 500 operations)
      await batch.commit();

      print(
        '✅ ALL sessions (${sessionsSnapshot.docs.length}) + chats DELETED for $userId',
      );
    } catch (e) {
      print('❌ Delete error: $e');
      rethrow;
    }
  }
}
