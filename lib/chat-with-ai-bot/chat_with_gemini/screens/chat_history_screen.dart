// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../hive/boxes.dart';
import '../hive/chat_history.dart';
import '../widgets/chat_history_widget.dart';
import '../widgets/empty_history_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
             automaticallyImplyLeading: false,
            leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: const Text('Chat History')),
        body: ValueListenableBuilder<Box<ChatHistory>>(
          builder: (context, box, _) {
            final chatHistory =
                box.values.toList().cast<ChatHistory>().reversed.toList();
            return chatHistory.isEmpty
                ? const EmptyHistoryWidget()
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = chatHistory[index];
                          return ChatHistoryWidget(chat: chat);
                        }),
                  );
          },
          valueListenable: Boxes.getChatHistory().listenable(),
        ));
  }
}
