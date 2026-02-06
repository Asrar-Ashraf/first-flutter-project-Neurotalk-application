import 'package:NeuroTalk/feature/chat_feature/data/chatService.dart';
import 'package:NeuroTalk/feature/chat_feature/domain/resetchatservice.dart';
import 'package:NeuroTalk/feature/chat_feature/domain/voiceservice.dart';
import 'package:NeuroTalk/feature/chat_feature/widget/chatcustomcontainercliper.dart';
import 'package:NeuroTalk/feature/history_feature/domain/chatservicehistory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/data/chatService.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/domain/resetchatservice.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/domain/voiceservice.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/widget/chatcustomcontainercliper.dart';
// import 'package:flutter_chatboot_app/feature/history_feature/domain/chatservicehistory.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  static const Color lightRed = Color.fromARGB(255, 80, 107, 239);
  static const Color lightPink = Color.fromARGB(255, 128, 191, 220);
  static const Color lightPink1 = Color.fromARGB(255, 235, 242, 246);
  static const Color pureWhite = Color(0xFFFFFFFF);

  final ChatService _chatService = ChatService();
  final Chatservicehistory _chatservicehistory = Chatservicehistory();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 🔥 Scroll

  String? userId;
  late ResetChatService _resetService;
  String? _currentSessionId;
  bool _isLoading = false;

  //  VoiceService
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _voiceService = VoiceService(controller: _controller);
    _resetService = ResetChatService(
      chatService: _chatService,
      lightPink1: lightPink1,
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Auto scroll logic
      }
    });
  }

  void _resetChat() {
    _resetService.resetChat(
      context: context,
      userId: userId,
      onSuccess: () => print('✅ Reset complete'),
      onScrollToBottom: _scrollToBottom,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _voiceService.stopListening();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 44, 153),
        iconTheme: IconThemeData(color: pureWhite),
        title: Text(
          "AI Chatbot",
          style: TextStyle(
            color: pureWhite,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _resetChat,

            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: Colors.red,
              size: 22,
            ),
            label: Text(
              "Reset Chat",
              style: TextStyle(color: pureWhite, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 22, 44, 153),
              lightPink,
              lightPink1,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: userId == null
                  ? Center(
                      child: Text(
                        "Please login first",
                        style: TextStyle(color: pureWhite, fontSize: 18),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: _chatService.getChatStream(userId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });

                          return Center(
                            child: Text(
                              "Start chatting with AI!",
                              style: TextStyle(
                                color: const Color.fromARGB(148, 54, 53, 53),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,

                          physics: BouncingScrollPhysics(),

                          padding: EdgeInsets.all(10),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            final isUser = data['isUser'] as bool;

                            return Align(
                              alignment: isUser
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: ClipPath(
                                clipper: Chatcustomcontainercliper(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: width * 0.7,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isUser
                                            ? [
                                                Color.fromARGB(
                                                  255,
                                                  87,
                                                  99,
                                                  206,
                                                ),
                                                Color.fromARGB(
                                                  255,
                                                  31,
                                                  192,
                                                  220,
                                                ),
                                              ]
                                            : [
                                                Color.fromARGB(
                                                  255,
                                                  113,
                                                  119,
                                                  161,
                                                ),
                                                Color.fromARGB(
                                                  255,
                                                  55,
                                                  63,
                                                  156,
                                                ),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: isUser ? 24.0 : 30.0,
                                      ),
                                      child: Text(
                                        data['text'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),

            //  INPUT + VOICE + SEND
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 50),
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 155, 154, 154),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 155, 154, 154),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: lightRed, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      style: TextStyle(color: Colors.black87),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),

                  // 🔥 VOICE BUTTON (Functional!)
                  IconButton(
                    icon: Icon(
                      _voiceService.isListening ? Icons.mic : Icons.mic_none,
                      color: _voiceService.isListening
                          ? Colors.lightBlue
                          : Colors.red,
                      size: 28,
                    ),
                    onPressed: () async {
                      final success = await _voiceService.toggleListening();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _voiceService.isListening
                                  ? '🎙️ Listening...'
                                  : '✅ Voice stopped',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(width: 4),

                  // 🔥 SEND BUTTON (Working!)
                  IconButton(
                    icon: Icon(Icons.send, color: lightRed, size: 28),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty &&
                          userId != null) {
                        _sendMessage();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a message first'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 SEND MESSAGE (Fixed - Shows immediately!)
  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() => _isLoading = true); // 🔥 Loading ON

    try {
      if (_currentSessionId == null) {
        _currentSessionId = await _chatservicehistory.createSession(
          message,
          userId!,
        );
      } else {
        // User message add
        await _chatservicehistory.addToSession(
          message,
          true,
          userId!,
          _currentSessionId!,
        );

        // AI reply (short delay for realism)
        await Future.delayed(Duration(milliseconds: 500));
        final aiReply = await _chatService.sendMessage(
          message,
          userId: userId!,
        );
        await _chatservicehistory.addToSession(
          aiReply,
          false,
          userId!,
          _currentSessionId!,
        );
      }

      _controller.clear();
      _scrollToBottom(); // 🔥 IMMEDIATE SCROLL
    } catch (e) {
      print('❌ Send error: $e');
    } finally {
      setState(() => _isLoading = false); // 🔥 Loading OFF
    }
  }
}
