import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/profile/provider/user_data_provider.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          actions: [
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Sign Out'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Settings'),
                  value: 2,
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('signout?'),
                      content: const Text('Are you want to Sign Out?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
        body: Column(
          children: [
            profileSection(size, context),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                      ),
                      height: size.height * 0.1,
                    )
                  ],
                ),
              ),
            ))
          ],
        ));
  }

  Stack profileSection(Size size, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.width * 0.35,
        ),
        Container(
          color: kBackgroundColor,
          height: size.width * 0.17,
        ),
        Row(
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundColor: kBackgroundColor,
                radius: size.width * 0.15,
                child: CircleAvatar(
                  radius: size.width * 0.14,
                  backgroundImage:
                      const AssetImage('assets/images/profile-avatar.jpg'),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: SizedBox(
                  height: size.width * 0.35,
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      Provider.of<UserDataProvider>(context)
                                              .userName ??
                                          'User Name',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${user.email}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          eventsRidesAttended(
                              count: 2, text: 'Events attended'),
                          eventsRidesAttended(count: 5, text: 'Rides attended')
                        ],
                      )),
                    ],
                  ),
                ))
          ],
        )
      ],
    );
  }

  Expanded eventsRidesAttended({required int count, required String text}) {
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 7, left: 7, top: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 3, color: Colors.blue),
            color: Colors.white),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        end: BorderSide(color: Colors.blue, width: 2))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                    child: Text(
                  count.toString(),
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                )),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
