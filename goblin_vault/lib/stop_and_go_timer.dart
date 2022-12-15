import 'dart:async';

import 'package:flutter/material.dart';

class StopAndGoTimer extends StatefulWidget {
  const StopAndGoTimer({super.key});

  @override
  State<StopAndGoTimer> createState() => _StopAndGoTimerState();
}

class _StopAndGoTimerState extends State<StopAndGoTimer> {
  int countDownMax = 3;
  late int countDown;
  STOP_GO_STATE gameState = STOP_GO_STATE.setup;
  TextStyle textStyle = TextStyle(
      fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    super.initState();
    countDown = countDownMax;
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
      gameState = newState;
      scheduleTimeout(duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return gameState == STOP_GO_STATE.setup ? buildButton() : buildCountDown();
  }

  Widget buildCountDown() {
    Text text = (gameState == STOP_GO_STATE.goCountDown ||
            gameState == STOP_GO_STATE.stopCountDown)
        ? Text(
            "$countDown",
            style: textStyle,
          )
        : Text("");

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
                scheduleTimeout(1000);
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
