import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/ContactModel.dart';
import '../repository/ContactRepository.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class LoadContactsEvent extends ContactEvent {}

class AddPurokEvent extends ContactEvent {
  final String purokId;

  const AddPurokEvent({required this.purokId});

  @override
  List<Object> get props => [purokId];
}

class AddContactEvent extends ContactEvent {
  final String purokId;
  final ContactModel contact;

  const AddContactEvent({required this.purokId, required this.contact});

  @override
  List<Object> get props => [purokId, contact];
}

class UpdateContactEvent extends ContactEvent {
  final String purokId;
  final ContactModel contact;

  const UpdateContactEvent({required this.purokId, required this.contact});

  @override
  List<Object> get props => [purokId, contact];
}

class DeleteContactEvent extends ContactEvent {
  final String purokId;
  final String contactId;

  const DeleteContactEvent({required this.purokId, required this.contactId});

  @override
  List<Object> get props => [purokId, contactId];
}

class DeletePurokEvent extends ContactEvent {
  final String purokId;

  const DeletePurokEvent({required this.purokId});

  @override
  List<Object> get props => [purokId];
}

class CheckDuplicateEvent extends ContactEvent {
  final String name;
  final String phoneNumber;

  const CheckDuplicateEvent({required this.name, required this.phoneNumber});

  @override
  List<Object> get props => [name, phoneNumber];
}

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final Map<String, List<ContactModel>> purokContacts;

  const ContactLoaded(this.purokContacts);

  @override
  List<Object> get props => [purokContacts];
}

class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);

  @override
  List<Object> get props => [message];
}

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;

  ContactBloc({required this.contactRepository}) : super(ContactInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddPurokEvent>(_onAddPurok);
    on<AddContactEvent>(_onAddContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<DeletePurokEvent>(_onDeletePurok);
    on<CheckDuplicateEvent>(_onCheckDuplicate);
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());
    try {
      await emit.forEach<Map<String, List<ContactModel>>>(
        contactRepository.getPurokContacts(),
        onData: (purokContacts) => ContactLoaded(purokContacts),
        onError: (error, stackTrace) =>
            ContactError('Failed to load contacts: $error'),
      );
    } catch (e) {
      emit(ContactError('Failed to load contacts: ${e.toString()}'));
    }
  }

  Future<void> _onAddPurok(
    AddPurokEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await contactRepository.addPurok(event.purokId);
      Fluttertoast.showToast(msg: 'Purok added successfully');
      // Reload contacts after adding
      add(LoadContactsEvent());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(ContactError('Failed to add purok: ${e.toString()}'));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await contactRepository.addContact(event.purokId, event.contact);
      Fluttertoast.showToast(msg: 'Contact added successfully');
      // Reload contacts after adding
      add(LoadContactsEvent());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(ContactError('Failed to add contact: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateContact(
    UpdateContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await contactRepository.updateContact(event.purokId, event.contact);
      Fluttertoast.showToast(msg: 'Contact updated successfully');
      // Reload contacts after updating
      add(LoadContactsEvent());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(ContactError('Failed to update contact: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await contactRepository.deleteContact(event.purokId, event.contactId);
      Fluttertoast.showToast(msg: 'Contact deleted successfully');
      // Reload contacts after deleting
      add(LoadContactsEvent());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(ContactError('Failed to delete contact: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePurok(
    DeletePurokEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await contactRepository.deletePurok(event.purokId);
      Fluttertoast.showToast(msg: 'Purok deleted successfully');
      // Reload contacts after deleting
      add(LoadContactsEvent());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      emit(ContactError('Failed to delete purok: ${e.toString()}'));
    }
  }

  Future<void> _onCheckDuplicate(
    CheckDuplicateEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      final isDuplicate = await contactRepository.checkDuplicateContact(
        event.name,
        event.phoneNumber,
      );
      // This will be handled by the caller
    } catch (e) {
      emit(ContactError('Failed to check duplicate: ${e.toString()}'));
    }
  }

  Future<bool> checkDuplicate(String name, String phoneNumber) async {
    return await contactRepository.checkDuplicateContact(name, phoneNumber);
  }
}
