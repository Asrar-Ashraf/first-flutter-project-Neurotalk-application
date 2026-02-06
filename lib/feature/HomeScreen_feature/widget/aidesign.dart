import 'package:flutter/widgets.dart';

class Aidesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(width * 0.1, 0);
    path.lineTo(width * 0.9, 0);
    path.quadraticBezierTo(width, height * 0.05, width * 0.9, height * 0.1);
    path.lineTo(width * 0.1, height * 0.1);
    path.quadraticBezierTo(0, height * 0.05, width * 0.1, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
