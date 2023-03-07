import 'package:flutter/material.dart';
import 'package:ridigo/ui/community_chat/views/widgets/group_image_viewer.dart';

import '../../../common/api_base_url.dart';
import '../../../common/api_end_points.dart';
import '../model/group_model.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key, required this.groupData});
  final Group? groupData;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      builder: (context) =>
                          GroupImageViewer(data: groupData),
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
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.width * 0.02,
            ),
            postCard(
                list: groupData!.events,
                size: size,
                name: "Events",
                color: Colors.white),
            const SizedBox(
              height: 10,
            ),
            postCard(
                name: 'Rides',
                list: groupData!.rides,
                color: Colors.white,
                size: size),
            const SizedBox(
              height: 10,
            ),
            Container(
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: groupData!.members.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            groupData!.members[index],
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

  Card postCard({String? name, List<dynamic>? list, Color? color, Size? size}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(),
      color: color,
      child: Container(
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
                Text('more'),
              ],
            ),
            Container(
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
                      child: Image(
                        image: getDp(groupData),
                        fit: BoxFit.fitHeight,
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
