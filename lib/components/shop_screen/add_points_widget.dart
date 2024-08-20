import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPointsWidget extends StatefulWidget {
  const AddPointsWidget({super.key});

  @override
  State<AddPointsWidget> createState() => _AddPointsWidgetState();
}

class _AddPointsWidgetState extends State<AddPointsWidget> {

  Future<void> addPoints(String uid, int pointsToAdd) async {
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);
    final int currentPoints = await userDocRef.get().then((doc) => doc['balance'] as int);
    final int newPoints = currentPoints + pointsToAdd;
    await userDocRef.get().then((doc) => doc.reference.update({'balance': newPoints}));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _buildAddPointsDialog(),
        );
      },
      child: const Text('Add 100 Points'),
    );
  }

  Widget _buildAddPointsDialog() {
    return AlertDialog(
      title: const Text('Add 100 Points'),
      content: const Text('Are you sure you want to add 100 points to your account?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final String uid = FirebaseAuth.instance.currentUser!.uid;
            await addPoints(uid, 100);
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
