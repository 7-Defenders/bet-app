import 'package:flutter/material.dart';

class GlowingCircle extends StatelessWidget {
  final Color color;

  const GlowingCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4), // Adjust opacity for the glow effect
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
