import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../model/ScheduledMessage.dart';
import '../repository/ScheduledMessageRepository.dart';
import '../services/SemaphoreService.dart';

abstract class ScheduledMessageEvent extends Equatable {
  const ScheduledMessageEvent();

  @override
  List<Object> get props => [];
}

class LoadScheduledMessagesEvent extends ScheduledMessageEvent {}

class AddScheduledMessageEvent extends ScheduledMessageEvent {
  final ScheduledMessage scheduledMessage;

  const AddScheduledMessageEvent({required this.scheduledMessage});

  @override
  List<Object> get props => [scheduledMessage];
}

class UpdateScheduledMessageEvent extends ScheduledMessageEvent {
  final ScheduledMessage scheduledMessage;

  const UpdateScheduledMessageEvent({required this.scheduledMessage});

  @override
  List<Object> get props => [scheduledMessage];
}

class DeleteScheduledMessageEvent extends ScheduledMessageEvent {
  final String messageId;

  const DeleteScheduledMessageEvent({required this.messageId});

  @override
  List<Object> get props => [messageId];
}

class SearchScheduledMessagesEvent extends ScheduledMessageEvent {
  final String query;

  const SearchScheduledMessagesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class CheckAndSendScheduledMessagesEvent extends ScheduledMessageEvent {}

abstract class ScheduledMessageState extends Equatable {
  const ScheduledMessageState();

  @override
  List<Object> get props => [];
}

class ScheduledMessageInitial extends ScheduledMessageState {}

class ScheduledMessageLoading extends ScheduledMessageState {}

class ScheduledMessageLoaded extends ScheduledMessageState {
  final List<ScheduledMessage> scheduledMessages;

  const ScheduledMessageLoaded(this.scheduledMessages);

  @override
  List<Object> get props => [scheduledMessages];
}

class ScheduledMessageError extends ScheduledMessageState {
  final String message;

  const ScheduledMessageError(this.message);

