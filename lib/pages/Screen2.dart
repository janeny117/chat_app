
import 'package:flutter/material.dart';


class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text(
          'Screen2 from Screen2.dart',
          style: TextStyle(
            fontSize: 20.0,
          ),

        ),
      ),
    );
  }
}
