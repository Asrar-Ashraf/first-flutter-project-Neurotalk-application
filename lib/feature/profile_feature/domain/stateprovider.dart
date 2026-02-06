import 'package:NeuroTalk/feature/profile_feature/data/profilemodel.dart';
import 'package:NeuroTalk/feature/profile_feature/domain/profileProvider.dart';
// import 'package:flutter_chatboot_app/profile_feature/data/profilemodel.dart';
// import 'package:flutter_chatboot_app/profile_feature/domain/profileProvider.dart';
import 'package:flutter_riverpod/legacy.dart';

final profileProviders = StateNotifierProvider<Profileprovider, Profilemodel>(
  (ref) => Profileprovider(),
);
