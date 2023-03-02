import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OwnMessageCard extends StatelessWidget {
  OwnMessageCard(
      {super.key, required this.text, required this.name, required this.time});
  String text;
  DateTime? time;
  String name;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formattedTime = DateFormat('h:mm a').format(time!.toLocal());

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width - 45),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Color.fromARGB(255, 198, 238, 248),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
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
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text(
                        text,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 5,
                  child: Text(
                    formattedTime,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
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
