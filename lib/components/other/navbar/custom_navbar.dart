import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

Widget buildNavBarItem(
  int index,
  Function(int) onItemTapped,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () => onItemTapped(index),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.075,
      color: Colors.green,
    ),
  );
}

Stack customNavbar(
  BuildContext context,
  int selectedIndex,
  Function(int) onItemTapped,
) {
  return Stack(
    children: [
      // on bottom, custom navbar svg image based on the selected index (1-5)
      SvgPicture.asset(
        'lib/assets/images/navbar/navbar_$selectedIndex.svg',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      // on top, invisible buttons to make the navbar items clickable
      Positioned(
        bottom: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavBarItem(0, onItemTapped, context),
            buildNavBarItem(1, onItemTapped, context),
            buildNavBarItem(2, onItemTapped, context),
            buildNavBarItem(3, onItemTapped, context),
            buildNavBarItem(4, onItemTapped, context),
          ],
        ),
      ),
    ],
  );
  // return Container(
  //   color: Colors.green,
  //   width: MediaQuery.of(context).size.width,
  //   height: MediaQuery.of(context).size.height * 0.08,
  // );
}
