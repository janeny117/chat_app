import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

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
