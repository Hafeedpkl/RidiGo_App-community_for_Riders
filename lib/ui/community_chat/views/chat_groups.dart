import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';
import 'package:ridigo/ui/community_chat/views/join_group.dart';
import 'package:ridigo/ui/community_chat/views/single_group.dart';

class ChatGroups extends StatelessWidget {
  const ChatGroups({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupProvider>(context, listen: false).getJoinedGroup();
    });
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Community Chat'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text('Add Group'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Join Group'),
                  value: 2,
                )
              ];
            },
            onSelected: (value) {
              if (value == 1) {
                log('add Group button Pressed');
              } else if (value == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinGroup(),
                    ));
              }
            },
          )
        ],
      ),
      body: Consumer<GroupProvider>(builder: (context, value, _) {
        log('get', name: 'view');
        return value.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: value.indvidualGroupList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profile-image.png'),
                      radius: 25,
                    ),
                    title: Text(
                      value.indvidualGroupList[index].groupName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      ' ',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              title: value.indvidualGroupList[index].groupName),
                        )),
                  );
                },
              );
      }),
    );
  }
}
