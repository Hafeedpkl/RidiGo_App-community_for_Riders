import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class OwnMessageCard extends StatelessWidget {
  OwnMessageCard(
      {super.key,
      required this.text,
      required this.name,
      required this.time,
      required this.date});
  bool date;
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
            color: const Color.fromARGB(255, 198, 238, 248),
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
                  child: Row(
                    children: [
                      date ? getDate(time!) : const SizedBox(),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        formattedTime,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDate(DateTime dateTime) {
    String? month;
    switch (dateTime.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sept';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
    }
    return Text(
      '${dateTime.day}, $month, ${dateTime.year}',
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    );
  }
}
