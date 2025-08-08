import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/ColorHelpers.dart';
import '../widget/CustomText.dart';

class SendMessageView extends StatelessWidget {
  const SendMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              SvgHelpers.menulist,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
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
      ),
      drawer: CustomNavigationSideBar(),
      body: Center(
        child: Text(
          'Send Message View',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}