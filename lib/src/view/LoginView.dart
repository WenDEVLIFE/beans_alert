import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:beans_alert/src/widget/CustomTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ImageHelper.dart';
import '../widget/CustomText.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final TextEditingController controller = TextEditingController();

    return Scaffold(
      body: Center(
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
                  CustomText(text: 'BEANS',
                      fontFamily: 'Anton',
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      textAlign:  TextAlign.center
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  CustomText(text: 'ALERT',
                      fontFamily: 'Anton',
                      fontSize: 30.0,
                      color: ColorHelpers.accentColor,
                      fontWeight: FontWeight.w400,
                      textAlign:  TextAlign.center
                  ),
                ],
              ),
               Padding(padding: EdgeInsets.all(16.0),
                child: CustomTextField(controller: controller, hintText: 'Username', borderColor: Colors.black45, fillColor: Colors.white),
               ),
            ],
          ),
        )
      ),
    );
  }
}