import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileImageProvider = StateNotifierProvider<ProfileImageNotifier, File?>(
  (ref) => ProfileImageNotifier(),
);

class ProfileImageNotifier extends StateNotifier<File?> {
  ProfileImageNotifier() : super(null) {
    loadImage();
  }
  SharedPreferences? prefs;

  /// Load image from SharedPreferences
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      state = File(imagePath);
    }
  }

  /// Pick image & save path
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', image.path);
      state = File(image.path);
    }
  }

  /// Clear image
  Future<void> removeImage() async {
    prefs = await SharedPreferences.getInstance();
    await prefs!.remove('profile_image');
    state = null;
  }

  Future<void> clearProfile() async {
    await prefs?.clear();
  }
}
