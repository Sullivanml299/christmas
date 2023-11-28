import 'package:flutter/material.dart';
import 'package:goblin_vault/common/clue.dart';
import 'package:goblin_vault/common/clues.dart';

import 'custom_stepper.dart';

class ClueStepper extends StatefulWidget {
  const ClueStepper({super.key});

  @override
  State<StatefulWidget> createState() => _ClueStepperState();
}

class _ClueStepperState extends State<ClueStepper> {
  int _index = 0;
  List<bool> isSolved = clueTracker;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: buildStepper());
  }

  Widget buildStepper() {
    var clues = buildClues();
    return CustomStepper(
        currentStep: _index,
        controlsBuilder: (context, details) {
          return Container();
        },
        onStepCancel: () {
          cancel();
        },
        onStepContinue: () {
          if (_index < clues.length - 1) {
            setState(() {
              _index += 1;
            });
          }
        },
        onStepTapped: (int index) {
          tapped(index);
        },
        steps: clues);
  }

  cancel() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
  }

  tapped(int i) {
    setState(() {
      _index = i;
    });
  }

  refresh() {
    setState(() {});
  }

  List<CustomStep> buildClues() {
    List<CustomStep> clues = [];
    for (ClueData data in CLUE_DATA) {
      clues.add(
        CustomStep(
            title: Text(data.title),
            state: CustomStepState.customIcon,
            customIcon: buildIcon(data.index),
            content: Container(
              alignment: Alignment.centerLeft,
              child: Clue(
                data: data,
                notifier: refresh,
              ),
            )),
      );
    }
    return clues;
  }

  Widget buildIcon(int index) {
    if (index == _index) {
      return const Image(
        image: AssetImage('assets/images/goblin.gif'),
        fit: BoxFit.scaleDown,
      );
    }
    return Icon(
      isSolved[index] ? Icons.lock_open : Icons.lock,
      size: 18.0,
    );
  }
}
