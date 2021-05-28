import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:generative_art/particle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generative art',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  List<Particle> particles = [];

  generateListOfParticles() {
    int numberOfParticles = 1000;

    for (int i = 0; i < numberOfParticles; i++) {
      double randomSize = math.Random().nextDouble() * 20;

      int randomR = math.Random().nextInt(256);
      int randomG = math.Random().nextInt(256);
      int randomB = math.Random().nextInt(256);

      Color randomColor = Color.fromARGB(255, randomR, randomG, randomB);

      double randomRadius = math.Random().nextDouble() * 200;
      double randomTheta = math.Random().nextDouble() * (2 * math.pi);

      Particle particle = Particle(
        size: randomSize,
        radius: randomRadius,
        startingTheta: randomTheta,
        color: randomColor,
      );
      particles.add(particle);
    }
  }

  @override
  void initState() {
    super.initState();

    generateListOfParticles();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );

    Tween<double> _rotationTween = Tween(begin: 0, end: 2 * math.pi);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: MyPainter(
          particles: particles,
          theta: animation.value,
        ),
        child: Container(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Particle> particles;
  final double theta;

  MyPainter({required this.particles, required this.theta});

  @override
  void paint(Canvas canvas, Size size) {
    // generative art
    // double radius = 200.0;

    // paint brush
    var paint = Paint()..strokeWidth = 5;

    /// Calulation:
    /// ----------
    /// x = rcos(theta)
    /// y = rsin(theta)
    ///
    /// vary `theta` to generate different points
    ///

    particles.forEach((particle) {
      double randomTheta = particle.startingTheta + theta;
      double radius = particle.radius;

      double dx = radius * theta * math.cos(randomTheta) + size.width / 2;
      double dy = radius * theta * math.sin(randomTheta) + size.height / 2;

      Offset position = Offset(dx, dy);

      paint.color = particle.color;

      canvas.drawCircle(position, particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
