import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/ui/home/provider/event_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              // height: size.width * 0.8,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.25,
                    color: Colors.green,
                    child: Image.asset(
                      'assets/images/even-picture1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Consumer<EventProvider>(builder: (context, value, child) {
                    return Container(
                      width: double.infinity,
                      height:
                          value.isExpand ? size.width * 0.3 : size.width * 0.15,
                      // color: Colors.red,
                      child: Center(
                        child: ElevatedButton(
                            onPressed: () {
                              value.changeExpansion();
                            },
                            child: Text(
                                value.isExpand ? 'read less' : 'read more')),
                      ),
                    );
                  }),
                  SizedBox(
                    height: size.width * 0.01,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              Text(
                                'Kawasaki motocross',
                                style: GoogleFonts.poppins(fontSize: 13),
                              )
                            ],
                          )),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        iconSize: 20,
                                        onPressed: () {},
                                        icon: Icon(
                                          index % 2 == 0
                                              ? Icons.thumb_up_alt_outlined
                                              : Icons.thumb_up,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '23.1k',
                                        style:
                                            GoogleFonts.poppins(fontSize: 11),
                                      ),
                                    )
                                  ],
                                )),
                            Expanded(
                              flex: 4,
                              child: IconButton(
                                iconSize: 25,
                                onPressed: () {},
                                icon: Icon(
                                  index % 2 == 0
                                      ? Icons.bookmark_border
                                      : Icons.bookmark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Register')))
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
