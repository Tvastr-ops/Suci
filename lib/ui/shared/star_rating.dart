import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int? rating; // 0 to 10
  final ValueChanged<int?>? onRatingChanged;
  final double size;
  final bool readOnly;
  final bool showNumber;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 18,
    this.readOnly = false,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRating = rating ?? 0;
    final starScore = effectiveRating / 2.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++) _buildStar(context, i, starScore),
        if (showNumber && rating != null && rating! > 0) ...[
          const SizedBox(width: 6),
          Text(
            starScore.toStringAsFixed(1),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(BuildContext context, int starIndex, double starScore) {
    final color = Theme.of(context).colorScheme.primary;
    final emptyColor =
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5);

    IconData icon;
    Color iconColor;

    if (starScore >= starIndex) {
      icon = Icons.star_rounded;
      iconColor = color;
    } else if (starScore >= starIndex - 0.5) {
      icon = Icons.star_half_rounded;
      iconColor = color;
    } else {
      icon = Icons.star_outline_rounded;
      iconColor = emptyColor;
    }

    final widget = Icon(
      icon,
      size: size,
      color: iconColor,
    );

    if (readOnly || onRatingChanged == null) {
      return widget;
    }

    return GestureDetector(
      onTapDown: (details) {
        // Tap left half = .5 star, tap right half = full star
        // If clicking same star again, toggle off
        final targetRating = (starIndex * 2);
        if (rating == targetRating) {
          onRatingChanged!(null);
        } else {
          onRatingChanged!(targetRating);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: widget,
      ),
    );
  }
}
