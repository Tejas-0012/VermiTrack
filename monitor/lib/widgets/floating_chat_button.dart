import 'package:flutter/material.dart';
import 'package:monitor/screens/chat_screen.dart';
import 'package:monitor/utils/colors.dart';

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> {
  bool _hasNewMessage = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openChat,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: Stack(
        children: [
          const Icon(Icons.chat, size: 24),
          if (_hasNewMessage)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );

    // Mark as read
    setState(() {
      _hasNewMessage = false;
    });
  }

  // Call this when you want to show new message notification
  void showNewMessageNotification() {
    setState(() {
      _hasNewMessage = true;
    });

    // You can also trigger a vibration or sound here
  }
}
