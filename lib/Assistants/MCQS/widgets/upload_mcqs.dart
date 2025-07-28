// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_field, unused_local_variable, prefer_const_constructors, library_private_types_in_public_api

import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/providers/chat_provider.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/utility/utility.dart';
import '../../../chat-with-ai-bot/chat_with_gemini/widgets/preview_images_widget.dart';

class UploadMcqs extends StatefulWidget {
  final ChatProvider chatProvider;

  UploadMcqs({required this.chatProvider});

  @override
  _UploadMcqsState createState() => _UploadMcqsState();
}

class _UploadMcqsState extends State<UploadMcqs> {
  // final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    // _textController.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> _sendChatMessage(
      {
      required String message,
      required bool isTextOnly,
      required bool saveDb
      }
      ) async {
    try {
      await widget.chatProvider.sentMessage(
          message: message,
          isTextOnly: isTextOnly,
          saveItNot: saveDb,
          isMcqs: true
        );
    } catch (e) {
      log('Error: $e');
    } finally {
      // _textController.clear();
      widget.chatProvider.setImagesFileList(listValue: []);
      _textFieldFocus.unfocus();
    }
  }

  void _pickImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      widget.chatProvider.setImagesFileList(listValue: pickedImages);
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.chatProvider.imageFileList != null &&
        widget.chatProvider.imageFileList!.isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
              // border: Border.all(
              //   color: Theme.of(context).textTheme.titleLarge?.color ??
              //       Colors.transparent,
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasImages) PreviewImagesWidget(),
                ElevatedButton(
                  onPressed: () {
                    if (hasImages) {
                      showMyAnimatedDialog(
                        context: context,
                        title: 'Delete Images',
                        content: 'Are you sure you want to delete the images?',
                        actionText: 'Delete',
                        onActionPressed: (value) {
                          if (value) {
                            widget.chatProvider
                                .setImagesFileList(listValue: []);
                          }
                        },
                      );
                    } else {
                      _pickImage();
                    }
                  },
                  child: (hasImages ? Text('Delete') : Text('Upload Quiz',
                  style : TextStyle(
                    color: Colors.black,
                  )
                  )),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.chatProvider.isLoading
              ? null
              : () {
                  // if (_textController.text.isNotEmpty) {
                  _sendChatMessage(
                    message:
                        'Extract the given image, read each MCQ carefully, and select the correct answer for each!',
                    isTextOnly: !hasImages,
                    saveDb: false,
                  );
                  // }
                },
          child: Container(
            
            margin: const EdgeInsets.all(5.0),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
              Icons.send,
              size: 28),
            ),
          ),
        ),
      ],
    );
  }
}
