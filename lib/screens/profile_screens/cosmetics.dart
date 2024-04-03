import 'package:app/components/other/appbar/balance_widget.dart';
import 'package:app/components/other/appbar/custom_appbar.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/item.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget buildSection(
  UserData userData,
  String title,
  double usableWidth,
  double cardHeight,
  double cardWidth,
  String type,
) {
  final uid = userData.uid;
  final selectedURL = type == 'background'
      ? userData.bgURL
      : type == 'tshirt'
          ? userData.tshirtURL
          : userData.frameURL;
  final ItemType itemType = type == 'background'
      ? ItemType.background
      : type == 'tshirt'
          ? ItemType.tshirt
          : ItemType.frame;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 8,
      ),
      nunitoText(title, 18, FontWeight.bold, Colors.black),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        height: cardHeight,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection(type)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                  child: GestureDetector(
                    onTap: () {
                      selectItem(
                        context,
                        Item(
                          id: data['id'] as String,
                          name: data['name'] as String,
                          price: data['price'] as int,
                          link: data['link'] as String,
                          type: itemType,
                        ),
                      );
                      // here the item is selected (there's new user data in the provider), and i want to update the UI
                    },
                    child: Card(
                      elevation: 5,
                      surfaceTintColor: data['link'] == selectedURL
                          ? Colors.green
                          : Colors.white,
                      child: SizedBox(
                        width: cardWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            nunitoText(
                              data['name'] as String,
                              16,
                              FontWeight.normal,
                              Colors.black,
                            ),
                            SvgPicture.network(
                              data['link'] as String,
                              width: cardWidth * 0.5,
                              height: cardHeight * .5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    ],
  );
}

class CosmeticsScreen extends StatefulWidget {
  const CosmeticsScreen({super.key});

  @override
  State<CosmeticsScreen> createState() => _CosmeticsScreenState();
}

class _CosmeticsScreenState extends State<CosmeticsScreen> {
  IconButton buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        GoRouter.of(context).go('/profile');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usableWidth = MediaQuery.of(context).size.width * 0.9;
    final cardHeight = MediaQuery.of(context).size.height * 0.3;
    final cardWidth = MediaQuery.of(context).size.width * 0.3;

    final userDataProvider = Provider.of<UserDataProvider>(context);
    final UserData userData = userDataProvider.userData!;

    return Scaffold(
      appBar: CustomAppbar(
        56,
        buildBackButton(),
        'Cosmetics',
        const [
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: BalanceWidget(
              bgColor: Color.fromARGB(255, 21, 70, 175),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(
                userData,
                'Backgrounds',
                usableWidth,
                cardHeight,
                cardWidth,
                'background',
              ),
              buildSection(
                userData,
                'T-Shirts',
                usableWidth,
                cardHeight,
                cardWidth,
                'tshirt',
              ),
              buildSection(
                userData,
                'Frames',
                usableWidth,
                cardHeight,
                cardWidth,
                'frame',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
