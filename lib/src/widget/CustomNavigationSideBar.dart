import 'package:beans_alert/src/helpers/ColorHelpers.dart';
import 'package:beans_alert/src/helpers/SessionHelpers.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/view/ScheduleView.dart';
import 'package:beans_alert/src/view/LoginView.dart';
import 'package:beans_alert/src/view/MainView.dart';
import 'package:beans_alert/src/view/MessageHistory.dart';
import 'package:beans_alert/src/view/SendMessageView.dart';
import 'package:beans_alert/src/widget/CustomText.dart';
import 'package:beans_alert/src/widget/MenuDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../helpers/ImageHelper.dart';
import '../model/DrawerItem.dart';
import '../view/ContactView.dart';

class CustomNavigationSideBar extends StatefulWidget {
  @override
  State<CustomNavigationSideBar> createState() =>
      _CustomNavigationSideBarState();
}

class _CustomNavigationSideBarState extends State<CustomNavigationSideBar> {
  int selectedIndex = -1;
  late BuildContext contextData;

  final List<DrawerItem> items = [
    DrawerItem(SvgHelpers.userSettings, 'User Management'),
    DrawerItem(SvgHelpers.addEmail, 'Send Message'),
    DrawerItem(SvgHelpers.email, 'Message History'),
    DrawerItem(SvgHelpers.phonebook, 'Contacts'),
    DrawerItem(SvgHelpers.calendar, 'Scheduling'),
    DrawerItem(SvgHelpers.logout, 'Logout'),
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
            decoration: BoxDecoration(color: ColorHelpers.primaryColor),
            child: Center(
              child: Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
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
                    ColorHelpers.secondaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: CustomText(
                  text: item.title,
                  fontFamily: 'Anton',
                  fontSize: 20,
                  color: ColorHelpers.secondaryColor,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
                selected: selectedIndex == index,
                selectedTileColor: Colors.white.withOpacity(0.2),
                onTap: () {
                  setState(() => selectedIndex = index);
                  Navigator.pop(context);
                  // Add navigation logic here

                  if (index == 0) {
                    // Navigate to User Management
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                    );
                  } else if (index == 1) {
                    // Navigate to Send Message
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendMessageView(),
                      ),
                    );
                  } else if (index == 2) {
                    // Navigate to Message History
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MessageHistory()),
                    );
                  } else if (index == 3) {
                    // Navigate to Contacts
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ContactView()),
                    );
                  } else if (index == 4) {
                    // Navigate to Calendar
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarView()),
                    );
                  } else if (index == 5) {
                    final mainContext = context; // Save the main screen context

                    // Show the confirmation dialog
                    showDialog(
                      context: mainContext,
                      builder: (dialogContext) => MenuDialog(
                        title: 'Logout',
                        content: 'Are you sure you want to logout?',
                        onConfirm: () {
                          Navigator.pop(dialogContext);

                          SessionHelpers.clearUserInfo();
                          Navigator.pushReplacement(
                            dialogContext,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        onCancel: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
