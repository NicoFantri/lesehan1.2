import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isSentByUser;
  String? status;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    this.isSentByUser = true,
    this.status,
  });
}

class ChatController extends GetxController {
  final RxList<Message> _messages = <Message>[].obs;
  final TextEditingController messageController = TextEditingController();

  List<Message> get messages => _messages;

  @override
  void onInit() {
    super.onInit();
    // Simulated initial messages
    _messages.addAll([
      Message(
        id: '1',
        content: 'Halo, pesanan sedang dalam perjalanan.',
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        isSentByUser: false,
        status: 'Sent',
      ),
      Message(
        id: '2',
        content: 'Terima kasih, kapan perkiraan sampai?',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isSentByUser: true,
        status: 'Delivered',
      ),
    ]);
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageController.text.trim(),
      timestamp: DateTime.now(),
      isSentByUser: true,
      status: 'Sent',
    );

    _messages.insert(0, newMessage);
    messageController.clear();

    // Simulate a response (in a real app, this would be from a backend)
    Future.delayed(Duration(seconds: 2), () {
      final response = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Pesanan akan sampai dalam 20 menit.',
        timestamp: DateTime.now(),
        isSentByUser: false,
        status: 'Delivered',
      );
      _messages.insert(0, response);
    });
  }

  void updateMessage(String id, String newContent) {
    final index = _messages.indexWhere((msg) => msg.id == id);
    if (index != -1) {
      _messages[index] = Message(
        id: id,
        content: newContent,
        timestamp: _messages[index].timestamp,
        isSentByUser: _messages[index].isSentByUser,
        status: 'Edited',
      );
    }
  }

  void deleteMessage(String id) {
    _messages.removeWhere((msg) => msg.id == id);
  }

  void sendAttachment() {
    // TODO: Implement file/image attachment functionality
    Get.snackbar(
      'Lampiran',
      'Fitur lampiran akan segera tersedia',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}