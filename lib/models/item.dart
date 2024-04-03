import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/providers/user_data_provider.dart';
import 'package:app/models/user_data.dart';
import 'package:provider/provider.dart';

enum ItemType {
  background,
  jersey,
  number,
  border,
}

class Item {
  final ItemType type;
  final String name;
  final int price;

  Item({
    required this.type,
    required this.name,
    required this.price,
  });
}

void purchase(Item item, BuildContext ctx) async {
  final userDataProvider = Provider.of<UserDataProvider>(ctx, listen: false);
  final userData = userDataProvider.userData;

  if (userData == null) {
    print('User data not found.');
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

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.update(userDoc, {'balance': userData.balance - item.price});
    transaction.set(itemCollection.doc(item.name), {
      'name': item.name,
      'price': item.price,
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
        content: Text('Price: ${item.price}'),
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
