import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';

class PicturePuzzle extends StatefulWidget {
  const PicturePuzzle({super.key, required this.validator});

  final Function validator;

  @override
  State<PicturePuzzle> createState() => _PicturePuzzleState();
}

class _PicturePuzzleState extends State<PicturePuzzle> {
  int? selected;
  final List<PuzzlePiece> pieces = List.generate(
      12,
      (index) =>
          PuzzlePiece(AssetImage('assets/images/pp$index.jpg'), index: index))
    ..shuffle();

  checkSolved() {
    for (var i = 0; i < pieces.length; i++) {
      if (i != pieces[i].index) return;
    }
    validateClue(true);
  }

  @override
  Widget build(BuildContext context) {
    return buildPuzzle();
  }

  Widget buildPuzzle() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: gridBuilder()));
  }

  Widget gridBuilder() {
    return DraggableGridViewBuilder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // childAspectRatio: MediaQuery.of(context).size.width /
        //     (MediaQuery.of(context).size.height / 3),
      ),
      shrinkWrap: true,
      children: listBuilder(),
      isOnlyLongPress: false,
      dragCompletion:
          (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
        swap(beforeIndex, afterIndex);
      },
      dragFeedback: (List<DraggableGridItem> list, int index) {
        return Container(
          width: 200,
          height: 150,
          child: list[index].child,
        );
      },
      dragPlaceHolder: (List<DraggableGridItem> list, int index) {
        return PlaceHolderWidget(
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );

    // return GridView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 3,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //   ),
    //   shrinkWrap: true,
    //   itemCount: pieces.length,
    //   itemBuilder: (context, index) {
    //     return makePiece(index);
    //   },
    // );
  }

  List<DraggableGridItem> listBuilder() {
    List<DraggableGridItem> puzzlePieces = [];
    for (var i = 0; i < pieces.length; i++) {
      puzzlePieces.add(makePiece(i));
    }
    return puzzlePieces;
  }

  DraggableGridItem makePiece(int gridIndex) {
    PuzzlePiece piece = pieces[gridIndex];
    return DraggableGridItem(
        isDraggable: true,
        child: Image(
          image: piece.image!,
        ));
  }

  // Widget makePiece(int gridIndex) {
  //   PuzzlePiece piece = pieces[gridIndex];
  //   return Material(
  //       color: Colors.transparent,
  //       child: Ink(
  //         decoration: BoxDecoration(
  //             border: selected != gridIndex
  //                 ? null
  //                 : Border.all(color: Colors.green, width: 5),
  //             image: DecorationImage(image: piece.image!)),
  //         child: InkWell(
  //           splashColor: Colors.green,
  //           onTap: () {
  //             if (selected == null) {
  //               setState(() {
  //                 selected = gridIndex;
  //               });
  //             } else if (selected == gridIndex) {
  //               setState(() {
  //                 selected = null;
  //               });
  //             } else {
  //               swap(selected!, gridIndex);
  //             }
  //           },
  //         ),
  //       ));
  // }

  swap(int idx1, int idx2) {
    var temp = pieces[idx1];
    pieces[idx1] = pieces[idx2];
    pieces[idx2] = temp;
    checkSolved();
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    if (isSolved) {
      Navigator.of(context).pop();
    }
  }
}

class PuzzlePiece {
  const PuzzlePiece(this.image, {required this.index});

  final int index;
  final AssetImage? image;
}
