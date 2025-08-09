import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';
import 'CustomText.dart';

class MenuDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const MenuDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorHelpers.primaryColor,
      title: CustomText(
        text: title,
        fontFamily: 'Anton',
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.left,
      ),
      content: CustomText(
        text: content,
        fontFamily: 'Anton',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: CustomText(
            text: 'Yes',
            fontFamily: 'Anton',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.left,
          ),
        ),
        TextButton(
          onPressed: onCancel,
          child: CustomText(
            text: 'No',
            fontFamily: 'Anton',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}