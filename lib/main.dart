// ignore_for_file: unused_import, duplicate_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melt_ai/chat-with-ai-bot/screen/splash_screen.dart';
// import 'screens/auth_ui/sign-in-screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Assistants/Generate-Papers/provider/generate-paper-provider.dart';
import 'Assistants/Generate-Papers/screens/paper-screen.dart';
import 'Assistants/QuizWhiz/provider/quiz-provirder.dart';
import 'Assistants/QuizWhiz/screen/quiz_app.dart';
import 'chat-with-ai-bot/apis/app_write.dart';
import 'chat-with-ai-bot/chat_with_gemini/hive/pref.dart';
import 'chat-with-ai-bot/chat_with_gemini/providers/chat_provider.dart';
import 'chat-with-ai-bot/chat_with_gemini/screens/chat_screen.dart';
import 'chat-with-ai-bot/chat_with_gemini/themes/my_theme.dart';
import 'Assistants/generate_image_by_ai/aiImageProvider/generate_ai_imageProvider.dart';
import 'Assistants/generate_image_by_ai/screen/image_feature.dart';
import 'chat-with-ai-bot/helper/pref_provider.dart';
// import 'all_In_One/screen/splash_screen.dart';
import 'Assistants/translator/screen/translator_feature.dart';
import 'chat-with-ai-bot/screen/home_screen.dart';
import 'Assistants/translator/providers/translator_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();
  
  runApp(
    MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => TranslateProvider()),
    ChangeNotifierProvider(create: (context) => GenerateAiImageprovider()),
    ChangeNotifierProvider(create: (context) => PrefProvider()),
    ChangeNotifierProvider(create: (context) => QuizServices()),
    ChangeNotifierProvider(create: (context) => GeneratePaper())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() {
    final prefProvider = context.read<PrefProvider>();
    prefProvider.getSavedPref();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: context.watch<PrefProvider>().isDarkMode ? darkTheme : lightTheme,
      home: SplashScreen(),
    );
  }
}

