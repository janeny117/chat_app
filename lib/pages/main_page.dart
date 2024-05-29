import 'dart:ui';
import 'package:chat_app_tutorial/pages/chat_page.dart';
import 'package:chat_app_tutorial/services/auth/auth_service.dart';
import 'package:chat_app_tutorial/pages/home_page.dart';
import 'package:chat_app_tutorial/pages/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'check_my_info.dart'; // MyInfo 페이지 import

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // instance of auth
  int _selectedIndex = 0;

  // sign user out
  void signOut() {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // MyInfo 페이지로 이동하는 메서드 추가
  void _navigateToMyInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyInfo()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: IndexedStack(
          index: _selectedIndex,
          children: [
            Row(
              children: [
                const SizedBox(width: 15,),
                Icon(Icons.cloud, color: Colors.lightBlue[200],size: 30,),
                const SizedBox(width: 5,),
                const Text("Home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 15,),
                Icon(Icons.cloud, color: Colors.lightBlue[200],size: 30,),
                const SizedBox(width: 5,),
                const Text("Chats", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 15,),
                Icon(Icons.cloud, color: Colors.lightBlue[200],size: 30,),
                const SizedBox(width: 5,),
                const Text("Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)),
              ],
            ),
          ],
        ),

        actions: [
          // MyInfo 페이지로 이동하는 새로운 아이콘 버튼 추가
          IconButton(
            icon: const Icon(Icons.info_outline, size: 30),
            onPressed: _navigateToMyInfo,
            color: Colors.black,
          ),
          IndexedStack(
            index: _selectedIndex,
            children: [
              // Page 1
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_box_outlined, color: Colors.black, size: 30,),
                ],
              ),
              // Page 2
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_outlined, color: Colors.black, size: 30, ),
                ],
              ),
              // Page 3
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: signOut,
                    icon: const Icon(Icons.logout),
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          )
        ],


      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          ChatPage(),
          SettingPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.lightBlueAccent[100],
        iconSize: 26,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_circle_outlined),
              label: '탭1',
              activeIcon: Icon(Icons.cloud_circle)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: '탭2',
              activeIcon: Icon(Icons.chat)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: '탭3',
              activeIcon: Icon(Icons.settings)
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
