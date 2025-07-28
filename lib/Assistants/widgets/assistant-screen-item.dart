// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, file_names

import 'package:flutter/material.dart';

class AssistantScreenItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onPressed;

  AssistantScreenItem({
    required this.title,
     this.icon,
    required this.onPressed,
     this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
    
    onTap: onPressed, child: Container(
     
      decoration: BoxDecoration(
         color: const Color.fromARGB(255, 228, 219, 219),
        // color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment : CrossAxisAlignment.center,
      children: [
        icon != null ? Icon(
          icon, 
          size : 40,
        )
        : Image.asset('imagePath'),
      const SizedBox(
        height : 15,
      ),
      Text(
        title,
        style : const TextStyle(
          // fontFamily : semibold,
          fontSize : 14
        )
      )
      ],
    ),
    ));
  }
}
