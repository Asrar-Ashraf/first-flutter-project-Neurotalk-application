import 'package:NeuroTalk/feature/HomeScreen_feature/widget/startbutton.dart';
import 'package:NeuroTalk/feature/chat_feature/data/chatService.dart';
import 'package:NeuroTalk/feature/chat_feature/pages/chatscreen.dart';
import 'package:NeuroTalk/feature/loginscreen_feature/presentation/loginscreen.dart';
import 'package:NeuroTalk/feature/profile_feature/domain/profile_image_provider.dart';
import 'package:NeuroTalk/feature/profile_feature/domain/stateprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chatboot_app/feature/HomeScreen_feature/widget/startbutton.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/data/chatService.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/pages/chatscreen.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/presentation/loginscreen.dart';
// import 'package:flutter_chatboot_app/profile_feature/domain/profile_image_provider.dart';
// import 'package:flutter_chatboot_app/profile_feature/domain/stateprovider.dart';
// import 'package:flutter_chatboot_app/profile_feature/pages/profilescreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key, String? userid});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotatecontroller;
  late Animation<double> _rotatation;
  late Animation<double> _showchatpic;
  late Animation<double> _buttomshow;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _rotatecontroller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
    _rotatation = Tween(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rotatecontroller, curve: Curves.linear));
    _rotatecontroller.repeat(reverse: true);
    _showchatpic = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.linear),
      ),
    );
    _buttomshow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.linear),
      ),
    );
    _controller.forward();
  }

  //handle logout
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  Future<void> logoutWithDataDelete() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // 1. Delete all chat data
        await _chatService.deleteAllUserData(user.uid);
        print('✅ User data deleted: ${user.uid}');

        // 2. Firebase logout
        await _auth.signOut();
        print('✅ Firebase logout success');
      }
    } catch (e) {
      print('❌ Logout error: $e');
      rethrow;
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout & Delete Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Chat history permanently delete'),
            SizedBox(height: 8),
            Text(
              'Sessions + Messages',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete & Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await logoutWithDataDelete();
        ref.read(profileProviders.notifier).clearProfile();
        ref.read(profileImageProvider.notifier).removeImage();
        // 🔥 BEST PRACTICE NAVIGATION
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Loginscreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Logout successful - Data deleted'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Logout failed: $e')));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotatecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 10, 0, 25),
              Color.fromARGB(255, 40, 0, 120),
              Color.fromARGB(255, 0, 0, 0),
            ],
            stops: [0.1, 0.2, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                height: height * 0.08,
                width: width * 0.93,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final imageFile = ref.watch(profileImageProvider);

                        return Container(
                          width: width * 0.15,
                          height: width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(160),
                            border: Border.all(
                              color: Colors.white,
                              width: width * 0.004,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: width * 0.16,
                            backgroundColor: Colors.teal,
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile)
                                : null,
                            child: imageFile == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: width * 0.1,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 230),
                      child: Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            onPressed: () async {
                              _handleLogout(context);
                            },

                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FadeTransition(
              opacity: _showchatpic,
              child: RotationTransition(
                turns: _rotatation,
                child: SizedBox(
                  height: height * 0.35,
                  width: width * 0.45,
                  child: Image(
                    image: AssetImage("assets/images/Chatbot1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: _buttomshow,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatscreen()),
                  );
                },
                child: Startbutton(buttonText: "Start\nChat"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
