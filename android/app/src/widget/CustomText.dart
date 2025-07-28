import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomText({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    required this.fontWeight, required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {

    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color:  text == 'Sign In' ? color : text == 'Sign Up' ? color : text == 'What are you feeling right now?' ? color : text == 'Your Feelings are welcome, whenever you like to share' ? color : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }


}