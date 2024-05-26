import 'package:chat_app_tutorial/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorBubble extends StatelessWidget {

  //텍스트 필드
  final String text;

  //해당 에러버블을 호출시 필요한 파라미터는 text임
  const ErrorBubble({super.key, required this.text});

  //확인 버튼에 기능 부여하기
  /*void onTap(){
    Navigator.pop(context);
  }*/

  //iconButton 닫기에 기능을 부여하기
  void onClose(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            height:500,
            width: 500,
            padding: const EdgeInsets.only(
              left: 50.0, top: 10.0, right: 50.0, bottom: 20.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1,),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                    alignment: Alignment.topRight,
                 child: IconButton(
                   onPressed: () {Navigator.pop(context);},
                   icon: const Icon(Icons.close),
                 )
                ),
                Icon(
                  Icons.cloud_off_outlined,
                  color: Colors.grey[500],
                  size: 80,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  child: MyButton(onTap: (){Navigator.pop(context);}, text: "확인"),
                )
              ],
            )
          )
        ),
      );
  }
}
