import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main View'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Main View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}