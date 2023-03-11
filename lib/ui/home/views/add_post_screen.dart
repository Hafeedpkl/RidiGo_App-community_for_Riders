import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/home/provider/post_provider.dart';

import '../../community_chat/model/group_model.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key, required this.groupData});
  Group? groupData;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    final size = MediaQuery.of(context).size;
    String? gender;
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
              Navigator.pop(context);
            }),
      ),
      body: SizedBox(
        width: size.width,
        child: Consumer<PostProvider>(builder: (context, value, _) {
          return SingleChildScrollView(
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
                              : SizedBox()),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              value.getImage();
                            },
                            icon:
                                const Icon(Icons.add_photo_alternate_outlined),
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
                                    value.handleRadioValueChange(event!);
                                    log('event');
                                  }),
                            ),
                            Expanded(
                              child: RadioListTile(
                                activeColor: Colors.purpleAccent,
                                tileColor: Colors.purpleAccent.withOpacity(0.3),
                                title: const Text(
                                  "Ride",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: 2,
                                groupValue: value.selectedValue,
                                onChanged: (ride) {
                                  value.handleRadioValueChange(ride!);
                                  log('Ride');
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          controller: titleController,
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
                          controller: descriptionController,
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
                          onPressed: () {},
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
                            value.formKey.currentState!.validate();
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
          );
        }),
      ),
    );
  }
}
