import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {

  final String imagePath;
  final double imageHeight;

  const ImageTile({
    super.key,
    required this.imagePath,
    required this.imageHeight,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        imagePath,
        height: imageHeight,
      ),
    );
  }
}