import 'package:chat_app_tutorial/components/chat_bubble.dart';
import 'package:chat_app_tutorial/components/my_text_field.dart';
import 'package:chat_app_tutorial/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      body: Column(
        children: [
          // messages
          Expanded(child: _buildMessageList()),

          // user Input
          _buildMessageInput(),

          const SizedBox(height: 25,),
        ],
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
              ))
        ],
      ),
    );
  }
}
