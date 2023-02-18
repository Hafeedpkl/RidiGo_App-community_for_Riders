import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? username;
  final String title;
  final LatLng location;
  final String? description;

  MapMarker(
      {required this.title,
      required this.username,
      required this.location,
      required this.description});
}

final mapMarkers = [
  MapMarker(
      username: 'mr user',
      title: 'Iam Stucked Pls help!',
      location: LatLng(51.5382123, -0.1882464),
      description:
          'My bike is breakdown. anyone help or send a mechanic to this location'),
  MapMarker(
      username: 'john',
      title: 'Out of Fuel',
      location: LatLng(51.5090229, -0.2886548),
      description: 'my vehicle is out of fuel help me to get fuel here'),
  MapMarker(
      username: 'The Man',
      title: 'Out of Fuel',
      location: LatLng(51.5090215, -0.1959988),
      description: 'My vehicle is out of fuel.pls help me'),
  MapMarker(
      username: 'rohan',
      title: 'tyre punctured',
      location: LatLng(51.5054563, -0.0798412),
      description:
          'My bike\'s tyre is puncture. if anyone here pickme to go to bus stand'),
  MapMarker(
    title: 'this route is block ',
    username: 'mr rider',
    location: LatLng(51.5077676, -0.2208447),
    description:
        'this route have been traffic block for an hour due to an accident',
  ),
];
