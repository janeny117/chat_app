import 'package:chat_app_tutorial/components/error_bubble.dart';
import 'package:chat_app_tutorial/firebase_options.dart';
import 'package:chat_app_tutorial/pages/error_page.dart';
import 'package:chat_app_tutorial/services/auth/auth_gate.dart';
import 'package:chat_app_tutorial/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //임시
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
    );
  }
}
