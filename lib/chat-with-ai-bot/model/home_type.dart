// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Assistants/assistant_screen.dart';
import '../../Assistants/translator/screen/translator_feature.dart';
import '../chat_with_gemini/screens/chat_screen.dart';
import '../../Assistants/generate_image_by_ai/screen/image_feature.dart';

enum HomeType { aiChatBot,aiAssistants, aiImage }

extension MyHomeType on HomeType {
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiAssistants => 'AI ASSISTANTS',
        HomeType.aiImage => 'AI Image Creator',
        };

  String get lottie => switch (this) {
        HomeType.aiChatBot => 'ai_hand_waving.json',
         HomeType.aiAssistants => 'ai_ask_me.json',
        HomeType.aiImage => 'ai_play.json',
       
      };

  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
         HomeType.aiAssistants => true,
        HomeType.aiImage => true,
       
      };

  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiAssistants => EdgeInsets.zero,
        HomeType.aiImage => const EdgeInsets.all(20),
        
      };

  //for navigation
 VoidCallback onTap(BuildContext context) {
    switch (this) {
      case HomeType.aiChatBot:
        return () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
             case HomeType.aiAssistants:
        return () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssistantScreen()),
            );
      case HomeType.aiImage:
        return () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ImageFeature()),
            );
    }
  }
  } 
      
    
