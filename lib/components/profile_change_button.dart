import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget profileChangeButton(double fem, double ffem, BuildContext context, String text, void Function()? action) {
  return GestureDetector(
    onTap: action,
    child: Container(
      margin: EdgeInsets.fromLTRB(24 * fem, 0 * fem, 25 * fem, 9 * fem),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2.08 * fem),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 13.846154213 * ffem,
                  fontWeight: FontWeight.w500,
                  height: 1.5 * ffem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.65,
            child: SizedBox(
              width: 12.92 * fem,
              height: 17.3 * fem,
              child: SvgPicture.asset(
                'lib/assets/images/arrow_right.svg',
                width: 12.92 * fem,
                height: 17.3 * fem,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
