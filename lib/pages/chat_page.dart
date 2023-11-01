import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ChatPage'),
          TextButton(
            onPressed: () {
              AuthMockService().logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    ));
  }
}
