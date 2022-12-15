import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/clues.dart';

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
    if (clues != null) {
      return CustomStepper(
          currentStep: _index,
          controlsBuilder: (context, details) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: isSolved[_index] ? details.onStepContinue : null,
                  child: Text('NEXT'),
                ),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('BACK'),
                ),
              ],
            );
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
    return Container();
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
            title: Text('Step ${data.index + 1} title'),
            state: CustomStepState.customIcon,
            customIcon: Icon(
              isSolved[data.index] ? Icons.lock_open : Icons.lock,
              size: 18.0,
            ),
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
}
