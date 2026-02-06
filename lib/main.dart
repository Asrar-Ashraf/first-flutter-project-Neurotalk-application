import 'package:NeuroTalk/feature/HomeScreen_feature/presentation/homescreen.dart';
import 'package:NeuroTalk/feature/HomeScreen_feature/widget/customBottomNav.dart';
import 'package:NeuroTalk/feature/history_feature/pages/Historyscreen.dart';
import 'package:NeuroTalk/feature/loginscreen_feature/domain/storegmailinshare.dart';
import 'package:NeuroTalk/feature/splashscreen_feature/presentation/splashscreen.dart';
import 'package:NeuroTalk/firebase_options.dart';
import 'package:NeuroTalk/feature/profile_feature/pages/profilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Storegmailinshare.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: Splashscreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String? userid = FirebaseAuth.instance.currentUser?.uid;

  int _currentIndex = 1;
  List<Widget> get pages => [
    const Profilescreen(),
    const Homescreen(),
    HistoryScreen(userId: userid!),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
