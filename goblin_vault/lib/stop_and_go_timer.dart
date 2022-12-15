import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  double threshold = 0.5;
  List<double>? _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Timer? currentTimer;

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
    STOP_GO_STATE newState;
    int duration = 3 * 1000;
    const int SECOND = 1000;

    switch (gameState) {
      case STOP_GO_STATE.go:
        newState = STOP_GO_STATE.goCountDown;
        duration = SECOND;
        break;

      case STOP_GO_STATE.stop:
        newState = STOP_GO_STATE.stopCountDown;
        duration = SECOND;
        break;

      case STOP_GO_STATE.goCountDown:
        if (countDown <= 0) {
          countDown = countDownMax;
          newState = STOP_GO_STATE.stop;
        } else {
          newState = gameState;
          countDown--;
          duration = SECOND;
        }
        break;

      case STOP_GO_STATE.stopCountDown:
        if (countDown <= 0) {
          countDown = countDownMax;
          newState = STOP_GO_STATE.go;
        } else {
          newState = gameState;
          countDown--;
          duration = SECOND;
        }
        break;

      case STOP_GO_STATE.setup:
        newState = STOP_GO_STATE.go;
        break;

      default:
        newState = gameState;
        break;
    }

    setState(() {
      currentTimer = scheduleTimeout(duration);
      gameState = newState;
    });
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
  }

  Widget buildCountDown() {
    if ((gameState == STOP_GO_STATE.stop ||
            gameState == STOP_GO_STATE.stopCountDown) &&
        !isStopped()) {
      reset();
    }

    Text text = (gameState == STOP_GO_STATE.goCountDown ||
            gameState == STOP_GO_STATE.stopCountDown)
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
            color: gameState == STOP_GO_STATE.go ||
                    gameState == STOP_GO_STATE.goCountDown
                ? Colors.green
                : Colors.red,
            child: SizedBox(
              child: Center(child: text),
            )));
  }

  Widget buildButton() {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                gameState = STOP_GO_STATE.stopCountDown;
                currentTimer = scheduleTimeout(1000);
              });
            },
            child: Text("Start")));
  }
}

enum STOP_GO_STATE {
  setup,
  stop,
  go,
  goCountDown,
  stopCountDown,
}
