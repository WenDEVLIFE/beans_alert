import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';
import '../widget/CustomText.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();

}

class _SplashViewState extends State<SplashView> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash_image.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: 'BEANS',
                fontFamily: 'PlayfairDisplay',
                fontSize: 30.0,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                textAlign:  TextAlign.center
            ),
            SizedBox(width: screenWidth * 0.02),
            CustomText(text: 'ALERT',
                fontFamily: 'PlayfairDisplay',
                fontSize: 30.0,
                color: ColorHelpers.accentColor,
                fontWeight: FontWeight.w700,
                textAlign:  TextAlign.center
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        CircularProgressIndicator(
          color: ColorHelpers.accentColor,
          strokeWidth: 5.0,
        ),
      ],
    ),
    ),
    );
  }
}