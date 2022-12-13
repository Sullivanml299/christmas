import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/clues.dart';

class ClueStepper extends StatefulWidget {
  const ClueStepper({super.key});

  @override
  State<StatefulWidget> createState() => _ClueStepperState();
}

class _ClueStepperState extends State<ClueStepper> {
  int _index = 0;
  List<bool> isSolved = clueTracker;
  List<Step>? clues;

  @override
  void initState() {
    super.initState();
    setState(() {
      clues = buildClues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: buildStepper());
  }

  Widget buildStepper() {
    if (clues != null) {
      return Stepper(
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
            if (_index < clues!.length - 1) {
              setState(() {
                _index += 1;
              });
            }
          },
          onStepTapped: (int index) {
            tapped(index);
          },
          steps: clues!);
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

  List<Step> buildClues() {
    List<Step> clues = [];
    for (ClueData data in CLUE_DATA) {
      clues.add(
        Step(
            title: Text('Step ${data.index + 1} title'),
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
