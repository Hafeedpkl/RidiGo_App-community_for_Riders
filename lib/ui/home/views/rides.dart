import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:ridigo/common/api_base_url.dart';
import 'package:ridigo/common/api_end_points.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';
import '../../bottom_navigation/bottom_navigation.dart';
import '../../bottom_navigation/provider/bottom_nav_provider.dart';
import '../../community_chat/model/group_model.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final postprovider = Provider.of<PostProvider>(context, listen: false);
      postprovider.ridesList.clear();
      postprovider.getPosts();
      log('get post called');
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: Consumer<PostProvider>(builder: (context, value, _) {
        if (value.isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: value.ridesList.length,
            itemBuilder: (context, index) {
              List regMembers = value.ridesList[index].regMembers;
              bool isRegistered = value.checkRegistered(regMembers: regMembers);
              value.openGroup(groupId: value.ridesList[index].group);
              final daysLeft =
                  getDaysleft(value.ridesList[index].expirationDate);
              final data = value.ridesList[index];
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
                                kBaseUrl + ApiEndPoints.getImage + data.image,
                                fit: BoxFit.contain,
                              ),
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
                                data.description,
                                trimLines: 2,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' Show more',
                                trimExpandedText: ' Show less',
                                moreStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                lessStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                                width: 200,
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
                                          return const SizedBox(
                                            child: CircularProgressIndicator(
                                                color: kBackgroundColor,
                                                strokeWidth: 2),
                                          );
                                        }
                                      })),
                              IconButton(
                                iconSize: 25,
                                onPressed: () {},
                                icon: Icon(
                                  index % 2 == 0
                                      ? Icons.bookmark_border
                                      : Icons.bookmark,
                                ),
                              ),
                              isRegistered
                                  ? ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.blueAccent)),
                                      onPressed: () {
                                        AllServices().registerUserPost(
                                            postId: value.ridesList[index].id,
                                            groupId:
                                                value.ridesList[index].group);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavScreen(),
                                            ));
                                        Provider.of<BottomNavProvider>(context,
                                                listen: false)
                                            .bottomChanger(2);
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
                                              MaterialStatePropertyAll(5),
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
