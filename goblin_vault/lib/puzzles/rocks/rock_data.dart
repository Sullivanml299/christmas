import 'package:flutter/material.dart';

const List<RockData> ROCKS = [
  RockData(image: AssetImage('assets/stones/red_agate.jpg'), value: 5),
  RockData(image: AssetImage('assets/stones/red_carnelian.jpg'), value: 10),
  RockData(image: AssetImage('assets/stones/wrong4.jpg'), value: 15),
  RockData(image: AssetImage('assets/stones/rose_crystal.jpg'), value: 20),
  RockData(image: AssetImage('assets/stones/wrong5.jpg'), value: 25),
  RockData(image: AssetImage('assets/stones/blue_agate.jpg'), value: 30),
  RockData(image: AssetImage('assets/stones/wrong6.jpg'), value: 100),
  RockData(image: AssetImage('assets/stones/beryl.jpg'), value: 200),
  RockData(image: AssetImage('assets/stones/blue_turqoise.jpg'), value: 300),
  RockData(image: AssetImage('assets/stones/wrong3.jpg'), value: 400),
  RockData(image: AssetImage('assets/stones/zoisite.jpg'), value: 500),
  RockData(image: AssetImage('assets/stones/wrong1.jpg'), value: 600),
  RockData(
      image: AssetImage('assets/stones/snowflake_obsidian.jpg'), value: 700),
  RockData(image: AssetImage('assets/stones/amethyst.jpg'), value: 800),
  RockData(image: AssetImage('assets/stones/wrong0.jpg'), value: 900),
  RockData(image: AssetImage('assets/stones/wrong7.jpg'), value: 1000),
  RockData(image: AssetImage('assets/stones/yellow_quartz.jpg'), value: 1100),
  RockData(image: AssetImage('assets/stones/clear_crystal.jpg'), value: 1200),
];

class RockData {
  const RockData({required this.image, required this.value});

  final AssetImage image;
  final int value;
}
