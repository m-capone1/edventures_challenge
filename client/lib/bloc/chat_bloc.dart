import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../services/chat_services.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;
  final List<String> _messages = [];

  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      emit(ChatLoading());
      try {
        _messages.add(event.message);
        final aiResponse = await chatService.sendMessage(event.message);
        _messages.add(aiResponse);
        emit(ChatLoaded(_messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
