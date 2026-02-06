import 'package:NeuroTalk/feature/chat_feature/data/chatService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetChatService {
  final ChatService chatService;
  final Color lightPink1;

  ResetChatService({required this.chatService, required this.lightPink1});

  // 🔥 MAIN RESET FUNCTION
  Future<bool> resetChat({
    required BuildContext context,
    required String? userId,
    required VoidCallback onSuccess,
    required VoidCallback onScrollToBottom,
  }) async {
    final bool? confirm = await _showConfirmDialog(context);

    if (confirm == true && userId != null) {
      try {
        await chatService.clearHistory(userId); // ✅ Fixed!

        _showSuccess(context);
        onSuccess();
        onScrollToBottom();
        return true;
      } catch (e) {
        _showError(context, e.toString());
        return false;
      }
    }
    return false;
  }

  // 🔥 Confirmation Dialog
  Future<bool?> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: lightPink1,
        title: Text("Clear Chat?", style: TextStyle(color: Colors.red)),
        content: Text("All messages will be permanently deleted!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 🔥 Success Message
  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Chat cleared successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 🔥 Error Message
  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("❌ Error: $error")));
  }
}
