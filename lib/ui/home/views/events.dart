import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

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
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              // height: size.width * 0.8,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/event-picture.png',
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.width * 0.08,
                          width: double.infinity,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text(
                              'Offroad Training Program',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const ReadMoreText(
                          'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase. in my opinion flutter is very nice language and its very beginner friendly language.this is my project for rider\' community ',
                          trimLines: 2,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          lessStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          style: TextStyle(fontSize: 12),
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
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.asset(
                                      'assets/images/re-logo.png',
                                      fit: BoxFit.fill,
                                      scale: 0.6),
                                ),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                Text(
                                  'royal_enfield_india',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
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
                                onPressed: () {},
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )))
                      ],
                    ),
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
