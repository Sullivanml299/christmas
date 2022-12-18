import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StopAndGoTimer extends StatefulWidget {
  const StopAndGoTimer({super.key, required this.validator});

  final Function validator;

  @override
  State<StopAndGoTimer> createState() => _StopAndGoTimerState();
}

class _StopAndGoTimerState extends State<StopAndGoTimer> {
  int countDownMax = 2;
  late int countDown;
  STOP_GO_STATE gameState = STOP_GO_STATE.setup;
  TextStyle textStyle = TextStyle(
      fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white);
  double threshold = 1;
  List<double>? _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Timer? currentTimer;
  final playerReady = AudioPlayer()
    ..setAsset('assets/sounds/ready.mp3')
    ..load();
  final playerGo = AudioPlayer()
    ..setAsset('assets/sounds/go.mp3')
    ..load();
  final playerStop = AudioPlayer()
    ..setAsset('assets/sounds/stop.mp3')
    ..load();
  final playerReset = AudioPlayer()
    ..setAsset('assets/sounds/record.mp3')
    ..load();

  @override
  void initState() {
    super.initState();
    countDown = countDownMax;
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    currentTimer?.cancel();
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    STOP_GO_STATE? newState;
    int duration = 3 * 1000;
    const int SECOND = 1000;

    switch (gameState) {
      case STOP_GO_STATE.go:
        newState = STOP_GO_STATE.goCountDown;
        duration = SECOND;
        playerReady.seek(Duration.zero);
        playerReady.play();
        break;

      case STOP_GO_STATE.stop:
        newState = STOP_GO_STATE.stopCountDown;
        duration = SECOND;
        playerReady.seek(Duration.zero);
        playerReady.play();
        break;

      case STOP_GO_STATE.goCountDown:
        if (countDown <= 0) {
          countDown = countDownMax;
          newState = STOP_GO_STATE.stop;
          playerStop.seek(Duration.zero);
          playerStop.play();
        } else {
          incrementCountDown();
          duration = SECOND;
        }
        break;

      case STOP_GO_STATE.stopCountDown:
        if (countDown <= 0) {
          countDown = countDownMax;
          newState = STOP_GO_STATE.go;
          playerGo.seek(Duration.zero);
          playerGo.play();
        } else {
          incrementCountDown();
          duration = SECOND;
        }
        break;

      case STOP_GO_STATE.setup:
        playerReady.seek(Duration.zero);
        playerReady.play();
        newState = STOP_GO_STATE.first;
        break;

      case STOP_GO_STATE.first:
        if (countDown <= 0) {
          countDown = countDownMax;
          newState = STOP_GO_STATE.go;
          playerGo.seek(Duration.zero);
          playerGo.play();
        } else {
          incrementCountDown();
          duration = SECOND;
        }
        break;

      default:
        newState = gameState;
        break;
    }

    setState(() {
      currentTimer = scheduleTimeout(duration);
      if (newState != null) gameState = newState;
    });
  }

  incrementCountDown() {
    print("increment");
    countDown--;
    playerReady.seek(Duration.zero);
    playerReady.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gameState == STOP_GO_STATE.setup ? buildButton() : buildCountDown(),
    );
  }

  bool isStopped() {
    if (_userAccelerometerValues == null) return true;
    for (double val in _userAccelerometerValues!) {
      if (val.abs() > threshold) {
        HapticFeedback.vibrate();
        return false;
      }
    }
    return true;
  }

  reset() {
    setState(() {
      gameState = STOP_GO_STATE.setup;
      countDown = countDownMax;
      currentTimer?.cancel();
      currentTimer ??= null;
    });
    playerReset.seek(Duration.zero);
    playerReset.play();
  }

  Widget buildCountDown() {
    print(gameState);
    if ((gameState == STOP_GO_STATE.stop ||
            gameState == STOP_GO_STATE.stopCountDown) &&
        !isStopped()) {
      reset();
    }

    Text text = (gameState == STOP_GO_STATE.goCountDown ||
            gameState == STOP_GO_STATE.stopCountDown ||
            gameState == STOP_GO_STATE.first)
        ? Text(
            "${countDown + 1}",
            style: textStyle,
          )
        : gameState == STOP_GO_STATE.go
            ? Text(
                "GO!",
                style: textStyle,
              )
            : Text(
                "STOP!",
                style: textStyle,
              );

    return Center(
        child: Container(
            color: getColor(),
            child: SizedBox(
              child: Center(child: text),
            )));
  }

  Color getColor() {
    if (gameState == STOP_GO_STATE.first) return Colors.blue;
    if (gameState == STOP_GO_STATE.goCountDown || gameState == STOP_GO_STATE.go)
      return Colors.green;
    return Colors.red;
  }

  Widget buildButton() {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              playerReady.seek(Duration.zero);
              playerReady.play();
              setState(() {
                gameState = STOP_GO_STATE.first;
                currentTimer = scheduleTimeout(1000);
              });
            },
            child: Text("Start")));
  }
}

enum STOP_GO_STATE {
  setup,
  first,
  stop,
  go,
  goCountDown,
  stopCountDown,
}
