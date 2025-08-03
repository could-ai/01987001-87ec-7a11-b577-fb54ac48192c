import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final _messagesStream = Supabase.instance.client.from('messages').stream(primaryKey: ['id']).order('created_at');

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    if (text.isNotEmpty) {
      await Supabase.instance.client.from('messages').insert({'content': text, 'is_me': true});
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, int index) {
                    final message = messages[index];
                    return ChatMessage(
                      text: message['content'] as String,
                      isMe: message['is_me'] as bool,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
