import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/community_chat/foundation/own_message_card.dart';
import 'package:ridigo/ui/community_chat/foundation/reply_card.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.data});
  final Group data;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  bool? sendButton;
  List<ChatModel> listMsg = [];
  IO.Socket? socket;
  @override
  void initState() {
    connnect();
    super.initState();
  }

  void connnect() {
    socket = IO.io(kBaseUrl2, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((data) {
      print('connnected to frontend');
    });
  }

  void sendMsg(String message) {
    final user = FirebaseAuth.instance.currentUser!;
    ChatModel chat = ChatModel(
        name: user.displayName!,
        text: message,
        groupId: widget.data.id,
        email: user.email!);
    setState(() {
      listMsg.add(chat);
    });
    socket!.emit("message",
        {"name": user.displayName, "text": message, "groupId": widget.data.id});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          'assets/images/chat_background.png',
          height: size.height,
          width: size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            title: InkWell(
              onTap: () {},
              child: Text(
                widget.data.groupName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: kBackgroundColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                child: ListView(
                  children: [
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                    OwnMessageCard(),
                    ReplyCard(),
                  ],
                ),
              )),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: size.width - 70,
                        child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(
                                left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: TextFormField(
                              controller: textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    sendButton = true;
                                  });
                                } else {
                                  setState(() {
                                    sendButton = false;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type here....',
                                contentPadding: EdgeInsets.all(15),
                              ),
                            ))),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, right: 5, left: 2),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: kBackgroundColor,
                        child: IconButton(
                          onPressed: () {
                            if (sendButton == true) {
                              sendMsg(textController.text);
                              textController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
