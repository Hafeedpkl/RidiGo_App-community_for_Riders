import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/bottom_navigation/provider/bottom_nav_provider.dart';
import 'package:ridigo/ui/community_chat/model/group_model.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';
import 'package:shimmer/shimmer.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: Consumer<PostProvider>(builder: (context, value, _) {
        if (value.isLoading == true) {
          return Shimmer.fromColors(
              period: Duration(seconds: 2),
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.white,
              child: Container(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              color: Colors.amber,
                              width: double.infinity,
                              height: size.height * 0.3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 25,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ));
        } else {
          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.eventList.length,
              itemBuilder: (context, index) {
                List regMembers = value.eventList[index].regMembers;
                bool isRegistered =
                    value.checkRegistered(regMembers: regMembers);

                // print(value.eventList[index].group);
                value.openGroup(groupId: value.eventList[index].group);
                final daysLeft =
                    getDaysleft(value.eventList[index].expirationDate);
                final data = value.eventList[index];
                if (!daysLeft.isNegative) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      // height: size.width * 0.8,
                      child: Column(
                        children: [
                          SizedBox(
                            child: Stack(
                              children: [
                                Image.network(kBaseUrl +
                                    ApiEndPoints.getImage +
                                    data.image),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black26,
                                      ),
                                      height: 30,
                                      width: 80,
                                      child: daysLeft.isNegative
                                          ? Center(
                                              child: Text('Expired',
                                                  style: GoogleFonts.sarala(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(daysLeft.toString(),
                                                    style: GoogleFonts.sarala(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Text(
                                                  ' days left',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.width * 0.08,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      data.title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                ReadMoreText(
                                  textAlign: TextAlign.left,
                                  data.description,
                                  trimLines: 2,
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' Show more',
                                  trimExpandedText: ' Show less',
                                  moreStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.width * 0.01,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: FutureBuilder(
                                        future: value.futureGroupData,
                                        builder: (context, snapshot) {
                                          final futureData = snapshot.data;
                                          if (snapshot.hasData) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage:
                                                      getDp(futureData),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    futureData!.groupName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavScreen(),
                                                ));
                                            return const SizedBox();
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor:
                                                  Colors.grey.withOpacity(0.5),
                                              highlightColor: Colors.white,
                                              child: Row(
                                                children: [
                                                  const Expanded(
                                                    flex: 1,
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        height: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                                  Expanded(
                                      child: value.checkWishList(
                                          postId: value.eventList[index].id)),
                                  Expanded(
                                      flex: 2,
                                      child: isRegistered == true
                                          ? ElevatedButton(
                                              style: const ButtonStyle(
                                                  elevation:
                                                      MaterialStatePropertyAll(
                                                          5),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white)),
                                              onPressed: () {},
                                              child: const Text(
                                                'Registered',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ))
                                          : ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.blueAccent)),
                                              onPressed: () {
                                                AllServices().registerUserPost(
                                                    postId: value
                                                        .eventList[index].id,
                                                    groupId: value
                                                        .eventList[index]
                                                        .group);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomNavScreen(),
                                                    ));
                                                Provider.of<BottomNavProvider>(
                                                        context,
                                                        listen: false)
                                                    .bottomChanger(2);
                                                value.eventList.clear();
                                                value.ridesList.clear();
                                              },
                                              child: const Text(
                                                'register',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )))
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          );
        }
      }),
    ));
  }

  int getDaysleft(DateTime dateTime) {
    DateTime currentDate = DateTime.now();
    Duration difference = dateTime.difference(currentDate);
    int daysLeft = difference.inSeconds ~/ 86400;
    return daysLeft;
  }

  ImageProvider<Object> getDp(Group? data) {
    if (data!.image!.isNotEmpty) {
      return NetworkImage(kBaseUrl + ApiEndPoints.getImage + data.image!);
    }
    return Image.asset(
      'assets/images/profile-image.png',
    ).image;
  }
}
