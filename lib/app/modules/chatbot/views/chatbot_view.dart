import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/chatbot_controller.dart';
import 'package:flutter/services.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Get.back();
        },
            icon: Icon(Icons.arrow_back_ios_new)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/images/menu.png',
                height: 24,
                width: 24,
                color: Color(0xFF1F2937),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
        title: Row(
          children: [
            Image.asset('assets/images/chat_icon.png',height: 24,width: 24),
            const SizedBox(width: 8),
            Text(
              'Tripbank AI',
              style: GoogleFonts.roboto(
                color: Color(0xFF3A3A3A),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          // Chat messages area

          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return _buildMessageBubble(message);
              },
            )),
          ),

          // Input area

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [

                  // Text input field with microphone icon

                  Expanded(
                    child: Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: controller.isListening.value
                            ? Color(0xFFFFFAE6)
                            : Color(0xFFFFFAE6),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: controller.isListening.value
                              ? Color(0xFFFECD08)
                              : Color(0xFFFECD08),
                          width: controller.isListening.value ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              enabled: !controller.isListening.value,
                              decoration: InputDecoration(
                                hintText: controller.isListening.value
                                    ? 'Listening...'
                                    : 'Type your question...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: controller.isListening.value
                                      ? Colors.amber[700]
                                      : Color(0xFF3A3A3A),
                                  fontSize: 15,
                                ),
                              ),
                              onSubmitted: (_) => controller.sendMessage(),
                            ),
                          ),

                          // Microphone icon for voice input

                          IconButton(
                            icon: Icon(
                              controller.isListening.value
                                  ? Icons.mic
                                  : Icons.mic_none,
                              color: controller.isListening.value
                                  ? Colors.red
                                  : Color(0xFF3A3A3A),
                              size: 24,
                            ),
                            onPressed: controller.toggleListening,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    )),
                  ),
                  const SizedBox(width: 8),

                  // Send button

                  Obx(() => Container(
                    child: controller.isLoadingResponse.value
                        ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                        : IconButton(
                      icon: Image.asset('assets/images/send.png'),
                      onPressed: controller.sendMessage,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Build Drawer

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFFFDFDFD),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  controller.startNewChat();
                  Get.back();
                },
                child: Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/edit.png', color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        'New chat',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.grey[300]),

            // History Header with Loading Indicator

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/images/history.png', color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    'History',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF4B5563),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => controller.isLoadingHistory.value
                      ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFECD08)),
                    ),
                  )
                      : SizedBox.shrink()),
                ],
              ),
            ),

            Divider(color: Colors.grey[300]),

            // Chat History List

            Expanded(
              child: Obx(() {
                if (controller.chatHistory.isEmpty &&
                    !controller.isLoadingHistory.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'No chat history yet',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start a new conversation!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //  History list

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = controller.chatHistory[index];
                    return _buildHistoryItem(chat);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //  Build History Item

  Widget _buildHistoryItem(Map<String, dynamic> chat) {
    return InkWell(
      onTap: () => controller.loadChatHistory(chat['id']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          chat['title'],
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3A3A3A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Build Message Bubble

  Widget _buildMessageBubble(ChatMessage message) {
    final isBot = message.isBot;
    final isWelcomeMessage = message.isWelcome;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isBot && !isWelcomeMessage) ...[
                Image.asset('assets/images/chat_1.png', height: 24, width: 24),
                const SizedBox(width: 8),
              ],

              // Welcome message

              if (isWelcomeMessage)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildWelcomeText(message.text),
                  ),
                )
              else
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? Color(0xFFFFFAE6) : Color(0xFFFFF0B2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.text,
                      style: GoogleFonts.roboto(
                          color: Color(0xFF3A3A3A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
              if (!isBot) const SizedBox(width: 32),
            ],
          ),

          if (isBot && !isWelcomeMessage)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 38),
              child: Row(
                children: [
                  _actionButton(
                    icon: Icons.content_copy,
                    label: 'Copy',
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      SnackbarHelper.showSuccess(
                          'Message copied to clipboard',
                          title: 'Copied!'
                      );
                      }
                  ),
                  const SizedBox(width: 20),
                  _actionButton(
                    icon: Icons.thumb_up_outlined,
                    label: 'Like',
                    onTap: () => SnackbarHelper.showSuccess(
                        'We appreciate your feedback!',
                        title: 'Thank you!'
                    ),
                  ),
                  const SizedBox(width: 20),
                  _actionButton(
                    icon: Icons.thumb_down_outlined,
                    label: 'Dislike',
                    onTap: () => SnackbarHelper.showWarning(
                        'How can we improve? Let us know!',
                        title: 'Feedback received'
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Reusable action button

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Color(0xFF3A3A3A)),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: Color(0xFF3A3A3A)),
          ),
        ],
      ),
    );
  }

  // Relative Time Format

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  //  Build welcome text with different colors

  Widget _buildWelcomeText(String text) {
    final parts = text.split('\n');

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: parts[0],
            style: GoogleFonts.inter(
              color: Color(0xFFFECD08),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (parts.length > 1) ...[
            TextSpan(text: '\n'),
            TextSpan(
              text: parts[1],
              style: GoogleFonts.inter(
                color: Color(0xFFC4C7C5),
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}