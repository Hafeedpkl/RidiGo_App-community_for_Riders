import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/bottom_navigation/provider/bottom_nav_provider.dart';
import 'package:ridigo/ui/community_chat/provider/group_provider.dart';
import 'package:ridigo/ui/community_chat/services/group_services.dart';
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
                  child: Text('Create Group'),
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
                addGroup(context: context);
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

  void addGroup({context}) {
    var controller =
        Provider.of<GroupProvider>(context, listen: false).groupNameController;

    final formkey1 = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create Group'),
            content: Form(
              key: formkey1,
              child: TextFormField(
                controller: controller,
                validator: (value) =>
                    value != null && value.length < 3 ? 'Enter Name' : null,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  
                    labelText: 'Group name',
                    labelStyle: GoogleFonts.poppins(color: Colors.black),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2,
                        ))),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel',
                    style: GoogleFonts.poppins(color: Colors.black),
                  )),
              TextButton(
                child: Text('create', style: GoogleFonts.poppins()),
                onPressed: () async {
                  final isvalid = formkey1.currentState!.validate();
                  if (!isvalid) return;
                  await GroupService()
                      .createGroup(roomName: controller.text.trim());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                  var snackBar = SnackBar(
                      content:
                          Text('Group ${controller.text.trim()} is created'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  controller.clear();
                },
              )
            ],
          );
        });
  }
}
