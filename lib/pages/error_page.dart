import 'package:flutter/material.dart';

import '../components/error_bubble.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return ErrorBubble(text: "페이지를 찾을 수 없습니다.");
  }
}

