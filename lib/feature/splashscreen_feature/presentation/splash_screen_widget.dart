import 'package:flutter/material.dart';

class SplashAnimationWidget extends StatefulWidget {
  const SplashAnimationWidget({super.key});

  @override
  State<SplashAnimationWidget> createState() => _SplashAnimationWidgetState();
}

class _SplashAnimationWidgetState extends State<SplashAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController pictureController;
  late Animation<double> fadeAnimation;
  late Animation<double> rotationAnimation;
  late Animation<double> optacity;
  @override
  void initState() {
    super.initState();
    pictureController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward();

    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: pictureController, curve: Curves.easeInOutCirc),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: pictureController,
        curve: Interval(0.0, 0.3, curve: Curves.linear),
      ),
    );
    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: pictureController,
        curve: Interval(0.3, 1.0, curve: Curves.linear),
      ),
    );
    optacity = Tween<double>(begin: 0.0, end: 1.0).animate(pictureController);
  }

  @override
  void dispose() {
    pictureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hight = size.height;
    final width = size.width;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 39, 13, 109),
              Colors.black87,
              Color.fromARGB(255, 30, 20, 177),
              const Color.fromARGB(169, 19, 21, 145),
              Color.fromARGB(255, 39, 22, 196),
              Color.fromARGB(255, 0, 0, 0),
            ],
            stops: [0.1, 0.2, 0.3, 0.5, 0.8, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
              top: hight * 0.14,
              left: width * 0.2,
              child: FadeTransition(
                opacity: rotationAnimation,
                child: Container(
                  height: hight * 0.7,
                  width: width * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.black54, Colors.white38],
                      stops: [0.9, 1.0],
                      // begin: Alignment.topLeft,
                      // end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: hight * 0.36,
              left: width * 0.31,
              child: FadeTransition(
                opacity: optacity,
                child: Image(
                  image: AssetImage('assets/images/Chatbot1.png'),
                  fit: BoxFit.cover,
                  width: width * 0.34,
                  height: hight * 0.24,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Positioned(
              top: size.height * 0.62,
              left: width * 0.22,
              child: Text(
                "NeuroTalk",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Positioned(
              top: size.height * 0.685,
              left: width * 0.24,
              child: Text(
                "Intelligent Conversations",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
