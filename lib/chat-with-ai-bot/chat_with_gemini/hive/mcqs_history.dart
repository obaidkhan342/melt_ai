// ignore_for_file: unused_import

import 'package:hive_flutter/hive_flutter.dart';
part 'mcqs_history.g.dart';

@HiveType(typeId : 3)
class McqsHistory extends HiveObject{
  // chat id will store in database...
  @HiveField(0)
  final String chatId;
  
  //message or prompt send by user
  @HiveField(1)
  final String prompt;
  
  // response / asnwer generate by ai / bot
  @HiveField(2)
  final String response;
  
  //store list or urls following sends by urls
  @HiveField(3)
  final List<String> imagesUrls;

  //prompt and response send time...
  @HiveField(4)
  final DateTime timesStamp;

  McqsHistory(
    {
      required this.chatId,
      required this.prompt,
      required this.response,
      required this.imagesUrls,
      required this.timesStamp
    }
  );
}