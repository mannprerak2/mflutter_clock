import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_clock/src/my_clock.dart';

class BackgroundAnimation extends StatefulWidget {
  @override
  _BackgroundAnimationState createState() => _BackgroundAnimationState();
}

const total = 22;

class _BackgroundAnimationState extends State<BackgroundAnimation>
    with TickerProviderStateMixin {
  List<Animation<Offset>> animations;
  List<AnimationController> controllers;
  final Random random = Random();

  @override
  void initState() {
    controllers = List.generate(total, (i) {
      return AnimationController(
          vsync: this,
          duration: Duration(seconds: 15, milliseconds: random.nextInt(5000)));
    });

    animations = List.generate(total, (i) {
      var tween = Tween<Offset>(
          begin: Offset(random.nextDouble(), random.nextDouble()),
          end: Offset(random.nextDouble(), random.nextDouble()));
      var a = tween.animate(controllers[i]);
      a
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            tween.begin = tween.end;
            controllers[i].reset();
            tween.end = Offset(random.nextDouble(), random.nextDouble());
            controllers[i].forward();
          }
        });
      return a;
    });

    controllers.forEach((c) => c.forward());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: BackgroudPainter(
      animations,
      Theme.of(context).brightness == Brightness.light
          ? MyClock.backgroudPatternBlue
          : MyClock.backgroudPatternBlueDark,
      Theme.of(context).brightness == Brightness.light
          ? MyClock.backgroudCirclePatternBlue
          : MyClock.backgroudCirclePatternBlueDark,
    ));
  }

  @override
  void dispose() {
    controllers.forEach((f) => f.dispose());
    super.dispose();
  }
}

class BackgroudPainter extends CustomPainter {
  final Paint paintLine;
  final Paint paintCircle;
  List<Animation<Offset>> points;

  BackgroudPainter(this.points, Color line, Color circle)
      : paintLine = Paint()
          ..color = line
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 6,
        paintCircle = Paint()
          ..color = circle
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 6,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(getOffset(points[i], size), 10, paintCircle);
    }

    for (int i = 3; i < points.length; i += 3) {
      canvas.drawLine(getOffset(points[i - 3], size),
          getOffset(points[i], size), paintLine);
      canvas.drawLine(getOffset(points[i - 2], size),
          getOffset(points[i], size), paintLine);
      canvas.drawLine(getOffset(points[i - 1], size),
          getOffset(points[i], size), paintLine);
    }
  }

  Offset getOffset(Animation<Offset> offset, Size size) =>
      Offset(offset.value.dx * size.width, offset.value.dy * size.height);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
