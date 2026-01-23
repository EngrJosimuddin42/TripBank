import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/api_constants.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final bool isWelcome;

  ChatMessage({
    required this.text,
    required this.isBot,
    DateTime? timestamp,
    this.isWelcome = false,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <ChatMessage>[].obs;

  // API Service & Auth Service

  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();

  // Chat History

  final chatHistory = <Map<String, dynamic>>[].obs;
  final currentChatId = ''.obs;

  // Loading states

  final isLoadingResponse = false.obs;
  final isLoadingHistory = false.obs;

  // Speech to text

  late stt.SpeechToText speech;
  final isListening = false.obs;
  final speechEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _showWelcomeMessage();
    _loadDemoChatHistory();
    _loadChatHistory();

    _createNewChatInBackground();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    speech.stop();
    super.onClose();
  }

  void _showWelcomeMessage() {
    messages.clear();
    messageController.clear();
    messages.add(ChatMessage(
      text: 'Hello, ${_getUserName()}\nHow can I help you today?',
      isBot: true,
      isWelcome: true,
    ));
  }


  Future<void> _createNewChatInBackground() async {
    try {
      final response = await _apiService.post(ApiConstants.chatNew, {});

      if (response['success'] == true && response['data'] != null) {
        currentChatId.value = response['data']['id'].toString();
      } else {
        currentChatId.value = DateTime.now().millisecondsSinceEpoch.toString();
      }
    } catch (e) {
      print('Error creating new chat: $e');
      currentChatId.value = DateTime.now().millisecondsSinceEpoch.toString();
    }
  }


  Future<void> _loadChatHistory() async {
    try {
      isLoadingHistory.value = true;

      final response = await _apiService.get(ApiConstants.chatHistory);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> chats = response['data'];


        //  demo

        if (chats.isNotEmpty) {
          chatHistory.assignAll(chats.map((chat) => {
            'id': chat['id'].toString(),
            'title': chat['title'] ?? 'Untitled Chat',
            'timestamp': DateTime.parse(
                chat['created_at'] ?? DateTime.now().toIso8601String()),
            'preview': chat['last_message'] ?? '',
          }).toList());
        } else {
          chatHistory.clear();
        }
      }
    } catch (e) {
      print('Error loading chat history: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  //  Fallback demo data (Instant loading)

  void _loadDemoChatHistory() {
    chatHistory.assignAll([
      {
        'id': '1',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        'preview': 'I need help planning an event...',
      },
      {
        'id': '2',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(days: 1)),
        'preview': 'What music would you recommend...',
      },
      {
        'id': '3',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(days: 2)),
        'preview': 'Can you help with event planning...',
      },
      {
        'id': '4',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(days: 3)),
        'preview': 'I\'m planning a birthday party...',
      },
      {
        'id': '5',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(days: 5)),
        'preview': 'Need suggestions for wedding...',
      },
      {
        'id': '6',
        'title': 'Event detail with music',
        'timestamp': DateTime.now().subtract(Duration(days: 7)),
        'preview': 'Corporate event planning help...',
      },
    ]);
  }

  //  Start new chat (with API)

  Future<void> startNewChat() async {
    _showWelcomeMessage();
    await _createNewChatInBackground();
  }

  //  Load specific chat from history (with API)

  Future<void> loadChatHistory(String chatId) async {
    try {
      currentChatId.value = chatId;
      messages.clear();

      // Call API to get chat messages

      final response =
      await _apiService.get('${ApiConstants.chatById}/$chatId');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> chatMessages = response['data']['messages'] ?? [];

        messages.addAll(chatMessages.map((msg) => ChatMessage(
          text: msg['message'] ?? '',
          isBot: msg['is_bot'] ?? false,
          timestamp: DateTime.parse(
              msg['created_at'] ?? DateTime.now().toIso8601String()),
        )).toList());
      }

      Get.back();
    } catch (e) {
      print('Error loading chat: $e');
      Get.snackbar(
        'Error',
        'Failed to load chat history',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  // Initialize speech to text

  Future<void> _initSpeech() async {
    speech = stt.SpeechToText();

    try {
      var status = await Permission.microphone.request();

      if (status.isGranted) {
        speechEnabled.value = await speech.initialize(
          onError: (error) {
            print('Speech recognition error: $error');
            isListening.value = false;
          },
          onStatus: (status) {
            print('Speech recognition status: $status');
            if (status == 'done' || status == 'notListening') {
              isListening.value = false;
            }
          },
        );
      } else {
        Get.snackbar(
          'Permission Required',
          'Microphone permission is needed for voice input',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Speech init error: $e');
      speechEnabled.value = false;
    }
  }

  // Toggle listening

  Future<void> toggleListening() async {
    if (!speechEnabled.value) {
      Get.snackbar(
        'Voice Input Unavailable',
        'Please enable microphone permission in settings',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (isListening.value) {
      await speech.stop();
      isListening.value = false;
    } else {
      isListening.value = true;
      messageController.clear();

      await speech.listen(
        onResult: (result) {
          messageController.text = result.recognizedWords;

          if (result.finalResult) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
              }
              isListening.value = false;
            });
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),

          listenOptions: stt.SpeechListenOptions(
              partialResults: true,
        listenMode: stt.ListenMode.confirmation)
      );
    }
  }

  //  Get user name from AuthService

  String _getUserName() {
    final user = _authService.currentUser.value;

    if (user != null) {
      if (user.name != null && user.name!.isNotEmpty) {
        return user.name!;
      } else if (user.email != null && user.email!.isNotEmpty) {
        return user.email!.split('@')[0];
      }
    }

    return 'User';
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Stop listening if active

    if (isListening.value) {
      speech.stop();
      isListening.value = false;
    }

    // Add user message

    messages.add(ChatMessage(
      text: text,
      isBot: false,
    ));

    messageController.clear();
    _scrollToBottom();

    // Get bot response from API

    _generateBotResponse(text);
  }

  // Generate bot response using API

  Future<void> _generateBotResponse(String userMessage) async {
    isLoadingResponse.value = true;

    // Show typing indicator

    messages.add(ChatMessage(
      text: 'Typing...',
      isBot: true,
    ));
    _scrollToBottom();

    try {

      // Call API

      final response = await _apiService.post(
        ApiConstants.chatSendMessage,
        {
          'chat_id': currentChatId.value,
          'message': userMessage,
        },
      );

      // Remove typing indicator

      messages.removeLast();

      // Add bot response

      if (response['success'] == true && response['data'] != null) {
        messages.add(ChatMessage(
          text: response['data']['response'] ?? 'No response',
          isBot: true,
        ));
      } else {
        messages.add(ChatMessage(
          text: 'Sorry, I couldn\'t process your request.',
          isBot: true,
        ));
      }
    } on ApiException catch (e) {
      messages.removeLast();

      // Show error message

      messages.add(ChatMessage(
        text: 'Sorry, something went wrong. Please try again.',
        isBot: true,
      ));

      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      messages.removeLast();

      messages.add(ChatMessage(
        text: 'Network error. Please check your connection.',
        isBot: true,
      ));

      print('Chatbot error: $e');
    } finally {
      isLoadingResponse.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}