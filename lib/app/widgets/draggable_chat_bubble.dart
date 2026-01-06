import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/chatbot/bindings/chatbot_binding.dart';
import '../modules/chatbot/views/chatbot_view.dart';

class DraggableChatBubble extends StatefulWidget {
  const DraggableChatBubble({Key? key}) : super(key: key);

  @override
  State<DraggableChatBubble> createState() => _DraggableChatBubbleState();
}

class _DraggableChatBubbleState extends State<DraggableChatBubble> {
  double xPosition = 0;
  double yPosition = 0;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      // Screen এর right-bottom corner এ initial position
      xPosition = MediaQuery.of(context).size.width - 80;
      yPosition = MediaQuery.of(context).size.height - 180;
      isInitialized = true;
    }
  }

  void _openChatbot() {
    Get.to(
          () => const ChatbotView(),
      binding: ChatbotBinding(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: xPosition,
      top: yPosition,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            // Drag করার সময় position update
            xPosition += details.delta.dx;
            yPosition += details.delta.dy;

            // Screen boundary check - bubble বাইরে যাওয়া prevent করা
            if (xPosition < 0) xPosition = 0;
            if (yPosition < 0) yPosition = 0;
            if (xPosition > screenWidth - 60) xPosition = screenWidth - 60;
            if (yPosition > screenHeight - 60) yPosition = screenHeight - 60;
          });
        },
        onTap: _openChatbot,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFECD08),
                Color(0xFF987B05),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Chat Icon - Image Asset
              Center(
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 35,
                  height: 35,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image not found
                    return const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 32,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}