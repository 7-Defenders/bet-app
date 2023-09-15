import 'package:app/components/image_with_action.dart';
import 'package:app/components/not_implemented_yet_snackbar.dart';
import 'package:app/components/svg_image_with_action.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget topBar(BuildContext context, String pathToSvg, dynamic Function() svgClickAction) {
  const double baseWidth = 380;
  final fem = MediaQuery.of(context).size.width / baseWidth;
  final ffem = fem * 0.97;

  return SafeArea(
    child: Container(
      // eventsMiX (1:4)
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
      child: Column(
        children: [
          Container(
            // headerTWf (13:303)
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0 * fem),
            padding: EdgeInsets.fromLTRB(23 * fem, 6 * fem, 8 * fem, 4 * fem),
            width: double.infinity,
            height: 62 * fem,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x3f000000),
                  offset: Offset(0 * fem, 2 * fem),
                  blurRadius: 5 * fem,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  // coinshvo (I13:303;14:11)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 6 * fem, 188 * fem, 7 * fem),
                  height: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        // adddollarrHu (I13:303;13:249)
                        margin: EdgeInsets.fromLTRB(
                          0 * fem,
                          0 * fem,
                          10 * fem,
                          0 * fem,
                        ),
                        width: 35 * fem,
                        height: 35 * fem,
                        child: imageWithAction(
                          path: 'lib/assets/images/add_dollar.png',
                          width: 35 * fem,
                          height: 35 * fem,
                          action: () {
                            //TODO: implement taking user to shop (or smth else?) screen
                            notImplementedYetSnackbar(context);
                          },
                        ),
                      ),
                      Container(
                        // ZTD (I13:303;14:12)
                        margin: EdgeInsets.fromLTRB(
                          0 * fem,
                          0 * fem,
                          0 * fem,
                          1 * fem,
                        ),
                        child: Text(
                          '2139',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            fontSize: 25 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.7 * ffem / fem,
                            letterSpacing: 0.4368931651 * fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // settingsT2o (I13:303;13:254)
                  width: 48 * fem,
                  height: 48 * fem,
                  child: svgImageWithAction(
                    svgPath: pathToSvg,
                    width: 48 * fem,
                    height: 48 * fem,
                    action: () {
                      svgClickAction();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
