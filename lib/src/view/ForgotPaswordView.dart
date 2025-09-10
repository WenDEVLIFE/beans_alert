import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/LoginBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../helpers/ImageHelper.dart';
import '../widget/CustomButton.dart';
import '../widget/CustomText.dart';
import '../widget/CustomTextField.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      backgroundColor: ColorHelpers.customblack1,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {},
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
                      color: ColorHelpers.secondaryColor,
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
                    controller: loginBloc.emailController,
                    hintText: 'Email',
                    borderColor: Colors.black45,
                    fillColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomButton(
                    hintText: 'Reset Password',
                    fontFamily: 'Anton',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    onPressed: () {
                      loginBloc.onResetPassword(context);
                    },
                    width: screenWidth * 0.60,
                    height: screenHeight * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
