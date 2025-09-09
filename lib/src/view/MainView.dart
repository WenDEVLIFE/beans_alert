import 'package:beans_alert/src/bloc/UserBloc.dart';
import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/ColorHelpers.dart';
import '../widget/AddUserDialog.dart';
import '../widget/CustomText.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late UserBloc  userbloc;

  @override
  void initState() {
    super.initState();
    userbloc = UserBloc();

  }

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
      body: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
           Align(
             alignment: Alignment.centerLeft,
             child:    Padding(
               padding: EdgeInsets.only(left: screenWidth * 0.05),
               child:CustomText(text: 'User Management View',
                   fontFamily: 'Poppins',
                   fontSize: 30.0,
                   color: Colors.black,
                   fontWeight: FontWeight.w700,
                   textAlign:  TextAlign.center
               ),
             ),
           ),
            ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const AddUserDialog(),
          );
          if (result != null) {
            String fullname = result['fullName'];
            String email = result['email'];
            String role = result['role'];
            String password = result['password'];

            userbloc.insertUser(fullname, email, role, password);

          }
        },
        backgroundColor: ColorHelpers.accentColor,
        child:  FaIcon(
          FontAwesomeIcons.add,
        color: Colors.white,
        size: 24.0,
      ),
    ),
    );
  }
}