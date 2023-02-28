import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                const Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    "Hey there you are very innovative .and flutter is awesome framework . This is  a sample chat ",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 5,
                  child: Text(
                    '12:00',
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
