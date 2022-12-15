import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HideAndSeek extends StatefulWidget {
  const HideAndSeek({super.key});

  @override
  State<HideAndSeek> createState() => _HideAndSeekState();
}

class _HideAndSeekState extends State<HideAndSeek> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    // distanceFilter: 100,
  );
  Position? position, startPosition;
  double distance = 0;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();

    // _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("$startPosition\n$position\n$distance"));
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var newPositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? newPosition) {
      setState(() {
        position = newPosition;
        distance = Geolocator.distanceBetween(startPosition!.latitude,
            startPosition!.longitude, position!.latitude, position!.longitude);
      });
    });

    setState(() {
      positionStream = newPositionStream;
    });

    startPosition = await Geolocator.getCurrentPosition();
  }
}
