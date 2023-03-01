import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/community_chat/foundation/own_message_card.dart';
import 'package:ridigo/ui/community_chat/foundation/reply_card.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/community_chat/provider/chat_provider.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.data});
  final Group data;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> listMsg = [];

  IO.Socket? socket;
  late Timer _timer;
  StreamController<List<ChatModel>> controller =
      StreamController<List<ChatModel>>.broadcast();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false)
          .setGroupId(groupId1: widget.data.id);
      Provider.of<ChatProvider>(context, listen: false).connect();
      _timer = Timer.periodic(const Duration(seconds: 2), (_) {
        Provider.of<ChatProvider>(context, listen: false).getMessages();
      });
    });

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
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text('Add Event'),
                  ),
                  const PopupMenuItem(
                    child: Text('Add Rides'),
                  )
                ],
              )
            ],
          ),
          body: Consumer<ChatProvider>(builder: (context, value, _) {
            controller = value.listMsg;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  child: StreamBuilder<List<ChatModel>>(
                      stream: controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data1 = snapshot.data!;
                          final data = data1.reversed.toList();
                          return ListView.builder(
                            reverse: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              // value.listMsg[index].name;
                              if (data[index].name == value.user.email) {
                                return OwnMessageCard(
                                  text: data[index].text,
                                );
                              } else {
                                log('${data[index].email} ${value.user.email}');
                                return ReplyCard(
                                  name: data[index].name,
                                  text: data[index].text,
                                  time: data[index].time,
                                );
                              }
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Lottie.asset(
                                  'assets/lottie/76699-error.json'));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                )),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: size.width - 70,
                          child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextFormField(
                                controller: value.textController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
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
                              if (value.textController.text.isNotEmpty) {
                                value.sendMsg(
                                    message: value.textController.text,
                                    groupId: widget.data.id);
                              }
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    controller.close();
    log('Disposed');
    super.dispose();
  }
}
