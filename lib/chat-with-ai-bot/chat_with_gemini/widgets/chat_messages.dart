import 'package:flutter/material.dart';
import '../model/message.dart';
import '../providers/chat_provider.dart';
// import 'assistance_message_widget.dart';
import 'bot_message.dart';

import 'user_message.dart';

class ChatMessages extends StatelessWidget {
  
  const ChatMessages({
    super.key,
    required this.scrollController,
    required this.chatProvider,
  });

  final ScrollController scrollController;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inChatMessages.length,
      itemBuilder: (context, index) {
        // compare with timeSent bewfore showing the list
        final message = chatProvider.inChatMessages[index];
        return message.role.name == Role.user.name
            ? UserMessage(message: message)
            : BotMessage(msg: message.message.toString());
      },
    );
  }
}
