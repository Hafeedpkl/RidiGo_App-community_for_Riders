import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:ridigo/ui/community_chat/views/group_info_screen.dart';
import 'package:ridigo/ui/home/views/add_post_screen.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

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
      // if (context.mounted) {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
      // }
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
    final user = FirebaseAuth.instance.currentUser;
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
              onTap: () {
                // _timer.cancel();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupInfoScreen(groupData: widget.data),
                    ));
              },
              child: SizedBox(
                height: size.height * 0.05,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ),
            backgroundColor: kBackgroundColor,
            actions: [
              widget.data.admin == user!.email
                  ? IconButton(
                      onPressed: () {
                        _timer.cancel();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddPostScreen(groupData: widget.data),
                            ));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                  : const SizedBox()
            ],
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
                            final data = snapshot.data!.reversed.toList();
                            if (data.length > 7) {
                              return StickyGroupedListView<ChatModel, DateTime>(
                                order: StickyGroupedListOrder.DESC,
                                floatingHeader: true,
                                reverse: true,
                                elements: data.reversed.toList(),
                                groupBy: (ChatModel element) => DateTime(
                                    element.time!.year,
                                    element.time!.month,
                                    element.time!.day),
                                groupSeparatorBuilder: _getGroupSeparator,
                                indexedItemBuilder: (context, element, index) {
                                  if (data[index].name == value.user.email) {
                                    return OwnMessageCard(
                                      text: data[index].text,
                                      name: data[index].name,
                                      time: data[index].time,
                                      date: false,
                                    );
                                  } else {
                                    log('${data[index].email} ${value.user.email}');
                                    return ReplyCard(
                                      name: data[index].name,
                                      text: data[index].text,
                                      time: data[index].time,
                                      date: false,
                                    );
                                  }
                                },
                              );
                            } else {
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
                                      date: true,
                                    );
                                  } else {
                                    log('${data[index].email} ${value.user.email}');
                                    return ReplyCard(
                                      name: data[index].name,
                                      text: data[index].text,
                                      time: data[index].time,
                                      date: true,
                                    );
                                  }
                                },
                              );
                            }
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

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image != null) {
      return NetworkImage(kBaseUrl + ApiEndPoints.getImage + data.image!);
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }

  @override
  void deactivate() {
    FocusScope.of(context).unfocus();
    _timer.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    // FocusScope.of(context).unfocus();
    _timer.cancel();
    // controller.close();
    log('Disposed');
    super.dispose();
  }
}

Widget _getGroupSeparator(ChatModel element) {
  String? month;
  switch (element.time!.month) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'March';
      break;
    case 4:
      month = 'April';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'June';
      break;
    case 7:
      month = 'July';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sept';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    case 12:
      month = 'Dec';
      break;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 35,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(
              color: Colors.blueAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Text(
            '${element.time!.day}, $month, ${element.time!.year}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ),
  );
}
