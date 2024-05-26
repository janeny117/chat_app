import 'package:chat_app_tutorial/components/my_button.dart';
import 'package:chat_app_tutorial/components/my_text_field.dart';
import 'package:chat_app_tutorial/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  // sign in user
  void signIn() async {
    //get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text, nameController.text) ;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //logo
                  Icon(
                    Icons.cloud,
                    size: 80,
                    color:  Colors.lightBlue[200],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //welcome message
                  Text(
                    "Welcome back. you\'ve been missed",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //email textfield
                  MyTextField(
                      controller: emailController,
                      hintText: '이메일',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  //password textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: '비밀번호',
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),
                  //sign button호
                  MyButton(onTap: signIn, text: "로그인"),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a Member?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                  // not a member? register now
                ],
              ),
            ),
          ),
        ));
  }
}
