import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/ui/community_chat/services/chat_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/api_base_url.dart';
import '../model/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController textController = TextEditingController();

  IO.Socket? socket;
  List<ChatModel> listMsg = [];
  ChatProvider() {
    connect();
  }
  bool isLoading = false;
  void connect() {
    socket = IO.io(kBaseUrl2, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    notifyListeners();
    socket!.connect();
    notifyListeners();
    socket!.onConnect((data) {
      print('connnected to frontend');
    });
    notifyListeners();
  }

  void getMessages() async {
    isLoading = true;
    notifyListeners();
    await ChatServices().getMessages().then((value) {
      if (value != null) {
        listMsg = value;
        notifyListeners();
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void sendMsg({required String message, required String groupId}) {
    final user = FirebaseAuth.instance.currentUser!;
    ChatModel chat = ChatModel(
        name: user.email!, text: message, groupId: groupId, email: user.email!);
    notifyListeners();
    listMsg.add(chat);
    notifyListeners();
    socket!.emit(
        "message", {"name": user.email, "text": message, "groupId": groupId});
    textController.clear();
  }
}