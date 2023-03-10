import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';

import '../../../common/api_base_url.dart';
import '../../../common/api_end_points.dart';
import '../../../core/services/services.dart';
import '../model/group_model.dart';

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
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundImage:
                                    getDp(value.foundedJoinList[index]),
                                radius: 25,
                              ),
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
                                  Services().joinGroup(
                                      groupId: value.foundedJoinList[index].id);
                                  value.getGroup();
                                  Navigator.pushReplacement(
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

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image != null) {
      return NetworkImage(kBaseUrl + ApiEndPoints.getImage + data.image!);
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }
}
