import 'package:flutter/material.dart';
import 'package:worktimer/wave_painter.dart';

class Waveanimation extends StatelessWidget {
  Waveanimation(
      {Key? key,
      required this.width,
      required this.height,
      required this.animation,
      required this.dinpercentage,
      required this.front})
      : super(key: key);
  final double width;
  final double height;
  final Animation<double> animation;
  final double dinpercentage;
  final bool front;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          size: Size(width,
              height), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
          painter: RPSCustomPainter(animation.value, dinpercentage, front),
        );
      },
    );
  }
}
