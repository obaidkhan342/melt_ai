import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../helper/global.dart';

class BotMessage extends StatelessWidget {
  final String msg;
  const BotMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    const r = Radius.circular(15);
    return Row(
      children: [
        const SizedBox(width: 6),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Image.asset(
            'assets/images/logo.png',
            width: 24,
          ),
        ),
        Container(
            constraints: BoxConstraints(maxWidth: mq.width * .6),
            margin: EdgeInsets.only(
              bottom: mq.height * .02,
              left: mq.width * .02,
            ),
            padding: EdgeInsets.symmetric(
                vertical: mq.height * .01, horizontal: mq.width * .02
              ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: r, topRight: r, bottomRight: r),
            ),
            child: msg.isEmpty
                ? AnimatedTextKit(animatedTexts: [
                    TypewriterAnimatedText(
                      ' Please wait... ',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ], repeatForever: true)
                : MarkdownBody(data: msg, selectable: true)),
      ],
    );
  }
}
