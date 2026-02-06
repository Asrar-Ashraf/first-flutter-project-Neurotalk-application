import 'package:flutter/material.dart';

class Startbutton extends StatelessWidget {
  const Startbutton({super.key, this.onpressed, required this.buttonText});
  final VoidCallback? onpressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    return Material(
      color: Colors.transparent,
      shape: ShapeBorder.lerp(CircleBorder(), CircleBorder(), 1),
      elevation: width * 0.03,
      shadowColor: Colors.white,
      child: Container(
        height: height * 0.3,
        width: width * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black45, Colors.black26],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
        ),
      ),
    );
  }
}
