import 'package:app/models/user_data.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum ItemType {
  background,
  tshirt,
  frame,
}

class Item {
  final String id;
  final ItemType type;
  final String name;
  final int price;
  final String link;

  Item({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.link,
  });
}

Future<void> purchase(Item item, BuildContext ctx) async {
  final userDataProvider = Provider.of<UserDataProvider>(ctx, listen: false);
  final userData = userDataProvider.userData;

  if (userData == null) {
    debugPrint('User data not found.');
    return;
  }

  if (userData.balance < item.price) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Insufficient balance.'),
      ),
    );
    return;
  }

  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(userData.uid);
  final itemType = item.type.toString().split('.').last;
  final itemCollection = userDoc.collection(itemType);

  // TODO: make the card non-clickable if the item is already purchased
  // & add indicator on card that item is owned
  final itemDoc = await itemCollection.doc(item.id).get();
  if (itemDoc.exists) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('Item already purchased.'),
      ),
    );
    return;
  }

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userDoc, {'balance': userData.balance - item.price});
    transaction.set(itemCollection.doc(item.id), {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'link': item.link,
      'type': itemType,
    });
  });

  userData.balance -= item.price;
  userDataProvider.userData = userData;
}

void showPurchasePopup(
  BuildContext ctx,
  Item item,
) {
  showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Price: ${item.price}'),
            SvgPicture.network(
              item.link,
              width: 220,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Purchase'),
            onPressed: () {
              purchase(item, ctx);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> selectItem(
  BuildContext ctx,
  Item item,
) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final userDataProvider = Provider.of<UserDataProvider>(ctx, listen: false);
    final userData = userDataProvider.userData;
    if (userData == null) {
      debugPrint('User data not found.');
      return;
    }
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userData.uid);
    final itemType = item.type.toString().split('.').last;
    final fieldToUpdate = itemType == 'background'
        ? 'bgURL'
        : itemType == 'tshirt'
            ? 'tshirtURL'
            : 'frameURL';

    transaction.update(userDoc, {fieldToUpdate: item.link});
    userDataProvider.userData = UserData(
      uid: userData.uid,
      balance: userData.balance,
      email: userData.email,
      emailVerified: userData.emailVerified,
      bgURL: itemType == 'background' ? item.link : userData.bgURL,
      tshirtURL: itemType == 'tshirt' ? item.link : userData.tshirtURL,
      frameURL: itemType == 'frame' ? item.link : userData.frameURL,
      photoURL: userData.photoURL,
      displayName: userData.displayName,
      betsWon: userData.betsWon,
      leaguesJoined: userData.leaguesJoined,
    );
  });
}
