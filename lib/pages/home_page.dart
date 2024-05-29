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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_circle_rounded, color: Colors.lightBlue, size: 120,),
            const SizedBox(height: 5,),
            const Text(
              "오픈 준비 중...",
              style: TextStyle(
                  fontSize: 17,
              ),
            )
          ],
        )
      ),
    );
  }
}
