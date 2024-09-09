import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Stack buildProfileArea(
  UserData userData,
  BuildContext context, {
  bool backArrow = false,
  bool isCurrentUser = true,
  Function(BuildContext) onBackArrowPressed = pop,
}) {
  return Stack(
    children: [
      buildProfileAreaBackground(userData),
      buildProfileAreaForeground(
        userData,
        context,
        backArrow: backArrow,
        isCurrentUser: isCurrentUser,
        onBackArrowPressed: onBackArrowPressed,
      ),
    ],
  );
}

Container buildProfileAreaBackground(UserData userData) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: SvgPicture.network(
        userData.bgURL!,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void pop(BuildContext context) {
  Navigator.of(context).pop();
}

Stack buildProfileAreaForeground(
  UserData userData,
  BuildContext context, {
  bool backArrow = false,
  bool isCurrentUser = true,
  Function(BuildContext) onBackArrowPressed = pop,
}) {
  // align the profile area widgets accordingly to their parent (proifleArea's) height
  return Stack(
    children: [
      if (backArrow)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              onBackArrowPressed(context);
            },
          ),
        ),
      if (isCurrentUser)
        Positioned(
          top: MediaQuery.of(context).padding.top + 3,
          right: 16,
          child: Consumer<UserDataProvider>(
            builder: (context, userDataProvider, child) {
              return const BalanceWidget(
                bgColor: Color.fromARGB(255, 255, 163, 21),
                //get balance from userdataprovider
                balance: 0,
              );
            },
          ),
        ),
      LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.2),
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Align(
                        alignment: const Alignment(0, -0.5),
                        child: SvgPicture.network(
                          userData.tshirtURL!,
                          height: constraints.maxHeight * 0.6,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, 0.5),
                    child: Image.network(
                      userData.photoURL!,
                      height: constraints.maxHeight * 0.3,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: constraints.maxHeight * 0.05),
              // buildUserFactsWidget(constraints, userData),
              // SizedBox(height: constraints.maxHeight * 0.05),
            ],
          );
        },
      ),
    ],
  );
}
