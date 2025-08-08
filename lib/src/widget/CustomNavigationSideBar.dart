import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../helpers/ImageHelper.dart';

class CustomNavigationSideBar extends StatefulWidget {
  @override
  State<CustomNavigationSideBar> createState() => _CustomNavigationSideBarState();
}

class _CustomNavigationSideBarState extends State<CustomNavigationSideBar> {
  int selectedIndex = -1;

  final List<_DrawerItem> items = [
    _DrawerItem(SvgHelpers.userSettings, 'User Management'),
    _DrawerItem(SvgHelpers.addEmail, 'Send Message'),
    _DrawerItem(SvgHelpers.email, 'Message History'),
    _DrawerItem(SvgHelpers.phonebook, 'Contacts'),
    _DrawerItem(SvgHelpers.calendar, 'Calendar'),
  ];

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
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageHelper.logoPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return MouseRegion(
              onEnter: (_) => setState(() => selectedIndex = index),
              onExit: (_) => setState(() => selectedIndex = -1),
              child: ListTile(
                leading: SvgPicture.asset(
                  item.iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                title: CustomText(
                  text: item.title,
                  fontFamily: 'Anton',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
                selected: selectedIndex == index,
                selectedTileColor: Colors.white.withOpacity(0.2),
                onTap: () {
                  setState(() => selectedIndex = index);
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String iconPath;
  final String title;
  _DrawerItem(this.iconPath, this.title);
}