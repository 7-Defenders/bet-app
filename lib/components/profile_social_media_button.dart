import 'package:app/components/not_implemented_yet_snackbar.dart';
import 'package:app/components/svg_image_with_action.dart';
import 'package:flutter/material.dart';

Widget profileSocialMediaImage(String path, double fem, double ffem, BuildContext context, Function()? onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: SizedBox(
    width:  50*fem,
    height:  50*fem,
    child:  
      svgImageWithAction(
        svgPath: path,
        width:  50*fem,
        height:  50*fem,
        action: () {
          notImplementedYetSnackbar(context);
        },
      ),
    ),
  );
}
