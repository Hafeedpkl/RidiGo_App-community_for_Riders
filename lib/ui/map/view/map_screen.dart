import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:ridigo/core/constants/constants.dart';
import 'package:ridigo/ui/map/constants/map_constants.dart';
import 'package:ridigo/ui/map/model/map_marker_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = MapConstants.myLocation;
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kBackgroundColor,
          title: const Text(
            'RSA Map',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 11,
                center: currentLocation,
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
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < mapMarkers.length; i++)
                      Marker(
                        height: 40,
                        width: 40,
                        point:
                            mapMarkers[i].location ?? MapConstants.myLocation,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {
                              pageController.animateToPage(i,
                                  duration: const Duration(microseconds: 500),
                                  curve: Curves.easeInOut);
                              selectedIndex = i;
                              currentLocation = mapMarkers[i].location ??
                                  MapConstants.myLocation;
                              _animatedMapMove(currentLocation, 11.5);
                              setState(() {});
                            },
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: selectedIndex == i ? 1 : 0.7,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: selectedIndex == i ? 1 : 0.5,
                                child:
                                    Image.asset('assets/images/map-mark.png'),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                )
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 2,
              height: MediaQuery.of(context).size.height * 0.2,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  currentLocation =
                      mapMarkers[value].location ?? MapConstants.myLocation;
                  _animatedMapMove(currentLocation, 11.5);
                  setState(() {});
                },
                itemCount: mapMarkers.length,
                itemBuilder: (_, index) {
                  final item = mapMarkers[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.username.toString(),
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Text(
                                          item.title.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.red),
                                        ),
                                        Text(
                                          item.description.toString(),
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        )),
                  );
                },
              ),
            )
          ],
        ));
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
