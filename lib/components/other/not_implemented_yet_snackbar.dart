import 'package:flutter/material.dart';

 ScaffoldFeatureController<SnackBar, SnackBarClosedReason> notImplementedYetSnackbar(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Not implemented yet!'),
      duration: Duration(seconds: 1),
    ),
  );
}
