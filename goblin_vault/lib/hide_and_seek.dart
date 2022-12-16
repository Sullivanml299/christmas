import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class HideAndSeek extends StatefulWidget {
  const HideAndSeek({super.key, required this.validator});

  final Function validator;

  @override
  State<HideAndSeek> createState() => _HideAndSeekState();
}

class _HideAndSeekState extends State<HideAndSeek> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    // distanceFilter: 100,
  );
  Position? position, startPosition;
  double distance = 0;
  DISTANCE currentState = DISTANCE.veryFar;
  StreamSubscription<Position>? positionStream;
  Timer? currentTimer;
  final player = AudioPlayer();
  TextStyle textStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.green);

  @override
  void initState() {
    super.initState();
    requestPermission();
    scheduleTimeout(1 * 1000);
    // _determinePosition();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
    currentTimer?.cancel();
    player.release();
    player.dispose();
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() async {
    await player.play(AssetSource('sounds/Blip_Select.wav'));
    HapticFeedback.vibrate();
    currentTimer = scheduleTimeout(getTimerDuration());
  }

  int getTimerDuration() {
    switch (currentState) {
      case DISTANCE.veryFar:
        return 3 * 1000;
      case DISTANCE.far:
        return 2 * 1000;
      case DISTANCE.near:
        return 1 * 1000;
      case DISTANCE.close:
        return 500;
      case DISTANCE.veryClose:
        return 100;
      default:
        return 3 * 1000;
    }
  }

  updateState() {
    DISTANCE newState = currentState;
    if (distance < 15) {
      newState = DISTANCE.veryClose;
    } else if (distance < 30) {
      newState = DISTANCE.close;
    } else if (distance < 60) {
      newState = DISTANCE.near;
    } else if (distance < 100) {
      newState = DISTANCE.far;
    } else if (distance < 150) {
      newState = DISTANCE.veryFar;
    }
    setState(() {
      currentState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateState();
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createText("$startPosition"),
        _createText("$position"),
        _createText("$distance"),
      ],
    ));
  }

  Widget _createText(String s) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            s,
            style: textStyle,
          )
        ],
      ),
    );
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
        if (startPosition != null) {
          distance = Geolocator.distanceBetween(
              startPosition!.latitude,
              startPosition!.longitude,
              position!.latitude,
              position!.longitude);
        }
      });
    });

    setState(() {
      positionStream = newPositionStream;
    });

    startPosition = await Geolocator.getCurrentPosition();
  }
}

enum DISTANCE { veryFar, far, near, close, veryClose }
