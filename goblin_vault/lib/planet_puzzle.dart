import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:goblin_vault/celebration_overlay.dart';
import 'package:goblin_vault/planet_data.dart';

class PlanetPuzzle extends StatefulWidget {
  const PlanetPuzzle({super.key, required this.validator});

  final Function validator;

  @override
  State<PlanetPuzzle> createState() => _PlanetPuzzleState();
}

class _PlanetPuzzleState extends State<PlanetPuzzle> {
  double distance = 10;
  bool isSolved = false;
  final List<SolarPuzzlePiece> pieces = [...PLANETS]..shuffle();

  bool checkSolved() {
    for (var i = 0; i < pieces.length; i++) {
      if (i != pieces[i].index) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return isSolved
        ? CelebrationOverlay(quarterTurns: 1, child: buildPuzzle())
        : buildPuzzle();
  }

  Widget buildPuzzle() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: gridBuilder()));
  }

  Widget gridBuilder() {
    double height = MediaQuery.of(context).size.height / (pieces.length + 2);
    double width = MediaQuery.of(context).size.width;

    return DraggableGridViewBuilder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: distance,
          crossAxisSpacing: distance,
          mainAxisExtent: height),
      shrinkWrap: true,
      children: listBuilder(),
      isOnlyLongPress: false,
      dragCompletion:
          (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
        insert(beforeIndex, afterIndex);
        if (!isSolved && checkSolved()) {
          setState(() {
            isSolved = true;
          });
        }
        if (isSolved) validateClue(true);
      },
      dragFeedback: (List<DraggableGridItem> list, int index) {
        return Container(
          width: width,
          height: height,
          child: list[index].child,
        );
      },
      dragPlaceHolder: (List<DraggableGridItem> list, int index) {
        return PlaceHolderWidget(
          child: Container(
            color: Colors.black,
          ),
        );
      },
    );
  }

  Widget buildPlaceholder() {
    return Container();
  }

  List<DraggableGridItem> listBuilder() {
    List<DraggableGridItem> puzzlePieces = [];
    for (var i = 0; i < pieces.length; i++) {
      puzzlePieces.add(makePiece(i));
    }
    return puzzlePieces;
  }

  DraggableGridItem makePiece(int gridIndex) {
    double height = MediaQuery.of(context).size.height / (pieces.length + 2);
    double width = MediaQuery.of(context).size.width;
    SolarPuzzlePiece piece = pieces[gridIndex];
    return DraggableGridItem(
        isDraggable: true,
        child: Center(
            child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(width: width, height: height, child: piece.image),
        )));
  }

  insert(int idx1, int idx2) {
    var temp = pieces[idx1];
    pieces.removeAt(idx1);
    pieces.insert(idx2, temp);
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    // if (isSolved) {
    //   Navigator.of(context).pop();
    // }
  }
}
