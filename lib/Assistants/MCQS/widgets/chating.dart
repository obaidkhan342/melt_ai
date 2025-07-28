// ignore_for_file: duplicate_import

import 'package:flutter/material.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/model/message.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/providers/chat_provider.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/widgets/bot_message.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/widgets/user_message.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/widgets/user_message.dart';

class Chating extends StatelessWidget {
  final ScrollController scrollController;
  final ChatProvider chatProvider;

  const Chating({
    super.key,
    required this.scrollController,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inMcqsMessages.length,
      itemBuilder: (context, index) {
        // compare with timeSent bewfore showing the list
        final message = chatProvider.inMcqsMessages[index];
        return message.role.name == Role.user.name
            ? UserMessage(
                message: message,
                showText: false,
              )
            : BotMessage(msg: message.message.toString());
      },
    );
  }
}
