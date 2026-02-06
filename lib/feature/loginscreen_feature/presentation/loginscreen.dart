import 'package:NeuroTalk/feature/loginscreen_feature/domain/googlesign.dart';
import 'package:NeuroTalk/feature/loginscreen_feature/domain/storegmailinshare.dart';
import 'package:NeuroTalk/main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/domain/googlesign.dart';
// import 'package:flutter_chatboot_app/feature/loginscreen_feature/domain/storegmailinshare.dart';
// import 'package:flutter_chatboot_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen>
    with TickerProviderStateMixin {
  late AnimationController chatbotpic;
  late Animation<double> animation;
  late AnimationController _loginbutton;
  late Animation<double> _loginanimation;

  @override
  void initState() {
    super.initState();
    _loginbutton = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..forward();

    chatbotpic = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
    _loginanimation = Tween<double>(begin: 0.0, end: 1.0).animate(_loginbutton);
    animation = Tween(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: chatbotpic, curve: Curves.linear));
  }

  @override
  void dispose() {
    chatbotpic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
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
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
              top: height * 0.0,
              left: width * 0.1,
              child: Container(
                height: height * 0.83,
                width: width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.black38, Colors.white30],
                    stops: [0.3, 1.0],
                    // begin: Alignment.topLeft,
                    // end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * 0.25,
              top: height * 0.2,
              child: FadeTransition(
                opacity: animation,
                child: Image(
                  image: AssetImage("assets/images/Chatbot1.png"),
                  fit: BoxFit.cover,
                  height: height * 0.4,
                  width: width * 0.53,
                ),
              ),
            ),
            Positioned(
              top: height * 0.75,
              child: Container(
                height: height * 0.25,
                width: width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(235, 15, 39, 80),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.1),
            Positioned(
              top: height * 0.65,
              left: width * 0.2,
              child: SizedBox(
                height: height * 0.07,
                width: width * 0.6,
                child: ScaleTransition(
                  scale: _loginanimation,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MyHomePage(title: "Flutter"),
                      //   ),
                      // );
                      final result = await googleSignIn();
                      if (result != null) {
                        final storegmail = result.user!.email;
                        await Storegmailinshare.saveGmail(storegmail!);
                        await GoogleSignIn().signOut();
                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Successful")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(title: "Flutter"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Login Failed")));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login with",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.transparent,
                          child: Image(
                            image: AssetImage("assets/images/gogle.png"),
                            height: height * 0.3,
                            width: width * 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
