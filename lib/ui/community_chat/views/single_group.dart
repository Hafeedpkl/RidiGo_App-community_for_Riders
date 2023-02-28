import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/community_chat/foundation/own_message_card.dart';
import 'package:ridigo/ui/community_chat/foundation/reply_card.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/community_chat/provider/chat_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.data});
  final Group data;

  List<ChatModel> listMsg = [];

  IO.Socket? socket;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).connect();
      Provider.of<ChatProvider>(context, listen: false).getMessages();
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
                data.groupName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: kBackgroundColor,
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Add Event'),
                  ),
                  PopupMenuItem(
                    child: Text('Add Event'),
                  )
                ],
              )
            ],
          ),
          body: Consumer<ChatProvider>(builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  child: ListView.builder(
                    itemCount: value.listMsg.length,
                    itemBuilder: (context, index) {
                      // value.listMsg[index].name;
                      if (value.listMsg[index].email == value.user.email) {
                        return OwnMessageCard(
                          text: value.listMsg[index].text,
                        );
                      } else {
                        log('${value.listMsg[index].email} ${value.user.email}');
                        return ReplyCard(
                          name: value.listMsg[index].name,
                          text: value.listMsg[index].text,
                          time: value.listMsg[index].time,
                        );
                      }
                    },
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
                                    groupId: data.id);
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
}
