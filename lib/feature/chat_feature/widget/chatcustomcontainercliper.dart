import 'dart:ui';

import 'package:flutter/material.dart';

class Chatcustomcontainercliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final height = size.height;
    final width = size.width;
    Path path = Path();
    path.moveTo(width * 0.1, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(width * 0.1, height);
    path.lineTo(width * 0.1, height * 0.4);
    path.lineTo(0, height * 0.45);
    path.lineTo(width * 0.1, height * 0.3);
    path.lineTo(width * 0.1, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
