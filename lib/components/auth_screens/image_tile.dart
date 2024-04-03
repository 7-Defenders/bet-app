import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final String imagePath;
  final double imageHeight;
  final Function()? onTap;

  const ImageTile({
    super.key,
    required this.imagePath,
    required this.imageHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          imagePath,
          height: imageHeight,
        ),
      ),
    );
  }
}
