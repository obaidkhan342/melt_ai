import 'package:hive/hive.dart';
import '../constant.dart';
import 'chat_history.dart';
import 'mcqs_history.dart';
import 'pref.dart';
import 'settings.dart';
import 'user_model.dart';

class Boxes {
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);

  static Box<Settings> getSettings() =>
      Hive.box<Settings>(Constants.settingBox);

  static Box<Pref> getPref() => Hive.box<Pref>(Constants.prefBox);

  static Box<McqsHistory> getMcqsHistory() =>
      Hive.box<McqsHistory>(Constants.mcqsHistoryBox);
}
