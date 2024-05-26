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


  // !!!! 이메일과 이름 유효한지 검사 추가.
  void goNext() {
    // 이메일과 이름 필드가 비어있지 않은지 확인
    if (emailController.text.isNotEmpty && nameController.text.isNotEmpty) {
      // 둘 다 비어있지 않다면 다음 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterStep2(onTap: widget.onTap, emailController: emailController, nameController: nameController,)),
      );
    } else {
      // 하나라도 비어있다면 에러 메시지를 보여주는 다이얼로그를 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white, // AlertDialog의 배경색을 여기서 설정
          title: Text('오류'),
          content: Text('모든 필드를 채워주세요.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: Colors.white)), // 버튼 텍스트 색상을 밝게 설정
              onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue), // 버튼 배경색을 파란색으로 설정
              ),
            ),
          ],
        ),
      );

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