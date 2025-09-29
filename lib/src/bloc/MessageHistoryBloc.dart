import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../model/MessageHistory.dart';
import '../repository/MessageHistoryRepository.dart';

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
}
