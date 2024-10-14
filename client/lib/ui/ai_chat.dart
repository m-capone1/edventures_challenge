import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../services/chat_services.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  AiChatState createState() => AiChatState();
}

class AiChatState extends State<AiChat> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(ChatService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('AI Chat')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            List<String> messages = [];
            bool isUserMessage = false;

            if (state is ChatLoaded) {
              messages = state.messages;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      isUserMessage = index.isOdd;

                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.blue[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            messages[index],
                            style: TextStyle(
                              color:
                                  isUserMessage ? Colors.black : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              logger.i('Updated Profile: $value');
                              BlocProvider.of<ChatBloc>(context)
                                  .add(SendMessage(value));
                              _controller.clear();
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final message = _controller.text.trim();
                          if (message.isNotEmpty) {
                            BlocProvider.of<ChatBloc>(context)
                                .add(SendMessage(message));
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
