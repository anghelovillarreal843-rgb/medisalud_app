import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.points,
    this.height = 190,
    this.color = AppColors.blue,
  });

  final List<WeekPoint> points;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.fold<int>(0, (max, p) => math.max(max, p.value));

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barArea = math.max(60.0, constraints.maxHeight - 54);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < points.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${points[i].value}',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: points[i].value == maxValue
                                ? AppColors.navy
                                : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: math.max(
                            8,
                            barArea * points[i].value / maxValue,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: points[i].value == maxValue
                                  ? [AppColors.teal, AppColors.blue]
                                  : [
                                      color.withValues(alpha: 0.38),
                                      color.withValues(alpha: 0.78),
                                    ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          points[i].label,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class SpecialtyDonut extends StatelessWidget {
  const SpecialtyDonut({
    super.key,
    required this.data,
    this.size = 148,
    this.strokeWidth = 20,
    this.centerLabel = 'citas',
  });

  final List<SpecialtyShare> data;
  final double size;
  final double strokeWidth;
  final String centerLabel;

  @override
  Widget build(BuildContext context) {
    final total = data.fold<int>(0, (sum, item) => sum + item.value);

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 300;
        final chart = SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _DonutPainter(data: data, strokeWidth: strokeWidth),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    centerLabel,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        final legend = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in data)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.value}%',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );

        if (narrow) {
          return Column(children: [chart, const SizedBox(height: 16), legend]);
        }

        return Row(
          children: [
            chart,
            const SizedBox(width: 24),
            Expanded(child: legend),
          ],
        );
      },
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.data, required this.strokeWidth});

  final List<SpecialtyShare> data;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<int>(0, (sum, item) => sum + item.value);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = AppColors.softSlate;
    canvas.drawCircle(center, radius, background);

    var start = -math.pi / 2;
    const gap = 0.045;
    for (final item in data) {
      final sweep = (item.value / total) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = item.color;
      canvas.drawArc(rect, start + gap / 2, sweep - gap, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.strokeWidth != strokeWidth;
  }
}

class HorizontalBars extends StatelessWidget {
  const HorizontalBars({
    super.key,
    required this.items,
    this.valueSuffix = '',
    this.barHeight = 8,
  });

  final List<({String label, double value, Color color})> items;
  final String valueSuffix;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final maxValue = items.fold<double>(
      0,
      (max, item) => math.max(max, item.value),
    );

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  items[i].label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Text(
                '${items[i].value.toStringAsFixed(0)}$valueSuffix',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(barHeight),
            child: LinearProgressIndicator(
              value: maxValue == 0 ? 0 : items[i].value / maxValue,
              minHeight: barHeight,
              backgroundColor: AppColors.softSlate,
              valueColor: AlwaysStoppedAnimation<Color>(items[i].color),
            ),
          ),
          if (i != items.length - 1) const SizedBox(height: 15),
        ],
      ],
    );
  }
}
