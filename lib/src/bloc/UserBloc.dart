import 'package:beans_alert/src/model/UserModel.dart';
import 'package:beans_alert/src/repository/RegisterRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class AddUserEvent extends UserEvent {
  final String fullname;
  final String email;
  final String role;
  final String password;

  const AddUserEvent({
    required this.fullname,
    required this.email,
    required this.role,
    required this.password,
  });

  @override
  List<Object> get props => [fullname, email, role, password];
}

class UpdateUserEvent extends UserEvent {
  final String userId;
  final String fullname;
  final String email;
  final String role;

  const UpdateUserEvent({
    required this.userId,
    required this.fullname,
    required this.email,
    required this.role,
  });

  @override
  List<Object> get props => [userId, fullname, email, role];
}

class DeleteUserEvent extends UserEvent {
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterRepositoryImpl registerRepository = RegisterRepositoryImpl();

  UserBloc() : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<AddUserEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await registerRepository.getAllUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: ${e.toString()}'));
    }
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    try {
      bool isAdded = await registerRepository.insertUser(
        event.fullname,
        event.email,
        event.role,
        event.password,
      );

      if (isAdded) {
        Fluttertoast.showToast(msg: 'User added successfully');
        // Reload users after adding
        add(LoadUsersEvent());
      } else {
        Fluttertoast.showToast(msg: 'Failed to add user');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(UserError('Failed to add user: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      bool isUpdated = await registerRepository.updateUser(
        event.userId,
        event.fullname,
        event.email,
        event.role,
      );

      if (isUpdated) {
        Fluttertoast.showToast(
          msg: 'User updated successfully',
          backgroundColor: Colors.green,
        );
        // Reload users after updating
        add(LoadUsersEvent());
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to update user',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
      );
      emit(UserError('Failed to update user: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      // First, get the user to check their role
      UserModel? userToDelete = await registerRepository.getUserById(event.userId);

      if (userToDelete == null) {
        Fluttertoast.showToast(
          msg: 'User not found',
          backgroundColor: Colors.red,
        );
        return;
      }

      // Prevent deletion of admin users
      if (userToDelete.role.toLowerCase() == 'admin') {
        Fluttertoast.showToast(
          msg: 'Cannot delete admin account',
          backgroundColor: Colors.orange,
        );
        return;
      }

      bool isDeleted = await registerRepository.deleteUser(event.userId);

      if (isDeleted) {
        Fluttertoast.showToast(
          msg: 'User deleted successfully',
          backgroundColor: Colors.green,
        );
        // Reload users after deleting
        add(LoadUsersEvent());
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to delete user',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
      );
      emit(UserError('Failed to delete user: ${e.toString()}'));
    }
  }

  // Legacy method for backward compatibility
  Future<void> insertUser(
    String fullname,
    String email,
    String role,
    String password,
  ) async {
    add(
      AddUserEvent(
        fullname: fullname,
        email: email,
        role: role,
        password: password,
      ),
    );
  }

  // Helper method for updating user
  Future<void> updateUser(
    String userId,
    String fullname,
    String email,
    String role,
  ) async {
    add(
      UpdateUserEvent(
        userId: userId,
        fullname: fullname,
        email: email,
        role: role,
      ),
    );
  }

  // Helper method for deleting user
  Future<void> deleteUser(String userId) async {
    add(DeleteUserEvent(userId: userId));
  }
}
