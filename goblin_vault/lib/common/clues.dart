import 'package:flutter/material.dart';
import 'package:goblin_vault/puzzles/hide-and-seek/hide_and_seek.dart';
import 'package:goblin_vault/puzzles/rocks/keypad.dart';
import 'package:goblin_vault/puzzles/slider/picture_puzzle.dart';
import 'package:goblin_vault/puzzles/planets/planet_puzzle.dart';
import 'package:goblin_vault/common/qr_scanner.dart';
import 'package:goblin_vault/puzzles/red-green-light/stop_and_go_timer.dart';

import '../puzzles/riddle/clock.dart';

class ClueData {
  ClueData(
      {required this.title,
      required this.prompt,
      required this.password,
      required this.index,
      required this.solver});

  String title, prompt;
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
var PLANETPUZZLE = (Function validator) => PlanetPuzzle(validator: validator);

ClueData C1 = ClueData(
        title: "Infinity and Beyond",
        prompt:
            "Align the celestial bodies from left to right in order to start your journey",
        password: true,
        index: 0,
        solver: PLANETPUZZLE),
    C2 = ClueData(
        title: "Wilderness",
        prompt:
            "Follow the fireflies to find and reassemble the pieces of an ancient rune. They buzz faster and change color as you get closer to each piece.",
        password: "seek",
        index: 1,
        solver: HIDEANDSEEK),
    C3 = ClueData(
        title: "A Time To Remember",
        prompt:
            "Solve the riddle and enter the corresponding time to continue your journey",
        password: const TimeOfDay(hour: 11, minute: 07),
        index: 2,
        solver: CLOCK),
    C4 = ClueData(
        title: "Patience",
        prompt:
            "Complete the obstacle course with the phone attached to you. You can only move when the green light is active. Use the sound as your guide. If you fail, you must restart",
        password: "stopgo",
        index: 3,
        solver: STOPANDGO),
    C5 = ClueData(
        title: "Worth Your Weight In Stone",
        prompt:
            "Dig through the sandstone brick. Use the gemstones you find and the associated chart to determine the passcode.",
        password: "4865",
        index: 4,
        solver: KEYPAD),
    C6 = ClueData(
        title: "Old Man Winter",
        prompt: "Your reward is hidden where old man winter slumbers.",
        password: true,
        index: 5,
        solver: PUZZLE);

List<ClueData> CLUE_DATA = [C1, C2, C3, C4, C5, C6];

List<bool> clueTracker = List.filled(CLUE_DATA.length, false);
