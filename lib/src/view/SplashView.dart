import 'dart:async';

import 'package:beans_alert/src/helpers/ImageHelper.dart';
import 'package:beans_alert/src/view/LoginView.dart';
import 'package:beans_alert/src/widget/CustomLoadingBar.dart';
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
  double progress = 0.0;
  Timer? _timer;


  void initState() {
    super.initState();
    // Simulate a delay for loading
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.02;
        if (progress >= 1.0) {
          progress = 1.0;
          isLoading = false;
          _timer?.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            ? Padding(padding:  EdgeInsets.all(16.0),
          child: CustomLoadingBar(progress: progress, label: 'Loading...'),
        )
            : SizedBox(),
      ],
    ),
    ),
    );
  }
}