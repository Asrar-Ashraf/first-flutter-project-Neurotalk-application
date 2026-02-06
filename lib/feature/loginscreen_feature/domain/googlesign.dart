import 'package:NeuroTalk/feature/HomeScreen_feature/presentation/homescreen.dart';
import 'package:NeuroTalk/feature/loginscreen_feature/presentation/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_chatboot_app/feature/HomeScreen_feature/presentation/homescreen.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/presentation/loginscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> googleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    throw Exception(e.toString());
  }
}

void checkUserlogin(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
    );
  }
}
