import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

showAlertDialog(BuildContext context, String title, String message) {
  // set up the button

  // set up the AlertDialog

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
        ],
      );
    },
  );
}
