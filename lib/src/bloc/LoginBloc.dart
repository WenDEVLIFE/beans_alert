import 'package:beans_alert/src/repository/LoginRepository.dart';
import 'package:beans_alert/src/view/MainView.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class LoginEvent extends Equatable {
   @override
  List<Object?> get props => [];
}

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRepositoryImpl loginRepository = LoginRepositoryImpl();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

  }

  Future<void> onLogin(BuildContext context) async {

    if (emailController.text.isEmpty) {
      throw Exception('Email is required');

    }

    if (passwordController.text.isEmpty) {
      throw Exception('Password is required');
    }

    try{
      Map<String, dynamic> userData = await loginRepository.login(emailController.text, passwordController.text);
      if (userData.isNotEmpty) {
        // Login successful, you can handle user data here
        debugPrint('Login successful: $userData');
        Fluttertoast.showToast(msg: 'Login successful');
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MainView()));
      } else {
        Fluttertoast.showToast(msg: 'Invalid login credentials');
        throw Exception('Invalid login credentials');
      }
    } catch (e) {
      rethrow;
    }




  }


}