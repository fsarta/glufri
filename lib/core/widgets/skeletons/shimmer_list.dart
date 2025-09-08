// lib/core/widgets/skeletons/shimmer_list.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Un widget che mostra una lista di scheletri con un effetto shimmer.
class ShimmerList extends StatelessWidget {
  /// Il widget "scheletro" da mostrare ripetutamente.
  final Widget skeletonCard;

  /// Quanti scheletri mostrare.
  final int length;

  const ShimmerList({super.key, required this.skeletonCard, this.length = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) => skeletonCard,
      ),
    );
  }
}
