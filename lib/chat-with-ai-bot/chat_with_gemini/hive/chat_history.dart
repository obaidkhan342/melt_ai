import 'package:hive_flutter/hive_flutter.dart';

part 'chat_history.g.dart';

// model for chatHistory which using store chat history and response given by ai / bot...

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  // chat id will store in database...
  @HiveField(0)
  final String chatId;
  
  //message or prompt send by user
  @HiveField(1)
  final String prompt;
  
  // response / answer generate by ai / bot
  @HiveField(2)
  final String response;
  
  //store list or urls following sends by urls
  @HiveField(3)
  final List<String> imagesUrls;

  //prompt and response send time...
  @HiveField(4)
  final DateTime timesStamp;

  ChatHistory(
    {
      required this.chatId,
      required this.prompt,
      required this.response,
      required this.imagesUrls,
      required this.timesStamp
    }
  );
}
