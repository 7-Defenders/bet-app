import 'package:app/components/not_implemented_yet_snackbar.dart';
import 'package:app/components/profile_button.dart';
import 'package:app/components/profile_change_button.dart';
import 'package:app/components/profile_social_media_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    const double baseWidth = 380;
    final fem = MediaQuery.of(context).size.width / baseWidth;
    final ffem = fem * 0.97;

    return Container(
      // profilezMd (3:11)
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
      child: Column(
        children: [
          Container(
            // profileheaderfyZ (12:182)
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 15 * fem),
            width: double.infinity,
            height: 210 * fem,
            child: Stack(
              children: [
                Positioned(
                  // rectangle459Nw (3:65)
                  left: 0 * fem,
                  top: 0 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 500 * fem,
                      height: 140 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe95800),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x3f000000),
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
                  // group71Scw (12:136)
                  left: 130 * fem,
                  top: 80 * fem,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        5 * fem, 5 * fem, 5 * fem, 5 * fem,),
                    width: 120 * fem,
                    height: 120 * fem,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(90 * fem),
                    ),
                    child: Center(
                      // dsc025941wJo (3:139)
                      child: SizedBox(
                        width: 110 * fem,
                        height: 110 * fem,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90 * fem),
                          child: Image(
                            image: const AssetImage(
                                'lib/assets/images/cat.jpg',),
                            width: 110 * fem,
                            height: 110 * fem,
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 40 * fem,
                  child: Center(
                    child: SizedBox(
                      height: 27 * fem,
                      child: Text(
                        user!.email!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tiltNeon(
                          fontSize: 20 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 0.7 * ffem / fem,
                          letterSpacing: 0.5 * fem,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          profileChangeButton(fem, ffem, context, 'Change username', () {
            notImplementedYetSnackbar(context);
          }), //TODO: implement taking user to change username screen
          profileChangeButton(fem, ffem, context, 'Change profile picture',
              () {
            notImplementedYetSnackbar(context);
          }), //TODO: implement taking user to change pfp screen
          profileChangeButton(fem, ffem, context, 'Change password', () {
            notImplementedYetSnackbar(context);
          }), //TODO: implement taking user to change password screen

          SizedBox(height: 30 * fem,),

          profileButton(context, fem, ffem, 'Statistics', () {
            notImplementedYetSnackbar(context);
          }, const Color(0xffffb303),), //TODO: implement taking user to statistics screen
          profileButton(context, fem, ffem, 'Achievements',
          () {
            notImplementedYetSnackbar(context);
          }, const Color(0xffffb303),), //TODO: implement taking user to achievements screen

          SizedBox(height: 30 * fem,),

          Container(
            // connectwithsocialsiw9 (12:149)
            margin:
                EdgeInsets.fromLTRB(62 * fem, 0 * fem, 56 * fem, 30 * fem),
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 0 * fem,
                ),
                profileSocialMediaImage(
                    'lib/assets/images/icons8-facebook.svg',
                    fem,
                    ffem,
                    context, () {
                  notImplementedYetSnackbar(context);
                }),
                SizedBox(
                  width: 46 * fem,
                ),
                profileSocialMediaImage(
                    'lib/assets/images/icons8-google.svg', fem, ffem, context,
                    () {
                  notImplementedYetSnackbar(context);
                }),
                SizedBox(
                  width: 46 * fem,
                ),
                profileSocialMediaImage(
                    'lib/assets/images/icons8-twitter.svg',
                    fem,
                    ffem,
                    context, () {
                  notImplementedYetSnackbar(context);
                }),
              ],
            ),
          ),
          SizedBox(height: 40 * fem,),
          profileButton(context, fem, ffem, 'Logout', () {
            FirebaseAuth.instance.signOut();
          }, const Color(0xffe95800),),
        ],
      ),
    );
  }
}