  @override
  List<Object> get props => [message];
}

class ScheduledMessageBloc
    extends Bloc<ScheduledMessageEvent, ScheduledMessageState> {
  final ScheduledMessageRepository scheduledMessageRepository;
  final Uuid _uuid = const Uuid();
  Timer? _schedulerTimer;

  ScheduledMessageBloc({required this.scheduledMessageRepository})
    : super(ScheduledMessageInitial()) {
    on<LoadScheduledMessagesEvent>(_onLoadScheduledMessages);
    on<AddScheduledMessageEvent>(_onAddScheduledMessage);
    on<UpdateScheduledMessageEvent>(_onUpdateScheduledMessage);
    on<DeleteScheduledMessageEvent>(_onDeleteScheduledMessage);
    on<SearchScheduledMessagesEvent>(_onSearchScheduledMessages);
    on<CheckAndSendScheduledMessagesEvent>(_onCheckAndSendScheduledMessages);

    // Start the scheduler timer to check for due messages every minute
    _startScheduler();
  }

  void _startScheduler() {
    // Check every minute for due scheduled messages
    _schedulerTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      add(CheckAndSendScheduledMessagesEvent());
    });
  }

  void dispose() {
    _schedulerTimer?.cancel();
  }

  Future<void> _onLoadScheduledMessages(
    LoadScheduledMessagesEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    emit(ScheduledMessageLoading());
    try {
      await emit.forEach<List<ScheduledMessage>>(
        scheduledMessageRepository.getScheduledMessages(),
        onData: (scheduledMessages) =>
            ScheduledMessageLoaded(scheduledMessages),
        onError: (error, stackTrace) =>
            ScheduledMessageError('Failed to load scheduled messages: $error'),
      );
    } catch (e) {
      emit(
        ScheduledMessageError(
          'Failed to load scheduled messages: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddScheduledMessage(
    AddScheduledMessageEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    try {
      // Generate a unique ID if not provided
      final messageWithId = event.scheduledMessage.id.isEmpty
          ? event.scheduledMessage.copyWith(id: _uuid.v4())
          : event.scheduledMessage;

      await scheduledMessageRepository.addScheduledMessage(messageWithId);
      Fluttertoast.showToast(
        msg: 'Message scheduled successfully',
        backgroundColor: Colors.green,
      );
      // Reload scheduled messages after adding
      add(LoadScheduledMessagesEvent());
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error scheduling message: $e',
        backgroundColor: Colors.red,
      );
      emit(
        ScheduledMessageError(
          'Failed to add scheduled message: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateScheduledMessage(
    UpdateScheduledMessageEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    try {
      await scheduledMessageRepository.updateScheduledMessage(
        event.scheduledMessage,
      );
      Fluttertoast.showToast(
        msg: 'Scheduled message updated',
        backgroundColor: Colors.green,
      );
      // Reload scheduled messages after updating
      add(LoadScheduledMessagesEvent());
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating scheduled message: $e',
        backgroundColor: Colors.red,
      );
      emit(
        ScheduledMessageError(
          'Failed to update scheduled message: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteScheduledMessage(
    DeleteScheduledMessageEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    try {
      await scheduledMessageRepository.deleteScheduledMessage(event.messageId);
      Fluttertoast.showToast(
        msg: 'Scheduled message deleted',
        backgroundColor: Colors.green,
      );
      // Reload scheduled messages after deleting
      add(LoadScheduledMessagesEvent());
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error deleting scheduled message: $e',
        backgroundColor: Colors.red,
      );
      emit(
        ScheduledMessageError(
          'Failed to delete scheduled message: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSearchScheduledMessages(
    SearchScheduledMessagesEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    if (event.query.isEmpty) {
      // If search query is empty, load all messages
      add(LoadScheduledMessagesEvent());
      return;
    }

    emit(ScheduledMessageLoading());
    try {
      await emit.forEach<List<ScheduledMessage>>(
        scheduledMessageRepository.searchScheduledMessages(event.query),
        onData: (scheduledMessages) =>
            ScheduledMessageLoaded(scheduledMessages),
        onError: (error, stackTrace) => ScheduledMessageError(
          'Failed to search scheduled messages: $error',
        ),
      );
    } catch (e) {
      emit(
        ScheduledMessageError(
          'Failed to search scheduled messages: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCheckAndSendScheduledMessages(
    CheckAndSendScheduledMessagesEvent event,
    Emitter<ScheduledMessageState> emit,
  ) async {
    try {
      final now = DateTime.now();

      // Get all pending scheduled messages
      final pendingMessages = await scheduledMessageRepository
          .getPendingScheduledMessages()
          .first; // Get the first emission from the stream

      for (final message in pendingMessages) {
        // Check if the scheduled time has passed
        if (message.scheduledTime.isBefore(now) ||
            message.scheduledTime.isAtSameMomentAs(now)) {
          print('📅 Processing scheduled message: ${message.id}');

          // Send SMS to all recipients
          int successCount = 0;
          int failCount = 0;

          for (int i = 0; i < message.recipientPhones.length; i++) {
            final phone = message.recipientPhones[i];
            final name = message.recipientNames[i];

            final result = await SemaphoreService.sendSMS(
              phone,
              message.message,
              senderName: message.senderName.isNotEmpty
                  ? message.senderName
                  : null,
            );

            if (result) {
              successCount++;
            } else {
              failCount++;
            }
          }

          // Mark as sent
          await scheduledMessageRepository.markAsSent(message.id, now);

          print(
            '✅ Scheduled message sent: ${message.id} - $successCount success, $failCount failed',
          );
        }
      }
    } catch (e) {
      print('❌ Error processing scheduled messages: $e');
      emit(
        ScheduledMessageError(
          'Failed to process scheduled messages: ${e.toString()}',
        ),
      );
    }
  }
}
