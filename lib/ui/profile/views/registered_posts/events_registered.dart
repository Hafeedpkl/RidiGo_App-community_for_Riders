import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/api_base_url.dart';
import '../../../../common/api_end_points.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/model/user.dart';
import '../../../../core/services/all_services.dart';
import '../../../bottom_navigation/bottom_navigation.dart';
import '../../../bottom_navigation/provider/bottom_nav_provider.dart';
import '../../../community_chat/model/group_model.dart';
import '../../../home/provider/post_provider.dart';

// ignore: must_be_immutable
class EventRegistered extends StatelessWidget {
  const EventRegistered({super.key});
  // List<dynamic> eventsRegistered;
  @override
  Widget build(BuildContext context) {
    // log(wishList.toString());`
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<PostProvider>(context, listen: false);
      provider.registeredEvents.clear();
      provider.registeredRides.clear();

      provider.getJoinedPosts();
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text(
          'Event Registered',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Consumer<PostProvider>(builder: (context, value, _) {
          if (value.isLoading == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return value.registeredEvents != null
                ? ListView.builder(
                    itemCount: value.registeredEvents.length,
                    itemBuilder: (context, index) {
                      List regMembers =
                          value.registeredEvents[index].regMembers;
                      bool isRegistered =
                          value.checkRegistered(regMembers: regMembers);
                      value.openGroup(
                          groupId: value.registeredEvents[index].group);
                      final daysLeft = getDaysleft(
                          value.registeredEvents[index].expirationDate);
                      final data = value.registeredEvents[index];

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
                                      Image.network(
                                        kBaseUrl +
                                            ApiEndPoints.getImage +
                                            data.image,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.black26,
                                            ),
                                            height: 30,
                                            width: 80,
                                            child: daysLeft.isNegative
                                                ? Center(
                                                    child: Text('Expired',
                                                        style:
                                                            GoogleFonts.sarala(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(daysLeft.toString(),
                                                          style: GoogleFonts
                                                              .sarala(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      const Text(
                                                        ' days left',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: size.width * 0.08,
                                        width: double.infinity,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            data.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      ReadMoreText(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: FutureBuilder(
                                              future: value.futureGroupData,
                                              builder: (context, snapshot) {
                                                final futureData =
                                                    snapshot.data;
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
                                                        width:
                                                            size.width * 0.01,
                                                      ),
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          futureData!.groupName,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                } else if (snapshot.hasError) {
                                                  Navigator.pop(context);
                                                  return const SizedBox();
                                                } else {
                                                  return const SizedBox(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                kBackgroundColor,
                                                            strokeWidth: 2),
                                                  );
                                                }
                                              })),
                                      checkWishList(
                                          postId:
                                              value.registeredEvents[index].id),
                                      isRegistered == false
                                          ? ElevatedButton(
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
                                                value.eventList.clear();
                                              },
                                              child: const Text(
                                                'Join',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ))
                                          : ElevatedButton(
                                              style: const ButtonStyle(
                                                  elevation:
                                                      MaterialStatePropertyAll(
                                                          5),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white)),
                                              onPressed: () {},
                                              child: const Text(
                                                'Joined',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return null;
                    },
                  )
                : SizedBox();
          }
        }),
      ),
    );
  }

  checkWishList({required String postId}) {
    bool? boolcheck;
    final userDataController = StreamController<UserModel?>();

    AllServices().getUser().then((userData) {
      userDataController.add(userData);
    });

    return StreamBuilder<UserModel?>(
      stream: userDataController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          int count = 0;
          for (var element in data.wishList) {
            if (element == postId) {
              count++;
            }
          }
          if (count != 0) {
            boolcheck = true;
          } else {
            boolcheck = false;
          }
        }
        return boolcheck == false
            ? IconButton(
                onPressed: () {
                  AllServices().addToWishList(postId: postId);
                },
                icon: const Icon(Icons.bookmark_outline),
                iconSize: 25,
              )
            : IconButton(
                onPressed: () {
                  AllServices().removeFromWishList(postId: postId);
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           SavedPostsScreen(wishList: wishList),
                  //     ));
                },
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.blueAccent,
                ),
                iconSize: 25);
      },
    );
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
