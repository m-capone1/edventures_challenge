import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../services/chat_services.dart';

class AiChat extends StatelessWidget {
  const AiChat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(ChatService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('AI Chat')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            List<String> messages = [];
            if (state is ChatLoaded) {
              messages = state.messages;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
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
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(SendMessage(value));
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
                          final controller = TextEditingController();
                          final message = controller.text.trim();
                          if (message.isNotEmpty) {
                            BlocProvider.of<ChatBloc>(context)
                                .add(SendMessage(message));
                            controller.clear();
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
