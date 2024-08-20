import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget nunitoText(
  String text,
  double fontSize,
  FontWeight fontWeight,
  Color color,
  {
    TextAlign textAlign=TextAlign.start,
    int? maxLines,
  }
) {
  return Text(
    text,
    style: GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
    maxLines: maxLines,
    textAlign: textAlign,
  );
}
