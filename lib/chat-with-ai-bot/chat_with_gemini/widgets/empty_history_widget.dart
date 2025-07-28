// ignore_for_file: unused_import, unused_local_variable, unnecessary_import, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../screens/chat_screen.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final chatProvider = context.read<ChatProvider>();
          await chatProvider.prepareChatRoom(isNewChat: true, chatID: '');
          chatProvider.setCurrentIndex(newIndex: 1);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              )),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No Chat found , start a new chat! '),
          ),
        ),
      ),
    );
  }
}
