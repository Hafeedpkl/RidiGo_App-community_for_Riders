import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/community_chat/foundation/own_message_card.dart';
import 'package:ridigo/ui/community_chat/foundation/reply_card.dart';
import 'package:ridigo/ui/community_chat/model/chat_model.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/community_chat/provider/chat_provider.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/api_base_url.dart';
import '../../../common/api_end_points.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.data});
  final Group data;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> listMsg = [];
  final _focusNode = FocusNode();
  IO.Socket? socket;
  late Timer _timer;
  StreamController<List<ChatModel>> controller =
      StreamController<List<ChatModel>>.broadcast();
  @override
  void didChangeDependencies() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (context.mounted) {
        Provider.of<ChatProvider>(context, listen: false).getMessages();
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChatProvider>(context, listen: false).groupId =
          widget.data.id;
      // .setGroupId(groupId1: widget.data.id);

      Provider.of<ChatProvider>(context, listen: false).connect();

      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });

    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        _focusNode.unfocus();
        return true;
      },
      child: Stack(
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
              leadingWidth: 70,
              leading: InkWell(
                onTap: () {
                  _focusNode.unfocus();
                  _timer.cancel();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 19,
                      backgroundImage: getDp(widget.data),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text(
                      widget.data.groupName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // Text(' '),
                  ],
                ),
              ),
              backgroundColor: kBackgroundColor,
              // actions: [
              //   PopupMenuButton(
              //     itemBuilder: (context) => [
              //       const PopupMenuItem(
              //         child: Text('Add Event'),
              //       ),
              //       const PopupMenuItem(
              //         child: Text('Add Rides'),
              //       )
              //     ],
              //   )
              // ],
            ),
            body: Consumer<ChatProvider>(builder: (context, value, _) {
              controller = value.listMsg;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
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
                                      name: data[index].name,
                                      time: data[index].time,
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
                          })),
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
                                  focusNode: _focusNode,
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
                          padding: const EdgeInsets.only(
                              bottom: 8, right: 5, left: 2),
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
      ),
    );
  }

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image != null) {
      return NetworkImage(kBaseUrl + ApiEndPoints.getImage + data.image!);
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }

  // @override
  // void deactivate() {
  //   _timer.cancel();
  //   FocusScope.of(context).unfocus();
  //   super.deactivate();
  // }
  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    _timer.cancel();
    // controller.close();
    log('Disposed');
    super.dispose();
  }
}
