// Google Logo - SVG representation
// Gunakan library: flutter_svg untuk menampilkan SVG
// Atau gunakan CustomPaint untuk menggambar langsung

import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    // Implementasi Google Logo - Anda bisa replace dengan google_sign_in_flutter icon
    // atau download logo dari Google Brand Guidelines
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/icons/google_logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
