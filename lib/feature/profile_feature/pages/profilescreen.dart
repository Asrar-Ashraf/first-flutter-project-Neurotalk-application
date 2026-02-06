import 'package:NeuroTalk/feature/chat_feature/data/chatService.dart';
import 'package:NeuroTalk/feature/loginscreen_feature/presentation/loginscreen.dart';
import 'package:NeuroTalk/feature/profile_feature/domain/profile_image_provider.dart';
import 'package:NeuroTalk/feature/profile_feature/domain/stateprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chatboot_app/feature/chat_feature/data/chatService.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/presentation/loginscreen.dart';
// import 'package:flutter_chatboot_app/profile_feature/domain/profile_image_provider.dart';
// import 'package:flutter_chatboot_app/profile_feature/domain/stateprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profilescreen extends ConsumerStatefulWidget {
  const Profilescreen({super.key});

  @override
  ConsumerState<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends ConsumerState<Profilescreen> {
  String checkMode = "Normal 😐";
  final TextEditingController _storeName = TextEditingController();
  @override
  void initState() {
    ref.read(profileProviders.notifier).loadDataFirstTime();
    // print(ref.watch(profileProviders).userEmail);
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  // 🔥 COMPLETE Logout with Data Delete
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

  // 🔥 COMPLETE Logout with Data Delete dialoge

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
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Logout failed: $e')));
      }
    }
  }

  // Normal logout without data delete (optional)
  Future<void> simpleLogout() async {
    await _auth.signOut();
  }

  //delete profile data
  Future<void> deleteProfileData() async {}
  Future<void> dialoge() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Update Name",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "This name will be visible on your profile",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _storeName,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                ref.read(profileProviders.notifier).updateName(_storeName.text);
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkgmail() async {
    // String storeGmail = user!.email.toString();
    //  print(storeGmail);
  }

  @override
  void dispose() {
    _storeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 194, 197, 255),
              const Color.fromARGB(255, 130, 206, 238),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 35, 62, 150),
                      const Color.fromARGB(255, 68, 62, 150),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(height * 0.05),
                    bottomRight: Radius.circular(height * 0.05),
                  ),
                ),
                child: Stack(
                  children: [
                    //add profile title
                    Positioned(
                      top: height * 0.05,
                      left: width * 0.39,
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // profile pic
                    Positioned(
                      top: height * 0.12,
                      left: width * 0.35,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final imageFile = ref.watch(profileImageProvider);

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                color: const Color.fromARGB(255, 1, 0, 0),
                                width: width * 0.007,
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
                                      size: width * 0.2,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    //add icon for select image
                    Positioned(
                      top: height * 0.235,
                      left: width * 0.54,
                      child: IconButton(
                        onPressed: () {
                          ref.read(profileImageProvider.notifier).pickImage();
                        },
                        icon: Icon(
                          Icons.camera_alt_sharp,
                          size: width * 0.07,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //add username
                    Positioned(
                      top: height * 0.28,
                      left: width * 0.22,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final profiledata = ref.watch(profileProviders);
                          return Center(
                            child: SizedBox(
                              width: width * 0.6,
                              child: Center(
                                child: Text(
                                  profiledata.userName!,
                                  style: TextStyle(
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //add name filed
              SizedBox(height: height * 0.04),
              Card(
                elevation: 10,
                child: Container(
                  height: height * 0.07,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final profiledata = ref.watch(profileProviders);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: width * 0.6,
                                child: Text(
                                  maxLines: 1,
                                  profiledata.userName!,
                                  style: TextStyle(fontSize: width * 0.06),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dialoge();
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
              //add email
              SizedBox(height: height * 0.02),
              Card(
                elevation: 10,
                child: Container(
                  height: height * 0.07,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return Text(
                          ref.watch(profileProviders).userEmail!,
                          style: TextStyle(fontSize: width * 0.06),
                        );
                      },
                    ),
                  ),
                ),
              ),
              //add status
              SizedBox(height: height * 0.02),
              Card(
                elevation: 10,
                child: Container(
                  height: height * 0.07,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    spacing: width * 0.2,
                    children: [
                      Text("Status", style: TextStyle(fontSize: width * 0.06)),
                      DropdownButton<String>(
                        value: checkMode,
                        items: ["Happy 😄", "Sad 😢", "Normal 😐"].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(fontSize: width * 0.06),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            checkMode = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Card(
                elevation: 10,
                child: Container(
                  height: height * 0.07,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () async {
                      _handleLogout(context);
                    },
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: width * 0.06,
                        color: Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.logout, size: 25, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
