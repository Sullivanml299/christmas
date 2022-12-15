import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goblin_vault/stop_and_go_timer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';

class StopAndGo extends StatefulWidget {
  const StopAndGo({super.key});

  @override
  State<StopAndGo> createState() => _StopAndGoState();
}

class _StopAndGoState extends State<StopAndGo> {
  double threshold = 0.5;
  List<double>? _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return StopAndGoTimer();
    // Center(
    //     child: Container(
    //         color: isStopped() ? Colors.green : Colors.red,
    //         child: SizedBox(
    //           child:
    //               Center(child: Text('UserAccelerometer: $userAccelerometer')),
    //         )));
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

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    // _streamSubscriptions.add(
    //   accelerometerEvents.listen(
    //     (AccelerometerEvent event) {
    //       setState(() {
    //         _accelerometerValues = <double>[event.x, event.y, event.z];
    //       });
    //     },
    //   ),
    // );
    // _streamSubscriptions.add(
    //   gyroscopeEvents.listen(
    //     (GyroscopeEvent event) {
    //       setState(() {
    //         _gyroscopeValues = <double>[event.x, event.y, event.z];
    //       });
    //     },
    //   ),
    // );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    // _streamSubscriptions.add(
    //   magnetometerEvents.listen(
    //     (MagnetometerEvent event) {
    //       setState(() {
    //         _magnetometerValues = <double>[event.x, event.y, event.z];
    //       });
    //     },
    //   ),
    // );
  }
}
