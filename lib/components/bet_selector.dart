import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BetSelector extends StatefulWidget {
  const BetSelector({Key? key});

  @override
  State<BetSelector> createState() => _BetSelectorState();
}

class _BetSelectorState extends State<BetSelector> {
  @override
  Widget build(BuildContext context) {
    const double baseWidth = 380;
    final fem = MediaQuery.of(context).size.width / baseWidth;
    final ffem = fem * 0.97;

    return Container(
      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
      width: double.infinity,
      height: 92 * fem,
      decoration: BoxDecoration(
        color: const Color(0x4cfa9b02),
        borderRadius: BorderRadius.circular(12 * fem),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3f000000),
            offset: Offset(0 * fem, 4 * fem),
            blurRadius: 2 * fem,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 4 * fem,
            top: 4 * fem,
            child: Align(
              child: SizedBox(
                width: 360 * fem,
                height: 84 * fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12 * fem),
                    color: const Color(0x4cfa9b02),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        offset: Offset(0 * fem, 4 * fem),
                        blurRadius: 2 * fem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 46 * fem,
            top: 9 * fem,
            child: Align(
              child: SizedBox(
                width: 111 * fem,
                height: 17 * fem,
                child: Text(
                  'Polska - Niemcy',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 4 * fem,
            top: 46 * fem,
            child: Align(
              child: SizedBox(
                width: 360 * fem,
                height: 42 * fem,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0x4cfa9b02),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12 * fem),
                      bottomLeft: Radius.circular(12 * fem),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 4 * fem,
            top: 46 * fem,
            child: Align(
              child: SizedBox(
                width: 70 * fem,
                height: 42 * fem,
                child: SvgPicture.asset('lib/assets/images/shape1.svg'),
              ),
            ),
          ),
          Positioned(
            left: 56.5 * fem,
            top: 46 * fem,
            child: Align(
              child: SizedBox(
                width: 85.5 * fem,
                height: 42 * fem,
                child: SvgPicture.asset('lib/assets/images/shape2.svg'),
              ),
            ),
          ),
          Positioned(
            left: 294 * fem,
            top: 46 * fem,
            child: Align(
              child: SizedBox(
                width: 70 * fem,
                height: 42 * fem,
                child: SvgPicture.asset('lib/assets/images/shape5.svg'),
              ),
            ),
          ),
          Positioned(
            left: 226 * fem,
            top: 46 * fem,
            child: Align(
              child: SizedBox(
                width: 85.5 * fem,
                height: 42 * fem,
                child: SvgPicture.asset('lib/assets/images/shape4.svg'),
              ),
            ),
          ),
          Positioned(
            left: 118 * fem,
            top: 44 * fem,
            child: Align(
              child: SizedBox(
                width: 132 * fem,
                height: 46 * fem,
                child: SvgPicture.asset('lib/assets/images/shape3.svg'),
              ),
            ),
          ),
          Positioned(
            left: 167.5 * fem,
            top: 66 * fem,
            child: Align(
              child: SizedBox(
                width: 33 * fem,
                height: 20 * fem,
                child: Text(
                  '1.33',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffb303),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 182 * fem,
            top: 48 * fem,
            child: Align(
              child: SizedBox(
                width: 9 * fem,
                height: 17 * fem,
                child: Text(
                  '2',
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 83 * fem,
            top: 68 * fem,
            child: Align(
              child: SizedBox(
                width: 26 * fem,
                height: 15 * fem,
                child: Text(
                  '5.22',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 92 * fem,
            top: 50 * fem,
            child: Align(
              child: SizedBox(
                width: 8 * fem,
                height: 15 * fem,
                child: Text(
                  '0',
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 255 * fem,
            top: 68 * fem,
            child: Align(
              child: SizedBox(
                width: 28 * fem,
                height: 15 * fem,
                child: Text(
                  '3.40',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 261 * fem,
            top: 50 * fem,
            child: Align(
              child: SizedBox(
                width: 14 * fem,
                height: 15 * fem,
                child: Text(
                  '10',
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 28 * fem,
            top: 68 * fem,
            child: Align(
              child: SizedBox(
                width: 14 * fem,
                height: 15 * fem,
                child: Text(
                  '10',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 31 * fem,
            top: 50 * fem,
            child: Align(
              child: SizedBox(
                width: 6 * fem,
                height: 15 * fem,
                child: Text(
                  '1',
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 319.5 * fem,
            top: 68 * fem,
            child: Align(
              child: SizedBox(
                width: 25 * fem,
                height: 15 * fem,
                child: Text(
                  '1.06\n',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 323 * fem,
            top: 50 * fem,
            child: Align(
              child: SizedBox(
                width: 16 * fem,
                height: 15 * fem,
                child: Text(
                  '02',
                  style: GoogleFonts.inter(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 42.5 * fem,
            top: 29 * fem,
            child: Align(
              child: SizedBox(
                width: 120 * fem,
                height: 13 * fem,
                child: Text(
                  'DZISIAJ 18:00 | Na żywo  ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10 * ffem,
                    fontWeight: FontWeight.w300,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 11 * fem,
            top: 12 * fem,
            child: Align(
              child: SizedBox(
                width: 27 * fem,
                height: 27 * fem,
                child: SvgPicture.asset('lib/assets/images/futbol-regular.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
