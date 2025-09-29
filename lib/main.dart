import 'package:beans_alert/src/bloc/ContactBloc.dart';
import 'package:beans_alert/src/bloc/LoginBloc.dart';
import 'package:beans_alert/src/bloc/MessageHistoryBloc.dart';
import 'package:beans_alert/src/bloc/UserBloc.dart';
import 'package:beans_alert/src/repository/ContactRepository.dart';
import 'package:beans_alert/src/repository/MessageHistoryRepository.dart';
import 'package:beans_alert/src/services/FirebaseService.dart';
import 'package:beans_alert/src/view/SplashView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(const MyApp());

  await FirebaseServices.run();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<ContactBloc>(
          create: (context) =>
              ContactBloc(contactRepository: ContactRepository()),
        ),
        BlocProvider<MessageHistoryBloc>(
          create: (context) => MessageHistoryBloc(
            messageHistoryRepository: MessageHistoryRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'E-Diary Cakes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashView(),
      ),
    );
  }
}
