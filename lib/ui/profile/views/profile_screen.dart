import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/core/model/user.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/profile/views/profile_image_screen.dart';
import 'package:ridigo/ui/profile/provider/user_provider.dart';
import 'package:ridigo/ui/settings/settings_screen.dart';

import '../../../common/api_base_url.dart';
import '../../../common/api_end_points.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getUser();
    });
    Future<void> refresh() async {
      await Future.delayed(Duration(seconds: 1));
      Provider.of<UserProvider>(context, listen: false).getUser();
    }

    // Provider.of<UserProvider>(context, listen: false).getUser();

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kBackgroundColor,
          actions: [
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sign Out'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Settings'),
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
                } else if (value == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ));
                }
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Consumer<UserProvider>(builder: (context, value, _) {
            Provider.of<UserProvider>(context, listen: false).getUser();

            return FutureBuilder(
                future: value.futureUserData,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        profileSection(size, context, data),
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  child: InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      height: size.height * 0.06,
                                      width: double.infinity,
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.bookmark_border_outlined,
                                            size: 25,
                                          ),
                                          Text(
                                            'Saved Events & Rides',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        color: Colors.lightBlueAccent,
                                        elevation: 4,
                                        child: InkWell(
                                          onTap: () {},
                                          child: SizedBox(
                                            height: size.height * 0.06,
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.event_available,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.02),
                                                const Text(
                                                  'Events',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        color: Colors.deepPurpleAccent,
                                        elevation: 4,
                                        child: InkWell(
                                          onTap: () {},
                                          child: SizedBox(
                                            height: size.height * 0.06,
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.two_wheeler_rounded,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.02),
                                                const Text(
                                                  'Rides',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Lottie.asset('assets/lottie/76699-error.json',
                          height: 20),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          }),
        ));
  }

  Stack profileSection(Size size, BuildContext context, UserModel? data) {
    final user = FirebaseAuth.instance.currentUser!;

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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileImageScreen(
                              image: data!.profileImage != null
                                  ? NetworkImage(kBaseUrl +
                                      ApiEndPoints.getImage +
                                      data.profileImage!)
                                  : const AssetImage(
                                      'assets/images/profile-avatar.jpg')),
                        ));
                  },
                  child: CircleAvatar(
                      radius: size.width * 0.14, backgroundImage: getDp(data)),
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
                                      user.displayName != null
                                          ? user.displayName!
                                          : 'user',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        editName(context);
                                      },
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

  ImageProvider<Object> getDp(UserModel? data) {
    if (data!.profileImage != null) {
      return NetworkImage(
          kBaseUrl + ApiEndPoints.getImage + data.profileImage!);
    }
    return Image.asset(
      'assets/images/profile-avatar.jpg',
    ).image;
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

  void editName(context) {
    final formkey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;
    nameController = TextEditingController(text: user!.displayName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change name'),
          content: Form(
            key: formkey,
            child: TextFormField(
              controller: nameController,
              validator: (value) => value != null && value.length < 3
                  ? 'Enter  valid name'
                  : null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'name',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel')),
            TextButton(
                onPressed: () async {
                  final isValid = formkey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  await user.updateDisplayName(nameController.text.trim());
                  var snackBar = const SnackBar(
                      content: Text('User name updated successfully'));
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ));
                },
                child: const Text('change'))
          ],
        );
      },
    );
  }
}
