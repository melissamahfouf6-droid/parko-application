import 'package:flutter/material.dart';

import '../../../../core/theme/parko_colors.dart';

/// Fixed-size map marker (fits FlutterMap Marker box without overflow).
class MapMarkerPin extends StatelessWidget {
  const MapMarkerPin({
    super.key,
    required this.color,
    required this.child,
    this.tailColor,
  });

  final Color color;
  final Color? tailColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tail = tailColor ?? color;
    return SizedBox(
      width: 44,
      height: 52,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 34,
            child: Icon(Icons.arrow_drop_down, color: tail, size: 22),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black26, offset: Offset(0, 2)),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class MapLotCountPin extends StatelessWidget {
  const MapLotCountPin({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MapMarkerPin(
      color: color,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class MapFlashPin extends StatelessWidget {
  const MapFlashPin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapMarkerPin(
      color: ParkoColors.amber,
      tailColor: ParkoColors.amber,
      child: Icon(Icons.flash_on_rounded, color: Colors.white, size: 22),
    );
  }
}

class MapGaragePin extends StatelessWidget {
  const MapGaragePin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapMarkerPin(
      color: ParkoColors.green,
      tailColor: ParkoColors.green,
      child: Icon(Icons.garage_rounded, color: Colors.white, size: 20),
    );
  }
}
