import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isTyping;
  
  const ChatBubble({
    super.key, 
    required this.message,
    this.isUser = false,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
              : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : null,
            bottomLeft: !isUser ? const Radius.circular(0) : null,
          ),
        ),
        child: isTyping
            ? _buildTypingAnimation()
            : Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
  
  Widget _buildTypingAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot().animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 300.ms)
          .fadeOut(duration: 300.ms),
        const SizedBox(width: 4),
        _buildDot()
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 300.ms, delay: 150.ms)
          .fadeOut(duration: 300.ms, delay: 150.ms),
        const SizedBox(width: 4),
        _buildDot()
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 300.ms, delay: 300.ms)
          .fadeOut(duration: 300.ms, delay: 300.ms),
      ],
    );
  }
  
  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isUser ? Colors.white : Colors.black54,
        shape: BoxShape.circle,
      ),
    );
  }
}
