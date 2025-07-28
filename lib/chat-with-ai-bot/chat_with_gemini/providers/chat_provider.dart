// ignore_for_file: unused_import, await_only_futures

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../apis/apis.dart';
import '../../helper/global.dart';
import '../api/api_services.dart';
import '../constant.dart';
import '../hive/boxes.dart';
import '../hive/chat_history.dart';
import '../hive/mcqs_history.dart';
import '../hive/pref.dart';
import '../hive/settings.dart';
import '../hive/user_model.dart';
import '../model/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';

class ChatProvider extends ChangeNotifier {
  // list of messages
  final List<Message> _inChatMessages = [];

  final List<Message> _inMcqsMessages = [];

  // page Controller
  final PageController _pageController = PageController();

  //images file list
  List<XFile>? _imagesFileList = [];

  //current index of screen
  int _currentIndex = 0;

  //current chatId
  String _currentChatId = '';

  // initialize generative model
  static GenerativeModel? _model;

  // itialize text model
  GenerativeModel? _textModel;

  // initialize vision model
  GenerativeModel? _visionModel;

  // // // current mode
  String _modelType = 'gemini-pro';

  // loading bool
  bool _isLoading = false;

  // getters
  List<Message> get inChatMessages => _inChatMessages;

  List<Message> get inMcqsMessages => _inMcqsMessages;

  PageController get pageController => _pageController;

  List<XFile>? get imageFileList => _imagesFileList;

  int get currentIndex => _currentIndex;

  String get currentChatId => _currentChatId;

  GenerativeModel? get model => _model;

  GenerativeModel? get textModel => _textModel;

  GenerativeModel? get visionModel => _visionModel;

  String get modelType => _modelType;

  bool get isLoading => _isLoading;

  //setters

