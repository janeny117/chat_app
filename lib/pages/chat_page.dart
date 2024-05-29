import 'package:chat_app_tutorial/pages/chat_room.dart';
import 'package:chat_app_tutorial/pages/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return _buildUserList();
  }

 // build a list of user except for the current Logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except for current user
    try {
      if (_auth.currentUser!.email != data['name']) {
        return ListTile(
          title: Row(
            children: [
              Container(
                  child: Icon(Icons.account_box_rounded, size: 60, color: Colors.black12,)
              ),
              const SizedBox(width: 5,),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'], style: TextStyle(fontSize: 15),),
                      Text('상태 메세지', style: TextStyle(fontSize: 10),)
                    ],
                  ),
              ),
            ],
          ),
          onTap: () {
            //pass the clicked user's UID to the chat page
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatRoom(
                          receiverUserEmail: data['name'],
                          receiverUserID: data['uid'],
                        )));
          },
        );
      } else {
        //return empty container
        return Container();
      }
    }
    catch(e){
      print(e);
      return Container();
    }
  }

}