import 'package:NeuroTalk/feature/profile_feature/data/profilemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chatboot_app/profile_feature/data/profilemodel.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profileprovider extends StateNotifier<Profilemodel> {
  Profileprovider() : super(Profilemodel(userName: "Name", userEmail: "Email"));

  static const String userNameKey = "userName";
  SharedPreferences? _preferences;

  Future<void> loadDataFirstTime() async {
    _preferences = await SharedPreferences.getInstance();

    final user = FirebaseAuth.instance.currentUser;
    final userName = _preferences!.getString(userNameKey) ?? "Name";
    final gmail = user?.email ?? "Email";

    state = state.copyWith(userName: userName, userEmail: gmail);
  }

  Future<void> updateName(String name) async {
    await _preferences!.setString(userNameKey, name);
    state = state.copyWith(userName: name);
  }

  Future<void> clearProfile() async {
    await _preferences?.clear();
    state = Profilemodel(userName: "Name", userEmail: "Email");
  }
}
