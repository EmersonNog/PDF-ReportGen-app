// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/dialog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  TextStyle typingTextStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    _addInitialGreeting();
  }

  void _addInitialGreeting() {
    final currentTime = DateTime.now().hour;
    String greetingMessage;

    if (currentTime >= 6 && currentTime < 12) {
      greetingMessage = "Olá, bom dia! Sou seu assistente digital. Em que posso ajudar?";
    } else if (currentTime >= 12 && currentTime < 18) {
      greetingMessage = "Olá, boa tarde! Sou seu assistente digital. Em que posso ajudar?";
    } else {
      greetingMessage = "Olá, boa noite! Sou seu assistente digital. Em que posso ajudar?";
    }

    String typingResponse = "Digitando...";
    _messages.insert(
        0,
        ChatMessage(
            text: greetingMessage, isBot: true, timestamp: DateTime.now()));

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(
            0,
            ChatMessage(
              text: typingResponse,
              isBot: true,
              timestamp: DateTime.now(),
              isTyping: true,
              textStyle: typingTextStyle,
            ));
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _messages.removeWhere((message) => message.text == typingResponse);
          String optionsResponse =
              "Digite AJUDA para informações específicas\n\n"
              "Digite CONTATO para contatar o desenvolvedor\n\n"
              "Digite SOBRE para mais informações do aplicativo";
          _messages.insert(
              0,
              ChatMessage(
                  text: optionsResponse,
                  isBot: true,
                  timestamp: DateTime.now()));
        });
      });
    });
  }

  void _handleSubmitted(String text) {
    _sendMessage(text);
    _botResponse(text);
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.insert(
          0, ChatMessage(text: text, isBot: false, timestamp: DateTime.now()));
    });
  }

  void _botResponse(String question) {
    String typingResponse = "Digitando...";
    setState(() {
      _messages.insert(
          0,
          ChatMessage(
            text: typingResponse,
            isBot: true,
            timestamp: DateTime.now(),
            isTyping: true,
            textStyle: typingTextStyle,
          ));
    });

    Future.delayed(const Duration(seconds: 3), () {
      String response = getBotResponse(question);
      setState(() {
        _messages.removeWhere((message) => message.text == typingResponse);
        _messages.insert(
            0,
            ChatMessage(
                text: response, isBot: true, timestamp: DateTime.now()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        title: const Text(
          'Certare ChatBot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Prototype',
            letterSpacing: 1.5
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
              ),
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: 'Digite uma mensagem...',
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_textController.text.isNotEmpty) {
                _handleSubmitted(_textController.text);
                _textController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade600,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final bool isTyping;
  final TextStyle? textStyle;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isBot,
    required this.timestamp,
    this.isTyping = false,
    this.textStyle,
  }); // Update the constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          if (isBot)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/chatbot/bot.png'),
                backgroundColor: Colors.transparent,
                maxRadius: 20,
              ),
            ),
          Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.71,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isBot
                    ? isTyping
                        ? Colors.transparent
                        : Colors.grey[300]
                    : Colors.indigo.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment:
                    isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    text,
                    style: isBot
                        ? (isTyping
                            ? textStyle
                            : const TextStyle(color: Colors.black))
                        : const TextStyle(color: Colors.white),
                  ),
                  if (!isTyping)
                    const SizedBox(
                      height: 3,
                    ),
                  if (!isTyping)
                    Text(
                      _formatTimestamp(timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isBot ? Colors.grey : Colors.white70,
                      ),
                    ),
                ],
              )),
          if (!isBot)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/chatbot/user.png'),
                backgroundColor: Colors.transparent,
                maxRadius: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format the timestamp as desired, e.g., "HH:mm"
    return DateFormat('HH:mm').format(timestamp);
  }
}
