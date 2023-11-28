import 'package:flutter/material.dart';

List<SolarPuzzlePiece> PLANETS = [
  SolarPuzzlePiece(
      name: "Sun", image: makePiece("assets/images/sun.png", 1), index: 0),
  SolarPuzzlePiece(
      name: "Mercury",
      image: makePiece("assets/images/mercury.png", 0.2),
      index: 1),
  SolarPuzzlePiece(
      name: "Venus",
      image: makePiece("assets/images/venus.png", 0.4),
      index: 2),
  SolarPuzzlePiece(
      name: "Earth",
      image: makePiece("assets/images/earth.png", 0.4),
      index: 3),
  SolarPuzzlePiece(
      name: "Mars", image: makePiece("assets/images/mars.png", 0.3), index: 4),
  SolarPuzzlePiece(
      name: "Jupiter",
      image: makePiece("assets/images/jupiter.png", 0.8),
      index: 5),
  SolarPuzzlePiece(
      name: "Saturn",
      image: makePiece("assets/images/saturn.png", 0.7),
      index: 6),
  SolarPuzzlePiece(
      name: "Uranus",
      image: makePiece("assets/images/uranus.png", 0.6),
      index: 7),
  SolarPuzzlePiece(
      name: "Neptune",
      image: makePiece("assets/images/neptune.png", 0.5),
      index: 8),
];

Widget makePiece(String filepath, double scale) {
  int baseSize = 100;
  return Container(
    color: Colors.transparent,
    child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Image(
          width: baseSize * scale,
          height: baseSize * scale,
          image: AssetImage(filepath),
          fit: BoxFit.scaleDown,
        )),
  );
}

class SolarPuzzlePiece {
  const SolarPuzzlePiece({this.image, required this.index, required this.name});

  final int index;
  final String name;
  final Widget? image;
}
