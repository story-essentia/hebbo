import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatChipSkeleton extends StatelessWidget {
  const StatChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF301a4d),
      highlightColor: const Color(0xFF4d2a7a),
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: 140,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF301a4d),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
