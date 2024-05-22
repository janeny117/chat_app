import 'package:chat_app_tutorial/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/login_or_register.dart';

class RegisterFinished extends StatefulWidget {
  const RegisterFinished({super.key});

  @override
  State<RegisterFinished> createState() => _RegisterFinishedState();
}

class _RegisterFinishedState extends State<RegisterFinished> {
  void goToLoginPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("회원가입이 완료되었습니다.",
                  style: TextStyle(
                  fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                  ,),
                const SizedBox(
                  height: 20,
                ),
                MyButton(onTap: goToLoginPage, text: "로그인")
              ],
            ),
          ),
        )

    );
  }
}