  // set inChatMessages
  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessageFromDB(chatId: chatId);

    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) {
        log("Message Aleardy exists");
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  // load the messages from db
  Future<List<Message>> loadMessageFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');

    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');

    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);

      final messageData = Message.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

  // set file list
  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  // set the current Model
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  // function to set the model based on bool - isTextOnly
  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _model =
          _textModel ??
          GenerativeModel(
            model: setCurrentModel(newModel: 'gemini-1.5-pro'),
            // model: setCurrentModel(newModel: 'gemini-2.5-pro-exp-03-25'),
            // apiKey: getApiKey(),
            apiKey: getApiKey(),
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    } else {
      _model =
          _visionModel ??
          GenerativeModel(
            model: setCurrentModel(newModel: 'gemini-1.5-flash'),
            // model: setCurrentModel(newModel: 'gemini-2.5-flash'),
            // apiKey: getApiKey(),
            apiKey: getApiKey(),
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    }
    notifyListeners();
  }

  // set current page index
  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  // set current chat id
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  // set loading
  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  String getApiKey() {
    return apiKey;
  }

  // delete chat
  Future<void> deleteChatMessages({required String chatId}) async {
    if (!Hive.isBoxOpen('${Constants.chatMessagesBox}$chatId')) {
      // open box
      await Hive.openBox('${Constants.chatMessagesBox}$chatId');

      // clear box
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();

      // close box
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    } else {
      // delete all messages in the box
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();

      // close the box
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    }

    if (currentChatId.isNotEmpty) {
      if (currentChatId == chatId) {
        setCurrentChatId(newChatId: '');
        _inChatMessages.clear();
        notifyListeners();
      }
    }
  }

  // prepare chat room
  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
    bool isMcqs = false,
  }) async {
    if (!isNewChat) {
      final chatHistory = await loadMessageFromDB(chatId: chatID);
      isMcqs ? _inMcqsMessages.clear() : _inChatMessages.clear();

      for (var message in chatHistory) {
        _inChatMessages.add(message);
      }
      setCurrentChatId(newChatId: chatID);
    } else {
      _inChatMessages.clear();
      _inMcqsMessages.clear();
      setCurrentChatId(newChatId: chatID);
    }
  }

  // send message to gemini and get the streamed reposnse
  // Future<void> sentMessage({
  //   required String message,
  //   required bool isTextOnly,
  //   bool saveItNot = true,
  //   bool isMcqs = false,
  // }) async {
  //   await setModel(isTextOnly: isTextOnly);
  //   setLoading(value: true);
  //   try {
  //     // get the chatId
  //     String chatId = getChatId();

  //     // get the chat history
  //     List<Content> history = await getHistory(chatId: chatId);

  //     // get the imagesUrls
  //     List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

  //     final messagesBox =
  //         await Hive.openBox('${Constants.chatMessagesBox}$chatId');

  //     final mcqsBox = await Hive.openBox('${Constants.mcqsMessagesBox}$chatId');

  //     // get the last user message id
  //     final userMessageId = messagesBox.keys.length;

  //     final userMcqsId = mcqsBox.keys.length;

  //     // assistant messageId
  //     final assistantMessageId = isMcqs ? userMcqsId + 1 : userMessageId + 1;

  //     // final assistantMcqsId = ;

  //     //user message
  //     final userMessage = isMcqs
  //         ? Message(
  //             messageId: userMcqsId.toString(),
  //             chatId: chatId,
  //             role: Role.user,
  //             message: StringBuffer(message),
  //             imageUrls: imagesUrls,
  //             timeSent: DateTime.now())
  //         : Message(
  //             messageId: userMessageId.toString(),
  //             chatId: chatId,
  //             role: Role.user,
  //             message: StringBuffer(message),
  //             imageUrls: imagesUrls,
  //             timeSent: DateTime.now());

  //     isMcqs
  //         ? _inMcqsMessages.add(userMessage)
  //         : _inChatMessages.add(userMessage);
  //     notifyListeners();

  //     if (currentChatId.isEmpty) {
  //       setCurrentChatId(newChatId: chatId);
  //     }

  //     // send the message to the model and wait for the response
  //     await sendMessageAndWaitForResponse(
  //       message: message,
  //       chatId: chatId,
  //       isTextOnly: isTextOnly,
  //       history: history,
  //       userMessage: userMessage,
  //       modelMessageId: assistantMessageId.toString(),
  //       messagesBox: messagesBox,
  //       isSaveIt: saveItNot,
  //       isMcqs: isMcqs,
  //     );
  //   } catch (e, stackTrace) {
  //     log('Error in sentMessage: $e');
  //     log('Stack trace: $stackTrace');
  //   } finally {
  //     setLoading(value: false);
  //   }
  // }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
    bool saveItNot = true,
    bool isMcqs = false,
  }) async {
    setLoading(value: true);
    try {
      String chatId = getChatId();
      List<Content> history = await getHistory(chatId: chatId);
      final messagesBox = await Hive.openBox(
        '${Constants.chatMessagesBox}$chatId',
      );
      final userMessageId = messagesBox.keys.length;
      final assistantMessageId = userMessageId + 1;

      // Get base64 images if not text only
      List<String> imagesUrls = await getImagesUrls(isTextOnly: isTextOnly);
      List<String> base64Images = [];
      for (var path in imagesUrls) {
        final bytes = await File(path).readAsBytes();
        base64Images.add(base64Encode(bytes));
      }

      final userMessage = Message(
        messageId: userMessageId.toString(),
        chatId: chatId,
        role: Role.user,
        message: StringBuffer(message),
        imageUrls: imagesUrls,
        timeSent: DateTime.now(),
      );

      if (isMcqs) {
        _inMcqsMessages.add(userMessage);
      } else {
        _inChatMessages.add(userMessage);
      }

      if (currentChatId.isEmpty) {
        setCurrentChatId(newChatId: chatId);
      }

      notifyListeners();

      await sendMessageAndWaitForResponse(
        message: message,
        chatId: chatId,
        isTextOnly: isTextOnly,
        history: history,
        userMessage: userMessage,
        modelMessageId: assistantMessageId.toString(),
        messagesBox: messagesBox,
        isSaveIt: saveItNot,
        isMcqs: isMcqs,
        base64Images: base64Images,
      );
    } catch (e) {
      log('Error in sentMessage: $e');
    } finally {
      setLoading(value: false);
    }
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
    required String modelMessageId,
    required Box messagesBox,
    bool isSaveIt = true,
    bool isMcqs = false,
    Box? mcqsBox,
    List<String> base64Images = const [],
  }) async {
    try {
      // Generate response using free API with image support
      final responseText = await APIS.generateTextFromFreeAPI(
        prompt: message,
        base64Images: base64Images,
      );

      final assistantMessage = userMessage.copyWith(
        messageId: modelMessageId,
        role: Role.assistant,
        message: StringBuffer(responseText),
        timeSent: DateTime.now(),
      );

      if (isMcqs) {
        _inMcqsMessages.add(assistantMessage);
      } else {
        _inChatMessages.add(assistantMessage);
      }

      notifyListeners();

      if (isSaveIt) {
        await saveMessageToDB(
          chatID: chatId,
          userMessage: userMessage,
          assistantMessage: assistantMessage,
          messagesBox: messagesBox,
          isMcqs: isMcqs,
        );
      }
    } catch (e, stackTrace) {
      log('Error in sendMessageAndWaitForResponse: $e');
      log('Stack trace: $stackTrace');
    }
  }

  // Future<void> sendMessageAndWaitForResponse({
  //   required String message,
  //   required String chatId,
  //   required bool isTextOnly,
  //   required List<Content> history,
  //   required Message userMessage,
  //   required String modelMessageId,
  //   required Box messagesBox,
  //   bool isSaveIt = true,
  //   bool isMcqs = false,
  //   Box? mcqsBox,
  // }) async {
  //   try {
  //     final chatSession = _model!.startChat(
  //       history: history.isEmpty || !isTextOnly ? null : history,
  //     );

  //     // get content
  //     final content =  await getContent(message: message, isTextOnly: isTextOnly);

  //     // assistant message
  //     final assistantMessage = userMessage.copyWith(
  //       messageId: modelMessageId,
  //       role: Role.assistant,
  //       message: StringBuffer(),
  //       timeSent: DateTime.now(),
  //     );

  //     // add this message to the list on inChatMessages
  //     isMcqs
  //         ? _inMcqsMessages.add(assistantMessage)
  //         : _inChatMessages.add(assistantMessage);

  //     notifyListeners();

  //     // wait for stream response
  //     chatSession.sendMessageStream(content).asyncMap((event) {
  //       return event;
  //     }).listen((event) {
  //       isMcqs
  //           ? _inMcqsMessages
  //               .firstWhere((element) =>
  //                   element.messageId == assistantMessage.messageId &&
  //                   element.role.name == Role.assistant.name)
  //               .message
  //               .write(event.text)
  //           : _inChatMessages
  //               .firstWhere((element) =>
  //                   element.messageId == assistantMessage.messageId &&
  //                   element.role.name == Role.assistant.name)
  //               .message
  //               .write(event.text);
  //       log('event: ${event.text}');
  //       notifyListeners();
  //     }, onDone: () async {
  //       log('stream done');
  //       // save message to hive db
  //       isSaveIt
  //           ? await saveMessageToDB(
  //               chatID: chatId,
  //               userMessage: userMessage,
  //               assistantMessage: assistantMessage,
  //               messagesBox: messagesBox,
  //             )
  //           : null;
  //     }).onError((error, stackTrace) {
  //       log('Error in message stream: $error');
  //     });
  //   } catch (e, stackTrace) {
  //     log('Error in sendMessageAndWaitForResponse: $e');
  //     log('Stack trace: $stackTrace');
  //   }
  // }

  //save message to hive db
  Future<void> saveMessageToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
    bool isMcqs = false,
  }) async {
    // save user message
    await messagesBox.add(userMessage.toMap());

    //save assistant message
    await messagesBox.add(assistantMessage.toMap());

    // save chat history with the same chatId
    // if its already there update it
    // if not create a new one
    if (isMcqs == true) {
      final mcqsHistoryBox = Boxes.getMcqsHistory();
      final chatHistory = McqsHistory(
        chatId: chatID,
        prompt: userMessage.message.toString(),
        response: assistantMessage.message.toString(),
        imagesUrls: userMessage.imageUrls,
        timesStamp: DateTime.now(),
      );
      await mcqsHistoryBox.put(chatID, chatHistory);
    } else {
      final chatHistoryBox = Boxes.getChatHistory();
      final chatHistory = ChatHistory(
        chatId: chatID,
        prompt: userMessage.message.toString(),
        response: assistantMessage.message.toString(),
        imagesUrls: userMessage.imageUrls,
        timesStamp: DateTime.now(),
      );

      await chatHistoryBox.put(chatID, chatHistory);
    }

    await messagesBox.close();
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = _imagesFileList
          ?.map((imageFile) => imageFile.readAsBytes())
          .toList(growable: false);

      final imageBytes = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  // get y=the imagesUrls
  List<String> getImagesUrls({required bool isTextOnly}) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imageFileList != null) {
      for (var image in imageFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);

      for (var message in inChatMessages) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }
    return history;
  }

  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    }
    return currentChatId;
  }

  // init Hive
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PrefAdapter());
      await Hive.openBox<Pref>(Constants.prefBox);
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(McqsHistoryAdapter());
      await Hive.openBox<McqsHistory>(Constants.mcqsHistoryBox);
    }
  }
}
