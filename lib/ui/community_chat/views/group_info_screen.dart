import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/community_chat/views/widgets/group_image_viewer.dart';

import '../../../common/api_base_url.dart';
import '../../../common/api_end_points.dart';
import '../model/group_model.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key, required this.groupData});
  final Group? groupData;
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final memberList = groupData!.members.toList();
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: kBackgroundColor,
        //   leading: IconButton(
        //     icon: (const Icon(Icons.arrow_back)),
        //     color: Colors.white,
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupImageViewer(data: groupData),
                    ));
              },
              child: SizedBox(
                height: size.height * 0.3,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image(
                        image: getDp(groupData),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: (const Icon(Icons.arrow_back)),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupData!.groupName,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Created by ${groupData!.admin} ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: size.width * 0.06,
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              if (groupData!.admin != user!.email) {
                                Fluttertoast.showToast(
                                    msg: "Only Admin can edit group name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                controller = TextEditingController(
                                    text: groupData!.groupName);
                                editGrpName(controller, context);
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.width * 0.02,
            ),
            // postCard(
            //     list: groupData!.events,
            //     size: size,
            //     name: "Events",
            //     color: Colors.white),
            // const SizedBox(
            //   height: 10,
            // ),
            // postCard(
            //     name: 'Rides',
            //     list: groupData!.rides,
            //     color: Colors.white,
            //     size: size),
            // const SizedBox(
            //   height: 10,
            // ),
            SizedBox(
              width: double.infinity,
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Members',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: memberList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            memberList[index],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future editGrpName(TextEditingController controller, context) async {
    final formkey1 = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change name'),
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
                child: Text('change', style: GoogleFonts.poppins()),
                onPressed: () {
                  if (!formkey1.currentState!.validate()) return;
                  changeGroupName(controller.text.trim());
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                },
              )
            ],
          );
        });
  }

  Future<void> changeGroupName(text) async {
    var dio = Dio();
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.editGroupName,
          data: {"id": groupData!.id, "grpName": text},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'changeGroupName');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Card postCard({String? name, List<dynamic>? list, Color? color, Size? size}) {
    return Card(
      elevation: 3,
      shape: const RoundedRectangleBorder(),
      color: color,
      child: SizedBox(
        height: size!.height * 0.15,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name!,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Text('more'),
              ],
            ),
            SizedBox(
              height: size.height * 0.12,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.22,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: getDp(groupData),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image != null) {
      return NetworkImage(
        kBaseUrl + ApiEndPoints.getImage + data.image!,
      );
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }
}
