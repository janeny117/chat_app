import 'package:chat_app_tutorial/pages/login_page.dart';
import 'package:chat_app_tutorial/pages/register_page_step2.dart';
import 'package:chat_app_tutorial/services/auth/login_or_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';


class RegisterStep2 extends StatefulWidget {
  final void Function()? onTap;
  final emailController;
  final nameController;

  const RegisterStep2({super.key, required this.onTap, required this.emailController, required this.nameController});

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
//text controller
  var emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var nameController = TextEditingController();


  // sign up user
  void signUp() async {
    print(emailController.text);
    print(nameController.text);

    emailController = widget.emailController;
    nameController = widget.nameController;

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

  void goToLoginPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister())
    );
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
                    "회원가입",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //email textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: '비밀번호',
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  // name textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: '비밀번호 확인',
                      obscureText: true),
                  const SizedBox(
                    height: 25,
                  ),
                  //password textfield
                  //sign up button
                  MyButton(onTap: signUp, text: "회원가입"),
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
                          onTap: goToLoginPage,
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