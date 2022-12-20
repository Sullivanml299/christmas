import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_vault/particle_canvas.dart';
import 'package:goblin_vault/positions.dart';
import 'package:goblin_vault/qr_scanner.dart';
import 'package:just_audio/just_audio.dart';

class HideAndSeek extends StatefulWidget {
  const HideAndSeek({super.key, required this.validator});

  final Function validator;

  @override
  State<HideAndSeek> createState() => _HideAndSeekState();
}

class _HideAndSeekState extends State<HideAndSeek> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
  );
  bool isSearching = false;
  Position? currentPosition, targetPosition;
  double distance = 1000;
  DISTANCE currentState = DISTANCE.veryFar;
  StreamSubscription<Position>? positionStream;
  Timer? currentTimer;
  final player = AudioPlayer()
    ..setAsset('assets/sounds/botw.mp3')
    ..load();
  TextStyle textStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 10, color: Colors.green);
  int currentIndex = 0;
  List<bool> locationStates = List.filled(POSITIONS.length, false);

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
    currentTimer?.cancel();
    player.dispose();
  }

  Timer scheduleTimeout([int milliseconds = 6000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
        if (!isSearching || currentTimer != timer) {
          print("CANCELLING");
          timer.cancel();
          return;
        }
        player.play();
        player.seek(Duration.zero);
        if (milliseconds != getTimerDuration()) {
          timer.cancel();
          currentTimer = scheduleTimeout(getTimerDuration());
        }
      });

  int getTimerDuration() {
    switch (currentState) {
      case DISTANCE.veryFar:
        return 5000;
      case DISTANCE.far:
        return 4000;
      case DISTANCE.near:
        return 3000;
      case DISTANCE.close:
        return 2000;
      case DISTANCE.veryClose:
        return 1000;
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
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: isSearching ? buildSearchDisplay() : buildButtons(),
    )));
  }

  List<Widget> buildButtons() {
    List<Widget> buttons = [];
    for (var i = 0; i < POSITIONS.length; i++) {
      if (locationStates[i]) {
        buttons.add(Text("FOUND!"));
      } else {
        var p = POSITIONS[i];
        buttons.add(ElevatedButton(
            onPressed: () {
              setState(() {
                isSearching = true;
                targetPosition = p;
                currentTimer = scheduleTimeout();
                currentIndex = i;
              });
            },
            child: Text("Location ${i + 1}")));
      }
    }

    buttons.add(ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scanner(
                      validator: validateClue,
                    )),
          );
        },
        icon: const Icon(Icons.camera),
        label: const Text("Scan")));

    return buttons;
  }

  List<Widget> buildSearchDisplay() {
    List<Widget> contents = [
      SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        child: ParticleCanvas(distance: currentState),
      ),
      // _createText("$currentPosition"),
      _createText("${currentState.name}"),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
              onPressed: () {
                currentTimer?.cancel();
                locationStates[currentIndex] = true;
                setState(() {
                  isSearching = false;
                  targetPosition = null;
                });
              },
              child: const Text("Mark Solved"))),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
              onPressed: () {
                currentTimer?.cancel();
                setState(() {
                  isSearching = false;
                  targetPosition = null;
                });
              },
              child: const Text("Back"))),
    ];
    return contents;
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    return isSolved;
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
        currentPosition = newPosition;
        if (targetPosition != null) {
          distance = Geolocator.distanceBetween(
              targetPosition!.latitude,
              targetPosition!.longitude,
              currentPosition!.latitude,
              currentPosition!.longitude);
        }
      });
    });

    setState(() {
      positionStream = newPositionStream;
    });

    currentPosition = await Geolocator.getCurrentPosition();
  }
}
