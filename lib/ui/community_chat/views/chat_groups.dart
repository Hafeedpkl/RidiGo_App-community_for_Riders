import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';
import 'package:ridigo/ui/community_chat/views/single_group.dart';

class ChatGroups extends StatelessWidget {
  const ChatGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Community Chat'),
      ),
      body: Consumer<GroupProvider>(builder: (context, value, _) {
        log('get', name: 'view');
        return value.isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: value.groupList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profile-image.png'),
                      radius: 25,
                    ),
                    title: Text(value.groupList[index].groupName),
                    // subtitle: const Text(
                    //   'admin : hello',
                    //   style: TextStyle(fontSize: 12, color: Colors.black54),
                    // ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(title: 'Group ${index + 1}'),
                        )),
                  );
                },
                // separatorBuilder: (context, index) => Divider(),
              );
      }),
    );
  }
}
