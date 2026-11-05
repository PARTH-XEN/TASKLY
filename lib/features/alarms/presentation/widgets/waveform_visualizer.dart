import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated audio waveform visualizer for spoken task reminders.
class WaveformVisualizer extends StatefulWidget {
  final Color color;
  final double height;
  final int barCount;

  const WaveformVisualizer({
    super.key,
    required this.color,
    this.height = 70.0,
    this.barCount = 28,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _WaveformPainter(
            animationValue: _controller.value,
            color: widget.color,
            barCount: widget.barCount,
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int barCount;

  _WaveformPainter({
    required this.animationValue,
    required this.color,
    required this.barCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (barCount * 1.6);
    final spacing = barWidth * 0.6;
    final totalWidth = (barWidth * barCount) + (spacing * (barCount - 1));
    final startX = (size.width - totalWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    for (int i = 0; i < barCount; i++) {
      // Create organic pulsating wave frequencies
      final normalizedIndex = i / barCount;
      final wave1 = math.sin((normalizedIndex * 4 * math.pi) + (animationValue * 2 * math.pi));
      final wave2 = math.cos((normalizedIndex * 2 * math.pi) - (animationValue * 3 * math.pi));
      final combined = ((wave1 + wave2) / 2).abs();

      // Ensure minimum height for subtle vibration feel
      final barHeight = math.max(6.0, combined * size.height);
      final x = startX + (i * (barWidth + spacing));
      final y = (size.height - barHeight) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
