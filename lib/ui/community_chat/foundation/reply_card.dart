import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatelessWidget {
  ReplyCard(
      {super.key, required this.text, required this.name, required this.time});
  String text;
  String name;
  DateTime? time;
  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('h:mm a').format(time!.toLocal());
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width - 45),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            // color: const Color(0xffdcf8c6),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        text,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formattedTime,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
