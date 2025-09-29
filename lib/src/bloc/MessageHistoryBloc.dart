import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../model/MessageHistory.dart';
import '../repository/MessageHistoryRepository.dart';
import '../services/SemaphoreService.dart';

abstract class MessageHistoryEvent extends Equatable {
  const MessageHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadMessageHistoryEvent extends MessageHistoryEvent {}

class AddMessageHistoryEvent extends MessageHistoryEvent {
  final MessageHistory messageHistory;

  const AddMessageHistoryEvent({required this.messageHistory});

  @override
  List<Object> get props => [messageHistory];
}

class DeleteMessageHistoryEvent extends MessageHistoryEvent {
  final String messageId;

  const DeleteMessageHistoryEvent({required this.messageId});

  @override
  List<Object> get props => [messageId];
}

class SearchMessageHistoryEvent extends MessageHistoryEvent {
  final String query;

  const SearchMessageHistoryEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ResendMessageEvent extends MessageHistoryEvent {
  final MessageHistory messageHistory;

  const ResendMessageEvent({required this.messageHistory});

  @override
  List<Object> get props => [messageHistory];
}

abstract class MessageHistoryState extends Equatable {
  const MessageHistoryState();

  @override
  List<Object> get props => [];
}

class MessageHistoryInitial extends MessageHistoryState {}

class MessageHistoryLoading extends MessageHistoryState {}

class MessageHistoryLoaded extends MessageHistoryState {
  final List<MessageHistory> messageHistory;

  const MessageHistoryLoaded(this.messageHistory);

  @override
  List<Object> get props => [messageHistory];
}

class MessageHistoryError extends MessageHistoryState {
  final String message;

  const MessageHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageHistoryBloc
    extends Bloc<MessageHistoryEvent, MessageHistoryState> {
  final MessageHistoryRepository messageHistoryRepository;
  final Uuid _uuid = const Uuid();

  MessageHistoryBloc({required this.messageHistoryRepository})
    : super(MessageHistoryInitial()) {
    on<LoadMessageHistoryEvent>(_onLoadMessageHistory);
    on<AddMessageHistoryEvent>(_onAddMessageHistory);
    on<DeleteMessageHistoryEvent>(_onDeleteMessageHistory);
    on<SearchMessageHistoryEvent>(_onSearchMessageHistory);
    on<ResendMessageEvent>(_onResendMessage);
  }

  Future<void> _onLoadMessageHistory(
    LoadMessageHistoryEvent event,
    Emitter<MessageHistoryState> emit,
  ) async {
    emit(MessageHistoryLoading());
    try {
      await emit.forEach<List<MessageHistory>>(
        messageHistoryRepository.getMessageHistory(),
        onData: (messageHistory) => MessageHistoryLoaded(messageHistory),
        onError: (error, stackTrace) =>
            MessageHistoryError('Failed to load message history: $error'),
      );
    } catch (e) {
      emit(
        MessageHistoryError('Failed to load message history: ${e.toString()}'),
      );
    }
  }

  Future<void> _onAddMessageHistory(
    AddMessageHistoryEvent event,
    Emitter<MessageHistoryState> emit,
  ) async {
    try {
      // Generate a unique ID if not provided
      final messageWithId = event.messageHistory.id.isEmpty
          ? event.messageHistory.copyWith(id: _uuid.v4())
          : event.messageHistory;

      await messageHistoryRepository.addMessageHistory(messageWithId);
      // Reload message history after adding
      add(LoadMessageHistoryEvent());
    } catch (e) {
      emit(
        MessageHistoryError('Failed to add message history: ${e.toString()}'),
      );
    }
  }

  Future<void> _onDeleteMessageHistory(
    DeleteMessageHistoryEvent event,
    Emitter<MessageHistoryState> emit,
  ) async {
    try {
      await messageHistoryRepository.deleteMessageHistory(event.messageId);
      // Reload message history after deleting
      add(LoadMessageHistoryEvent());
    } catch (e) {
      emit(
        MessageHistoryError(
          'Failed to delete message history: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSearchMessageHistory(
    SearchMessageHistoryEvent event,
    Emitter<MessageHistoryState> emit,
  ) async {
    if (event.query.isEmpty) {
      // If search query is empty, load all messages
      add(LoadMessageHistoryEvent());
      return;
    }

    emit(MessageHistoryLoading());
    try {
      await emit.forEach<List<MessageHistory>>(
        messageHistoryRepository.searchMessageHistory(event.query),
        onData: (messageHistory) => MessageHistoryLoaded(messageHistory),
        onError: (error, stackTrace) =>
            MessageHistoryError('Failed to search message history: $error'),
      );
    } catch (e) {
      emit(
        MessageHistoryError(
          'Failed to search message history: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onResendMessage(
    ResendMessageEvent event,
    Emitter<MessageHistoryState> emit,
  ) async {
    try {
      // Attempt to resend the SMS
      final result = await SemaphoreService.sendSMS(
        event.messageHistory.receiverPhone,
        event.messageHistory.message,
        senderName: event.messageHistory.senderName.isNotEmpty
            ? event.messageHistory.senderName
            : null,
      );

      if (result) {
        // Update the message history with success status and new timestamp
        final updatedMessage = event.messageHistory.copyWith(
          sentSuccessfully: true,
          timestamp: DateTime.now(),
        );

        await messageHistoryRepository.addMessageHistory(updatedMessage);
        Fluttertoast.showToast(
          msg: 'Message resent successfully',
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to resend message',
          backgroundColor: Colors.red,
        );
      }

      // Reload message history to reflect changes
      add(LoadMessageHistoryEvent());
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error resending message: $e',
        backgroundColor: Colors.red,
      );
      emit(MessageHistoryError('Failed to resend message: ${e.toString()}'));
    }
  }
}
