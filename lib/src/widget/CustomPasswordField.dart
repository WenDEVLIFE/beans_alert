import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final Color fillColor;
  final bool obscureText;
  final VoidCallback? onIconPressed;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.borderColor,
    required this.fillColor,
    required this.obscureText,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyle(
          fontFamily: 'Anton',
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Anton',
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: IconButton(
            icon: FaIcon(
              obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              color: Colors.black,
              size: 24.0,
            ),
            onPressed: onIconPressed,
          ),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: borderColor,
              width: 3.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}