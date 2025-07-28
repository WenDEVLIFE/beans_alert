import 'package:beans_alert/src/bloc/LoginBloc.dart';
import 'package:beans_alert/src/view/SplashView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc()
        ),
      ],
      child:  MaterialApp(
        title: 'E-Diary Cakes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,

        ),
        home: const SplashView(),
    )
    );
  }
}
