
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Community',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 1,
                  child: Text('Create Group'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Join Group'),
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
                      builder: (context) => const JoinGroup(),
                    ));
              }
            },
          )
        ],
      ),
      body: Consumer<GroupProvider>(builder: (context, value, _) {
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
                          builder: (context) =>
                              ChatScreen(data: value.indvidualGroupList[index]),
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
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                  var snackBar = SnackBar(
                      content:
                          Text('Group ${controller.text.trim()} is created'));
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  controller.clear();
                },
              )
            ],
          );
        });
  }
}
