import 'package:beans_alert/src/repository/RegisterRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}


abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {

  final RegisterRepositoryImpl registerRepository = RegisterRepositoryImpl();
  UserBloc() : super(UserInitial()) {

  }

  // Insert the user to the database
  Future <void> insertUser(String fullname, String email, String role, String password) async {

    try {
     bool isAdded =  await registerRepository.insertUser(fullname, email, role, password);

     if (isAdded) {
       Fluttertoast.showToast(msg: 'User added successfully');
     } else {
       Fluttertoast.showToast(msg: 'Failed to add user');
     }
    } catch (e) {
      rethrow;
    }

  }
}