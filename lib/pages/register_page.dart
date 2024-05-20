import 'package:chat_app_tutorial/components/my_button.dart';
import 'package:chat_app_tutorial/components/my_text_field.dart';
import 'package:chat_app_tutorial/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password do not match")));
      return;
    }
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailPassword(
          emailController.text, passwordController.text);
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
                    color: Colors.grey[800],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //create account message
                  Text(
                    "Let's create an account for you!",
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
                      hintText: 'Email',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  //password textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  //confirm password textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),
                  //sign up button
                  MyButton(onTap: signUp, text: "Sign Un"),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a Member?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Login now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
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
