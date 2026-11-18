import 'package:deepseek/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ChatBubble.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body:
          chatProvider.listMsg.isEmpty
              ? const Center(child: Text('No chat history '))
              : ListView.builder(
                itemCount: chatProvider.listMsg.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final msg = chatProvider.listMsg[index];
                  return ChatBubble(messageModel: msg);
                },
              ),
    );
  }
}
