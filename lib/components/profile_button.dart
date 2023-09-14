import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget profileButton(BuildContext context, double fem, double ffem, String text, void Function()? onPressed, Color color) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      // seestatsovf (12:175)
      margin: EdgeInsets.fromLTRB(127 * fem, 0 * fem, 128 * fem, 15 * fem),
      width: double.infinity,
      height: 35 * fem,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5 * fem),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3f000000),
            offset: Offset(0 * fem, 4 * fem),
            blurRadius: 2 * fem,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w500,
            height: 1.5 * ffem / fem,
            color: const Color(0xff000000),
          ),
        ),
      ),
    ),
  );
}
