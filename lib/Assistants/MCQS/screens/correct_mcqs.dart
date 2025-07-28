// ignore_for_file: unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../chat-with-ai-bot/chat_with_gemini/providers/chat_provider.dart';
// import '../../all_In_One/chat_with_gemini/screens/chat_screen.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/utility/utility.dart';
import '../../assistant_screen.dart';
import '../widgets/chating.dart';
import '../widgets/upload_mcqs.dart';

class CorrectOptionList extends StatefulWidget {
  const CorrectOptionList({super.key});

  @override
  State<CorrectOptionList> createState() => _CorrectOptionListState();
}

class _CorrectOptionListState extends State<CorrectOptionList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }

        // auto scroll to bottom on new message
        chatProvider.addListener(() {
          if (chatProvider.inChatMessages.isNotEmpty) {
            _scrollToBottom();
          }
        });

        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue.shade50,
            centerTitle: true,
            title: const Text('AnswerLens',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            actions: [
              if (chatProvider.inMcqsMessages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        // show my animated dialog to start new chat
                        showMyAnimatedDialog(
                          context: context,
                          title: 'Start New Chat',
                          content: 'Are you sure you want to start a new chat?',
                          actionText: 'Yes',
                          onActionPressed: (value) async {
                            if (value) {
                              // prepare chat room
                              await chatProvider.prepareChatRoom(
                                isNewChat: true,
                                chatID: '',
                                isMcqs: true,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: chatProvider.inMcqsMessages.isEmpty
                          ? const Center(
                              child: Text('Empty Yet'),
                            )
                          : Chating(
                              scrollController: _scrollController,
                              chatProvider: chatProvider)),

                  // input field
                  UploadMcqs(
                    chatProvider: chatProvider,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
