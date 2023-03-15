import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/core/services/all_services.dart';
import 'package:ridigo/ui/bottom_navigation/bottom_navigation.dart';
import 'package:ridigo/ui/map/constants/map_constants.dart';
import 'package:ridigo/ui/map/provider/map_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    Provider.of<MapProvider>(context, listen: false).getMapMarks();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kBackgroundColor,
          title: const Text(
            'Roadside Assistance',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<MapProvider>(builder: (context, value, _) {
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  minZoom: 5,
                  maxZoom: 18,
                  zoom: 11,
                  center: value.currentLocation,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/hafeedpkl/cle2fegak000001n1tudr7gmo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFmZWVkcGtsIiwiYSI6ImNsZTAyM2JweDAzenAzeHJ6ZGIxMGdkdGwifQ.Z2kwziyhnnHfl1eDjko3zg",
                    additionalOptions: const {
                      'mapStyleId': MapConstants.mapBoxStyleId,
                      'accessToken': MapConstants.mapBoxAccessToken,
                    },
                  ),
                  value.mapMarkerList != null
                      ? MarkerLayer(
                          markers: [
                            for (int i = 0;
                                i < value.mapMarkerList!.length;
                                i++)
                              Marker(
                                height: 40,
                                width: 40,
                                point: LatLng(value.mapMarkerList![i].latitude,
                                    value.mapMarkerList![i].longitude),
                                builder: (_) {
                                  return GestureDetector(
                                    onTap: () {
                                      pageController.animateToPage(i,
                                          duration:
                                              const Duration(microseconds: 500),
                                          curve: Curves.easeInOut);
                                      selectedIndex = i;
                                      value.currentLocation = LatLng(
                                          value.mapMarkerList![i].latitude,
                                          value.mapMarkerList![i].longitude);
                                      _animatedMapMove(
                                          value.currentLocation, 11.5);
                                      // setState(() {});
                                    },
                                    child: AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      scale: selectedIndex == i ? 1 : 0.7,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: selectedIndex == i ? 1 : 0.5,
                                        child: value.mapMarkerList![i]
                                                    .username ==
                                                user!.email
                                            ? Image.asset(
                                                'assets/images/map-mark-own.png')
                                            : Image.asset(
                                                'assets/images/map-mark.png'),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ],
                        )
                      : const MarkerLayer(
                          markers: [],
                        )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          _getCurrentLocation();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 30,
                          child: Icon(
                            Icons.my_location_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: value.mapMarkerList != null
                            ? PageView.builder(
                                controller: pageController,
                                onPageChanged: (changedValue) {
                                  selectedIndex = changedValue;
                                  value.currentLocation = LatLng(
                                      value.mapMarkerList![changedValue]
                                          .latitude,
                                      value.mapMarkerList![changedValue]
                                          .longitude);
                                  _animatedMapMove(value.currentLocation, 11.5);
                                  // setState(() {});
                                },
                                itemCount: value.mapMarkerList!.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        log('ontapped');
                                        value.currentLocation = LatLng(
                                            value
                                                .mapMarkerList![index].latitude,
                                            value.mapMarkerList![index]
                                                .longitude);
                                        _animatedMapMove(
                                            value.currentLocation, 11.5);
                                      },
                                      child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    value.mapMarkerList![index]
                                                        .username,
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                                Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              value
                                                                  .mapMarkerList![
                                                                      index]
                                                                  .title!,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Text(
                                                              value
                                                                  .mapMarkerList![
                                                                      index]
                                                                  .description,
                                                              style: const TextStyle(
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          )),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox()),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Future<dynamic> messageBox({latitude, longitude}) {
    final size = MediaQuery.of(context).size;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final formkey = GlobalKey<FormState>();
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          body: SizedBox(
            height: size.height * 0.5,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Send Help!',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: titleController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value!.isNotEmpty && value.length < 3
                                ? 'Enter  valid Title'
                                : null,
                        decoration: InputDecoration(
                            labelText: 'Title (optional)',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey),
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
                        validator: (value) => value != null && value.length < 3
                            ? 'Enter  Message'
                            : null,
                        maxLines: 6,
                        decoration: InputDecoration(
                            labelText: 'Message',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: const MaterialStatePropertyAll(4),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'cancel',
                                style: TextStyle(color: Colors.black),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: const MaterialStatePropertyAll(4),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.blueAccent)),
                              onPressed: () {
                                if (!formkey.currentState!.validate()) return;
                                AllServices().addMapPin(
                                    title: titleController.text.isEmpty
                                        ? 'Help!'
                                        : titleController.text,
                                    description: descriptionController.text,
                                    latitude: latitude,
                                    longitude: longitude);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavScreen(),
                                    ));
                              },
                              child: const Text(
                                ' Send ',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    log('getCurrentLocation');
    final PermissionStatus permissionStatus =
        await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final latitude = position.latitude;
        final longitude = position.longitude;
        log('lat: $latitude long: $longitude', name: 'latitude');
        messageBox(latitude: latitude, longitude: longitude);
      } catch (e) {
        log('Error getting position: $e');
        // handle error
      }
    } else {
      log('Permission denied');
      // handle permission denied
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
