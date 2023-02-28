import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';
import 'package:ridigo/ui/community_chat/services/group_services.dart';

class JoinGroup extends StatelessWidget {
  const JoinGroup({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupProvider>(context, listen: false).getJoinList();
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
      ),
      body: Consumer<GroupProvider>(builder: (context, value, _) {
        log('get', name: 'view');
        return value.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        suffixIcon: Icon(Icons.close),
                        onChanged: (enteredKeyword) {
                          value.joinGroupRunFilter(enteredKeyword);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.foundedJoinList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile-image.png'),
                              radius: 30,
                            ),
                            title: Text(
                              value.foundedJoinList[index].groupName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              ' ',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  GroupService().joinGroup(
                                      groupId: value.foundedJoinList[index].id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BottomNavScreen(),
                                      ));
                                },
                                child: const Text('join')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
