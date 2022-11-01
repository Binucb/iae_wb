import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String er;
  const ErrorScreen({Key? key, required this.er}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("$er - The requested URL Couldnt fetch the details"),
            ],
          ),
        ),
      ),
    );
  }
}
