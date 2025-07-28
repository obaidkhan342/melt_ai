// ignore_for_file: unused_local_variable, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import '../providers/chat_provider.dart';
import 'package:provider/provider.dart';
import '../model/message.dart';

class PreviewImagesWidget extends StatelessWidget {
  final Message? message;

  PreviewImagesWidget({this.message});

  @override
  Widget build(BuildContext context){
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      final messageToShow =
          message != null ? message!.imageUrls : chatProvider.imageFileList;

      final padding = message != null
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 8.0, right: 8.0);

      return Padding(
          padding: padding,
          child: SizedBox(
              height: 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: messageToShow!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        4.0,
                        8.0,
                        4.0,
                        0.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          File(
                            message != null
                                ? message!.imageUrls[index]
                                : chatProvider.imageFileList![index].path,
                          ),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  })));
    });
  }
}
