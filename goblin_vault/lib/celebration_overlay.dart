import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatelessWidget {
  CelebrationOverlay(
      {required this.child, required this.quarterTurns, super.key});

  Widget child;
  int quarterTurns;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          child,
          Center(
            child: RotatedBox(
                quarterTurns: quarterTurns,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 50),
                  duration: Duration(seconds: 3),
                  builder: (context, value, child) => Text(
                    "Puzzle Completed!",
                    style: TextStyle(fontSize: value),
                  ),
                )),
          ),
        ],
      ),
    ));
  }
}
