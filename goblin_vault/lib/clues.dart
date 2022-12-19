import 'package:flutter/material.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/hide_and_seek.dart';
import 'package:goblin_vault/keypad.dart';
import 'package:goblin_vault/picture_puzzle.dart';
import 'package:goblin_vault/qr_scanner.dart';
import 'package:goblin_vault/stop_and_go_timer.dart';

import 'clock.dart';

class ClueData {
  ClueData(
      {required this.prompt,
      required this.password,
      required this.index,
      required this.solver});

  String prompt;
  bool isSolved = false;
  dynamic password;
  int index;
  var solver;
}

var SCANNER = (Function validator) => Scanner(validator: validator);
var CLOCK = (Function validator) => Clock(validator: validator);
var KEYPAD = (Function validator) => Keypad(validator: validator);
var HIDEANDSEEK = (Function validator) => HideAndSeek(validator: validator);
var STOPANDGO = (Function validator) => StopAndGoTimer(validator: validator);
var PUZZLE = (Function validator) => PicturePuzzle(validator: validator);

ClueData C1 = ClueData(
        prompt: "Riddle 2",
        password: const TimeOfDay(hour: 14, minute: 12),
        index: 0,
        solver: CLOCK),
    C2 = ClueData(
        prompt: "Riddle 3", password: "1234", index: 1, solver: KEYPAD),
    C3 = ClueData(
        prompt: "Riddle 4", password: "seek", index: 2, solver: HIDEANDSEEK),
    C4 = ClueData(
        prompt: "Riddle 3", password: "stopgo", index: 3, solver: STOPANDGO),
    C5 = ClueData(prompt: "Riddle 3", password: true, index: 4, solver: PUZZLE);

List<ClueData> CLUE_DATA = [C1, C2, C3, C4, C5];

List<bool> clueTracker = List.filled(CLUE_DATA.length, false);
