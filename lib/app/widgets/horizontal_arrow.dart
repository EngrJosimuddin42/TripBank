import 'package:flutter/material.dart';

class HorizontalArrow extends StatelessWidget {
  final double width;
  final Color color;

  const HorizontalArrow({
    super.key,
    this.width = 120,
    this.color = const Color(0xFFFECD08),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 20,
      child: CustomPaint(
        painter: _ArrowPainter(color),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // main line

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width - 10, size.height / 2),
      paint,
    );

    // arrow head

    canvas.drawLine(
      Offset(size.width - 10, size.height / 2),
      Offset(size.width - 16, size.height / 2 - 6),
      paint,
    );

    canvas.drawLine(
      Offset(size.width - 10, size.height / 2),
      Offset(size.width - 16, size.height / 2 + 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
