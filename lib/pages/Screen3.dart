import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Screen3 from Screen3.dart',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
