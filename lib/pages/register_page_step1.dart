import 'package:chat_app_tutorial/pages/register_page_step2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';


class RegisterStep1 extends StatefulWidget {
  final void Function()? onTap;

  const RegisterStep1({super.key, required this.onTap});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {

//text controller
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  void goNext(){
    if(isEmailValid(emailController.text) && isNameValid(nameController.text)){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterStep2(onTap: widget.onTap, emailController: emailController, nameController: nameController,)),
      );
    }
    else{
      // 에러 디텍션
    }
  }

  bool isEmailValid(String email){
  // 정규 표현식을 사용한 이메일 유효성 검사
    final RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegExp.hasMatch(email);
  }


  bool isNameValid(String name){
    // 이름의 유효성 검사: 빈 문자열이 아니고 길이가 적당한지 확인
    if (name.isEmpty) {
      return false;
    }

    // 이름의 길이가 2 이상 50 이하인 경우
    if (name.length < 2 || name.length > 50) {
      return false;
    }

    return true;
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
                  const Text(
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
                      controller: emailController,
                      hintText: '이메일',
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  // name textfield
                  MyTextField(
                      controller: nameController,
                      hintText: '이름',
                      obscureText: false),
                  const SizedBox(
                    height: 25,
                  ),
                  //password textfield
                  //sign up button
                  MyButton(onTap: goNext, text: "계속"),
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