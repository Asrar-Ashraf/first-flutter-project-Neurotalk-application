import 'package:NeuroTalk/feature/loginscreen_feature/presentation/loginscreen.dart';
import 'package:NeuroTalk/feature/splashscreen_feature/presentation/splash_screen_widget.dart';
import 'package:NeuroTalk/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/presentation/loginscreen.dart';
// import 'package:flutter_chatboot_app/feature/splashscreen_feature/presentation/splash_screen_widget.dart';
// import 'package:flutter_chatboot_app/main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashAnimationWidget());
  }
}
