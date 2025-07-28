// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/message.dart';
import 'preview_images_widget.dart';

class UserMessage extends StatelessWidget {
  final Message message;
  final bool showText;
  const UserMessage({
    super.key,
    required this.message,
    this.showText  = true
  });

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(15);
    final mq = MediaQuery.of(context).size;
  return Row(
	mainAxisAlignment: MainAxisAlignment.end, 
	children: [
      Container(
        constraints: BoxConstraints(maxWidth: mq.width * .6),
        margin: EdgeInsets.only(bottom: mq.height * .02, right: mq.width * .02),
        padding: EdgeInsets.symmetric(
        vertical: mq.height * .01, horizontal: mq.width * .02
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: const BorderRadius.only(
                topLeft: r, topRight: r, bottomLeft: r)),
        child: Column(
          children: [
            if (message.imageUrls.isNotEmpty)
              PreviewImagesWidget(
                message: message,
              ),
           showText ?  MarkdownBody(data: message.message.toString(), selectable: true) : Container(),
          ],
        ),
      ),
      const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(Icons.person,
        color : Colors.black,
        ),
      ),
      const SizedBox(width: 6),
    ]);
  }
}
