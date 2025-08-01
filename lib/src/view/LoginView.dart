import 'package:beans_alert/src/bloc/LoginBloc.dart';
import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:beans_alert/src/widget/CustomButton.dart';
import 'package:beans_alert/src/widget/CustomPasswordField.dart';
import 'package:beans_alert/src/widget/CustomTextButton.dart';
import 'package:beans_alert/src/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/ImageHelper.dart';
import '../widget/CustomText.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state){

        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageHelper.logoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'BEANS',
                      fontFamily: 'Anton',
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    CustomText(
                      text: 'ALERT',
                      fontFamily: 'Anton',
                      fontSize: 30.0,
                      color: ColorHelpers.accentColor,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CustomTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    borderColor: Colors.black45,
                    fillColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CustomPasswordField(
                    controller: _passwordController,
                    hintText: 'Password',
                    borderColor: Colors.black45,
                    fillColor: Colors.white,
                    obscureText: _obscureText,
                    onIconPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: CustomTextButton(text: 'Forgot Password?', fontFamily: 'Anton', fontWeight: FontWeight.w400, fontSize: 14, textColor: Colors.black, onPressed: (){

                      }),
                    )
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomButton(hintText: 'Login', fontFamily: 'Anton', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

                  }, width: screenWidth * 0.60, height: screenHeight * 0.06,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}