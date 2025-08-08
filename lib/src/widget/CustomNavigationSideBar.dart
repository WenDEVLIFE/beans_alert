import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/ImageHelper.dart';

class CustomNavigationSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: ColorHelpers.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorHelpers.primaryColor,
            ),
            child: Center(
              child:  Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageHelper.logoPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ),
          ListTile(
            leading: SvgPicture.asset(
              SvgHelpers.userSettings,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            title: CustomText(text: 'User Management',
                fontFamily: 'Anton',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left),
            onTap: () {
              Navigator.pop(context);
              // Add navigation logic here
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              SvgHelpers.addEmail,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            title: CustomText(text: 'Send Message',
            fontFamily: 'Anton',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.left),
            onTap: () {
              Navigator.pop(context);
              // Add navigation logic here
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              SvgHelpers.email,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            title: CustomText(text: 'Message History',
                fontFamily: 'Anton',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left),
            onTap: () {
              Navigator.pop(context);
              // Add logout logic here
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              SvgHelpers.phonebook,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            title: CustomText(text: 'Contacts',
                fontFamily: 'Anton',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left),
            onTap: () {
              Navigator.pop(context);
              // Add logout logic here
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              SvgHelpers.calendar,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            title: CustomText(text: 'Calendar',
                fontFamily: 'Anton',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left),
            onTap: () {
              Navigator.pop(context);
              // Add logout logic here
            },
          ),
        ],
      ),
    );
  }
}