import 'dart:math';
import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/models/layer_sequence.dart';

class LayerIndicator extends StatelessWidget {
  final int currentLayer;
  final int totalLayers;
  final Map<int, LayerMaterial>? layerMaterials;
  final double size;

  const LayerIndicator({
    super.key,
    required this.currentLayer,
    required this.totalLayers,
    this.layerMaterials,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _LayerPainter(
              currentLayer: currentLayer,
              totalLayers: totalLayers,
              layerMaterials: layerMaterials,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLayerLegend(),
      ],
    );
  }

  Widget _buildLayerLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(totalLayers, (index) {
        final layerNum = index + 1;
        final isActive = layerNum <= currentLayer;
        final material =
            layerMaterials?[layerNum] ?? _getDefaultMaterial(layerNum);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? _getMaterialColor(material).withOpacity(0.2)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? _getMaterialColor(material) : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? _getMaterialColor(material)
                      : Colors.grey[400],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Layer $layerNum',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? _getMaterialColor(material)
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  LayerMaterial _getDefaultMaterial(int layer) {
    switch (layer) {
      case 1:
        return LayerMaterial.cowDung;
      case 2:
        return LayerMaterial.dryLeaves;
      case 3:
        return LayerMaterial.greenWaste;
      case 4:
        return LayerMaterial.cocopeat;
      case 5:
        return LayerMaterial.worms;
      default:
        return LayerMaterial.soil;
    }
  }

  Color _getMaterialColor(LayerMaterial material) {
    switch (material) {
      case LayerMaterial.cowDung:
        return const Color(0xFF8B4513); // Brown
      case LayerMaterial.dryLeaves:
        return const Color(0xFFCD853F); // Peru
      case LayerMaterial.greenWaste:
        return const Color(0xFF2E8B57); // Sea Green
      case LayerMaterial.soil:
        return const Color(0xFF654321); // Dark Brown
      case LayerMaterial.worms:
        return const Color(0xFFFF69B4); // Hot Pink
      case LayerMaterial.cocopeat:
        return const Color(0xFFD2691E); // Chocolate
      case LayerMaterial.vegetableScraps:
        return const Color(0xFF32CD32); // Lime Green
    }
  }
}

class _LayerPainter extends CustomPainter {
  final int currentLayer;
  final int totalLayers;
  final Map<int, LayerMaterial>? layerMaterials;

  _LayerPainter({
    required this.currentLayer,
    required this.totalLayers,
    this.layerMaterials,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // Draw outer circle
    final outerPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, outerPaint);

    // Draw layers as arcs
    final anglePerLayer = 2 * 3.14159 / totalLayers;

    for (int i = 0; i < totalLayers; i++) {
      final layerNum = i + 1;
      final startAngle = i * anglePerLayer - 3.14159 / 2;
      final sweepAngle = anglePerLayer;

      final isActive = layerNum <= currentLayer;
      final material =
          layerMaterials?[layerNum] ?? _getDefaultMaterial(layerNum);

      final paint = Paint()
        ..color = isActive ? _getMaterialColor(material) : Colors.grey[200]!
        ..style = PaintingStyle.fill;

      // Draw arc segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw layer number
      if (isActive) {
        final textSpan = TextSpan(
          text: '$layerNum',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final angle = startAngle + sweepAngle / 2;
        final textX = center.dx + (radius * 0.7) * cos(angle);
        final textY = center.dy + (radius * 0.7) * sin(angle);

        textPainter.paint(
          canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
        );
      }
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.3, centerPaint);

    // Draw current layer text
    final textSpan = TextSpan(
      text: 'Layer\n$currentLayer',
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _LayerPainter oldDelegate) {
    return oldDelegate.currentLayer != currentLayer;
  }

  LayerMaterial _getDefaultMaterial(int layer) {
    switch (layer) {
      case 1:
        return LayerMaterial.cowDung;
      case 2:
        return LayerMaterial.dryLeaves;
      case 3:
        return LayerMaterial.greenWaste;
      case 4:
        return LayerMaterial.cocopeat;
      case 5:
        return LayerMaterial.worms;
      default:
        return LayerMaterial.soil;
    }
  }

  Color _getMaterialColor(LayerMaterial material) {
    switch (material) {
      case LayerMaterial.cowDung:
        return const Color(0xFF8B4513);
      case LayerMaterial.dryLeaves:
        return const Color(0xFFCD853F);
      case LayerMaterial.greenWaste:
        return const Color(0xFF2E8B57);
      case LayerMaterial.soil:
        return const Color(0xFF654321);
      case LayerMaterial.worms:
        return const Color(0xFFFF69B4);
      case LayerMaterial.cocopeat:
        return const Color(0xFFD2691E);
      case LayerMaterial.vegetableScraps:
        return const Color(0xFF32CD32);
    }
  }
}
