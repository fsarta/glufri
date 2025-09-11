// lib/core/widgets/skeletons/skeleton_card.dart

import 'package:flutter/material.dart';

/// Un widget generico a forma di rettangolo usato per costruire gli scheletri.
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width, this.radius = 8.0});
  final double? height, width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}

/// La versione 'scheletro' della `PurchaseCard` usata nella cronologia.
class PurchaseCardSkeleton extends StatelessWidget {
  const PurchaseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Riga 1: Titolo e Totale
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(width: 180, height: 24),
                Skeleton(width: 80, height: 24),
              ],
            ),
            SizedBox(height: 12),
            // Riga 2: Data e numero prodotti
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(width: 120, height: 16),
                Skeleton(width: 100, height: 16),
              ],
            ),
            // Divider + Riepilogo (opzionale)
            Divider(height: 16, color: Colors.transparent),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(width: 140, height: 20),
                Skeleton(width: 140, height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// La versione 'scheletro' di un ListTile semplice
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Skeleton(width: 40, height: 40, radius: 40),
      title: Skeleton(height: 18),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Skeleton(height: 14, width: 120),
      ),
    );
  }
}
