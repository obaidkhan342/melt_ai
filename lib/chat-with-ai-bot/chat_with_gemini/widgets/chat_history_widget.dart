// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, unnecessary_import, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:gemini/utility/utility.dart';
import 'package:provider/provider.dart';
// import '../../screen/home_screen.dart';
import '../hive/chat_history.dart';
import '../providers/chat_provider.dart';
import '../screens/chat_screen.dart';
import '../utility/utility.dart';

class ChatHistoryWidget extends StatelessWidget {
  final ChatHistory chat;

  ChatHistoryWidget({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.chat),
        ),
        title: Text(
          chat.prompt,
          maxLines: 1,
        ),
        subtitle: Text(
          chat.response,
          maxLines: 2,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          
          final chatProvider = context.read<ChatProvider>();

          await chatProvider.prepareChatRoom(
              isNewChat: false, chatID: chat.chatId);
          chatProvider.setCurrentIndex(newIndex: 1);
          // chatProvider.pageController.jumpToPage(1);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
            (route) => false, // This removes all previous routes
          );
        },
        onLongPress: () {
          showMyAnimatedDialog(
              context: context,
              title: 'Delete Chat',
              content: 'Are you sure you want to delete this chat?',
              actionText: 'Delete',
              onActionPressed: (value) async {
                if (value) {
                  await context
                      .read<ChatProvider>()
                      .deleteChatMessages(chatId: chat.chatId);

                  await chat.delete();
                }
              });
        },
      ),
    );
  }
}
