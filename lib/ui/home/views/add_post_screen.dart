import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';

import '../../community_chat/model/group_model.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key, required this.groupData});
  Group? groupData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kBackgroundColor,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavScreen(),
                  ));
            }),
      ),
      body: SizedBox(
        width: size.width,
        child: Consumer<PostProvider>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: Form(
              key: value.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.black,
                    ),
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: value.image != null
                                ? Image(
                                    image:
                                        Image.file(value.image!.absolute).image)
                                : const SizedBox(
                                    child: Center(
                                      child: Text(
                                        'Please Add Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                value.getImage();
                              },
                              icon: const Icon(
                                  Icons.add_photo_alternate_outlined),
                              label: const Text('Add Photo')),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RadioListTile(
                                    activeColor: Colors.blueAccent,
                                    tileColor:
                                        Colors.lightBlueAccent.withOpacity(0.3),
                                    title: const Text(
                                      "Event",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    value: 1,
                                    groupValue: value.selectedValue,
                                    onChanged: (event) {
                                      value.handleRadioValueChange(event);
                                      log(event.toString());
                                      log(value.selectedPostType);
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  activeColor: Colors.purpleAccent,
                                  tileColor:
                                      Colors.purpleAccent.withOpacity(0.3),
                                  title: const Text(
                                    "Ride",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  value: 2,
                                  groupValue: value.selectedValue,
                                  onChanged: (ride) {
                                    value.handleRadioValueChange(ride);
                                    log(ride.toString());
                                    log(value.selectedPostType);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: size.width * 0.15,
                              child: Center(
                                  child: InkWell(
                                onTap: () {
                                  value.datePick(context);
                                },
                                child: Card(
                                  color: Colors.tealAccent,
                                  elevation: 3,
                                  child: Container(
                                    height: size.width * 0.1,
                                    width: size.width * 0.3,
                                    child: Center(
                                        child: Text(
                                      value.selectDate ?? 'Choose Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              )),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          controller: value.titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 3
                                  ? 'Enter Title'
                                  : null,
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 5, style: BorderStyle.none))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: value.descriptionController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 3
                                  ? 'Enter desctription'
                                  : null,
                          maxLines: 6,
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 5, style: BorderStyle.none))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavScreen(),
                                  ));
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red)),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!value.formKey.currentState!.validate()) {
                                log('creation failure');
                                return;
                              } else if (value.image == null &&
                                  value.selectDate == null) {
                                log('image and date not getting');
                              } else {
                                AllServices().addPost(
                                    title: value.titleController.text,
                                    desctription:
                                        value.descriptionController.text,
                                    details: groupData!.id,
                                    event: value.selectedPostType,
                                    registrationEndsOn: value.selectDate!,
                                    image: value.image!);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavScreen(),
                                    ));
                              }
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue)),
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
