import 'package:flutter/material.dart';
import 'package:goblin_vault/rock_data.dart';

class RockChart extends StatelessWidget {
  const RockChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: ROCKS.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(content: buildStack(index)),
            ),
            child: buildStack(index),
          );
        },
      ),
    );
  }

  Widget buildStack(int index) {
    return Stack(
      children: [
        Image(
          image: ROCKS[index].image,
          fit: BoxFit.scaleDown,
        ),
        Text(
          ROCKS[index].value.toString(),
          style: const TextStyle(backgroundColor: Colors.black),
        )
      ],
    );
  }
}
