import 'dart:async';

import 'package:flutter/material.dart';

class ScrollOverlay extends StatefulWidget {
  const ScrollOverlay({required this.child, required this.text, super.key});
  final Widget? child;
  final String text;

  @override
  State<ScrollOverlay> createState() => _ScrollOverlayState();
}

class _ScrollOverlayState extends State<ScrollOverlay> {
  bool showText = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = scheduleTimeout();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Timer scheduleTimeout([int milliseconds = 2000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    // callback function
    setState(() {
      showText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pop(context);
        });
      },
      child: buildDisplay(context),
    );
  }

  Widget buildDisplay(BuildContext context) {
    return Stack(
      children: [
        //evict becuase caching breaks replay
        Image(
          image: const AssetImage('assets/images/scroll.gif')..evict(),
          fit: BoxFit.fill,
        ),
        showText
            ? Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 5,
                    child: Text(
                      widget.text,
                      style: const TextStyle(color: Colors.black),
                    )))
            : Container()
      ],
    );
  }
}
