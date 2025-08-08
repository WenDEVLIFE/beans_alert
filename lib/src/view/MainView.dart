import 'package:beans_alert/src/helpers/SvgHelpers.dart';
import 'package:beans_alert/src/widget/CustomNavigationSideBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        title: Text('Main View'),
      ),
      drawer: CustomNavigationSideBar(),
      body: Center(
        child: Text(
          'Welcome to the Main View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}