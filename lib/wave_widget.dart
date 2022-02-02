import 'package:flutter/material.dart';

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

class RPSCustomPainter extends CustomPainter {
  double value;
  double percentage;
  bool front;
  RPSCustomPainter(this.value, this.percentage, this.front);

  @override
  void paint(Canvas canvas, Size size) {
    double animvalue = value / (front ? 40 : 30);
    Paint paint0 = Paint()
      ..color = front
          ? Color.fromARGB(100, 33, 150, 243)
          : Color.fromARGB(155, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * -0.0025000, size.height * (1 - percentage));
    path0.quadraticBezierTo(
        size.width * (0.1956250 + animvalue),
        size.height * ((1 - percentage) - animvalue),
        size.width * (0.2487500 + animvalue),
        size.height * ((1 - percentage) - animvalue));
    path0.quadraticBezierTo(
        size.width * (0.3118750 + animvalue),
        size.height * ((1 - percentage) - animvalue),
        size.width * (0.4987500 + animvalue),
        size.height * (1 - percentage));
    path0.quadraticBezierTo(
        size.width * (0.6846875 + animvalue),
        size.height * ((1 - percentage) + animvalue),
        size.width * (0.7475000 + animvalue),
        size.height * ((1 - percentage) + animvalue));
    path0.quadraticBezierTo(
        size.width * (0.8093750 + animvalue),
        size.height * ((1 - percentage) + animvalue),
        size.width * 1,
        size.height * (1 - percentage));
    path0.lineTo(size.width * 1, size.height * 1.0000000);
    path0.lineTo(size.width * -0.0025000, size.height * 1.0000000);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
