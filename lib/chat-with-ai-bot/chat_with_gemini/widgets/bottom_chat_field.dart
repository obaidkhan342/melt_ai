// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_field, unused_local_variable, prefer_const_constructors, library_private_types_in_public_api

import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../providers/chat_provider.dart';
import '../utility/utility.dart';
import 'preview_images_widget.dart';

class BottomChatField extends StatefulWidget {
  final ChatProvider chatProvider;

  BottomChatField({required this.chatProvider});

  @override
  _BottomChatFieldState createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> _sendChatMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    try {
      await widget.chatProvider
          .sentMessage(message: message, isTextOnly: isTextOnly);
      _textController.clear();
    } catch (e) {
      log('Error: $e');
    } finally {
      _textController.clear();
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
              border: Border.all(
                color: Theme.of(context).textTheme.titleLarge?.color ??
                    Colors.transparent,
              ),
            ),
            child: Column(
              children: [
                if (hasImages) PreviewImagesWidget(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (hasImages) {
                          showMyAnimatedDialog(
                            context: context,
                            title: 'Delete Images',
                            content:
                                'Are you sure you want to delete the images?',
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
                      icon:
                          Icon(hasImages ? Icons.delete_forever : Icons.image),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        // expands : true,
                        maxLines: null,
                        minLines: 1,
                        focusNode: _textFieldFocus,
                        controller: _textController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: widget.chatProvider.isLoading
                            ? null
                            : (String value) {
                                if (value.isNotEmpty) {
                                  _sendChatMessage(
                                    message: value,
                                    isTextOnly: !hasImages,
                                  );
                                }
                              },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter a prompt...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.chatProvider.isLoading
                          ? null
                          : () {
                              if (_textController.text.isNotEmpty) {
                                _sendChatMessage(
                                  message: _textController.text,
                                  isTextOnly: !hasImages,
                                );
                              }
                              ;
                              _textController.clear();   
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Icon(Icons.send, color: Colors.black, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
