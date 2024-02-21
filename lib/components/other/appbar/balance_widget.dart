import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key, required this.bgColor});

  final Color bgColor;

  void goToShop(BuildContext context) {
    context.go('/shop');
  }

  @override
  Widget build(BuildContext context) {
    final UserData? usrData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    return GestureDetector(
      onTap: () {
        goToShop(context);
      },
      child: Row(
        children: [
          SvgPicture.asset(
            'lib/assets/images/appbar/add_dollar.svg',
            height: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '${usrData!.balance} pts',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
