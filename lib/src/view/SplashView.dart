import 'package:beans_alert/src/helpers/ImageHelper.dart';
import 'package:beans_alert/src/view/LoginView.dart';
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

  bool isLoading = true;

  void initState() {
    super.initState();
    // Simulate a delay for loading
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
      // Navigate to the next screen or perform any action after loading
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) {
        return LoginView();
      }));
    });
  }

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
        SizedBox(height: screenHeight * 0.02),
        isLoading
            ? CircularProgressIndicator(
                color: ColorHelpers.accentColor,
              )
            : SizedBox(),
      ],
    ),
    ),
    );
  }
}