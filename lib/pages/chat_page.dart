import 'package:chat_app_tutorial/components/chat_bubble.dart';
import 'package:chat_app_tutorial/components/my_text_field.dart';
import 'package:chat_app_tutorial/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/weather_service.dart';
import '../model/weather_model.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage(
      {super.key,
        required this.receiverUserEmail,
        required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final scrollController = ScrollController();
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;

  @override
  void initState() {
    super.initState();
      _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      Weather weather = await _weatherService.fetchWeather('Seoul'); //추후 위치정보 받아오기 추가
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }
  String _getBackgroundImage() {
    if (_weather == null) return 'assets/default.jpg'; // 흰배경 해도 좋을듯
    switch (_weather!.icon) {
      case '01d':
      case '01n':
        return 'assets/clear_sky.jpg';
      case '02d':
      case '02n':
        return 'assets/few_clouds.jpg';
      case '03d':
      case '03n':
        return 'assets/scattered_clouds.jpg';
      case '04d':
      case '04n':
        return 'assets/broken_clouds.jpg';
      case '09d':
      case '09n':
        return 'assets/shower_rain.jpg';
      case '10d':
      case '10n':
        return 'assets/rain.jpg';
      case '11d':
      case '11n':
        return 'assets/thunderstorm.jpg';
      case '13d':
      case '13n':
        return 'assets/snow.jpg';
      case '50d':
      case '50n':
        return 'assets/mist.jpg';
      default:
        return 'assets/default.jpg';
    }
  }



  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      //clear the text controller after sending the message
      _messageController.clear();
      scrollController.animateTo(

          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 가상 키보드 활성화 시 메세지 내용 가리지 않게
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.receiverUserEmail, style: TextStyle(color: Colors.white,)),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()), // 날씨에 따른 배경 이미지 설정
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()), // 메시지 목록
            _buildMessageInput(), // 메시지 입력 필드
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0,10,0,18),
                shrinkWrap: true,
                controller: scrollController,
                reverse: true,
                itemCount: 1,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: snapshot.data!.docs
                        .map((document) => _buildMessageItem(document))
                        .toList(),
                  );
                }
            ),
          );
        }

      );

  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the currenst user , otherwise to the left

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return data['senderId'] != _firebaseAuth.currentUser!.uid
        ? Container(

            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 180.0, 8),
              child: Column(
                crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(data['senderEmail']),
                  const SizedBox(height: 5),
                  ChatBubble(message: data['message']),
                ],
              ),
            ),
          )
        : Container(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(180.0, 5, 5, 5),
              child: Column(
                crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  //const SizedBox(height: 2),
                  ChatBubble(message: data['message']),
                ],
              ),
            ),
          );

  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // textfield
          Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: 'Enter Message',
                obscureText: false,
              )),
          // send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}