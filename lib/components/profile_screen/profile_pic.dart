import 'package:flutter/material.dart';

// profile picture with border
Widget pictureWithBorder(
  String? photoURL,
  double vh,
  BuildContext context,
) {
  return Container(
    width: 19 * vh,
    height: 19 * vh,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      // ignore: require_trailing_commas
      border: Border.all(
        width: 10,
        color: Theme.of(context).colorScheme.background,
      ),
      image: DecorationImage(
        fit: BoxFit.fill,
        image: photoURL != "" || photoURL != null
            ? Image.network(photoURL!).image
            : Image.asset('lib/assets/images/default_pfp.jpg').image,
      ),
    ),
  );
}

// editing profile picture button
Widget smallButton(
  void Function()? onTap,
  double vw,
  double vh,
  IconData? icon,
  BuildContext context,
) {
  return Center(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 6 * vh,
        height: 5.5 * vh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
  );
}
