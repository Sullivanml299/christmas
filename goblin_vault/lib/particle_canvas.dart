import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as UI;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

class ParticleCanvas extends StatefulWidget {
  ParticleCanvas({required this.distance, super.key});

  DISTANCE distance;

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

class _ParticleCanvasState extends State<ParticleCanvas> {
  List<Particle> particles =
      List.generate(3, (index) => Particle(type: ParticleType.fly));
  double maxVelocity = 2;
  double scale = 2;
  late Timer timer;
  UI.Image? bottle;

  @override
  void initState() {
    super.initState();
    var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    setBottle(size);
    for (Particle p in particles) {
      p.setPosition(size.width / 2, size.height / 2);
      p.setVelocities(
          getRandomDouble(maxVelocity), getRandomDouble(maxVelocity));
    }

    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      List<Particle> trails = [];
      for (Particle p in particles) {
        p.update();
        if (p.type == ParticleType.fly) trails.add(getTrail(p));
      }
      particles.removeWhere((p) => p.alpha <= 0);
      particles.addAll(trails);
      setState(() {});
    });
  }

  getRandomDouble(double max) {
    var rng = Random();
    var sign = rng.nextBool() ? 1 : -1;
    var val = sign * rng.nextDouble() * max;
    return val;
  }

  getTrail(Particle p) {
    Particle trail = Particle(type: ParticleType.trail);
    trail.setPosition(p.x + getRandomDouble(2), p.y + getRandomDouble(2));
    return trail;
  }

  setBottle(Size size) async {
    var b = await loadUiImage("assets/images/bottle_better.png");
    setState(() {
      bottle = b;
    });
    for (Particle p in particles) {
      p.setBoundaries(
          size.width * .5 - b.width / 2.5 * scale,
          size.width * .5 + b.width / 2.5 * scale,
          size.height * .5 - b.height / 7 * scale,
          size.height * .5 + b.height / 2.5 * scale);
    }
  }

  Future<UI.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
            painter: FireFlyPainter(
                particles: particles, bottle: bottle, uiScale: scale)),
      ),
    );
  }
}

class FireFlyPainter extends CustomPainter {
  FireFlyPainter(
      {required this.particles, required this.bottle, required this.uiScale});
  final List<Particle> particles;
  final UI.Image? bottle;
  final uiScale;

  @override
  void paint(Canvas canvas, Size size) {
    paintFlies(canvas, size);
    paintJar(canvas, size);
  }

  paintJar(Canvas canvas, Size size) {
    if (bottle != null) {
      paintImage(
          canvas: canvas,
          scale: 1 / uiScale,
          rect: Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: size.width / 2,
              height: size.height / 2),
          image: bottle!);
    }
  }

  paintFlies(Canvas canvas, Size size) {
    if (bottle == null) return;
    for (Particle p in particles) {
      canvas.drawCircle(
          Offset(p.x, p.y),
          p.radius,
          Paint()
            ..color = Color.fromARGB((p.alpha * 150).round(), 196, 255, 46));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  Particle({required this.type});

  double x = 0,
      y = 0,
      xVel = 0,
      yVel = 0,
      radius = 5,
      maxX = 0,
      maxY = 0,
      minX = 0,
      minY = 0,
      alpha = 1,
      alphaDecay = 0.01;

  ParticleType type;

  setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }

  setVelocities(double dx, double dy) {
    xVel = dx;
    yVel = dy;
  }

  setBoundaries(double minX, maxX, minY, maxY) {
    this.minX = minX;
    this.maxX = maxX;
    this.minY = minY;
    this.maxY = maxY;
  }

  update() {
    switch (type) {
      case ParticleType.fly:
        updateFly();
        break;
      case ParticleType.trail:
        updateTrail();
        break;
    }
  }

  updateTrail() {
    if (alpha > 0) {
      alpha -= alphaDecay;
      radius = alpha * 5;
    }
  }

  updateFly() {
    x += xVel;
    y += yVel;

    if (x > maxX) {
      x = maxX - (x - maxX).abs();
      xVel = -xVel;
    }
    if (y > maxY) {
      y = maxY - (y - maxY).abs();
      yVel = -yVel;
    }
    if (x < minX) {
      x = minX + (x - minX).abs();
      xVel = -xVel;
    }
    if (y < minY) {
      y = minY + (y - minY).abs();
      yVel = -yVel;
    }
  }
}

enum ParticleType {
  fly,
  trail,
}

enum DISTANCE { veryFar, far, near, close, veryClose }
