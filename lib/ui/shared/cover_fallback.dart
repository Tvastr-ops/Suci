import 'dart:io';
import 'package:flutter/material.dart';

class CoverWidget extends StatelessWidget {
  final String title;
  final String? coverPath;
  final double width;
  final double height;
  final double borderRadius;
  final bool showTitleInFallback;

  const CoverWidget({
    super.key,
    required this.title,
    this.coverPath,
    this.width = 56,
    this.height = 80,
    this.borderRadius = 8,
    this.showTitleInFallback = false,
  });

  @override
  Widget build(BuildContext context) {
    if (coverPath != null && coverPath!.isNotEmpty) {
      if (coverPath!.startsWith('http://') || coverPath!.startsWith('https://')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(
            coverPath!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallback(context),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: width,
                height: height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        final file = File(coverPath!);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.file(
              file,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallback(context),
            ),
          );
        }
      }
    }

    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate stable color tint based on title hash
    final hash = title.hashCode.abs();
    final tintOptions = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
      colorScheme.surfaceContainerHighest,
    ];
    final onTintOptions = [
      colorScheme.onPrimaryContainer,
      colorScheme.onSecondaryContainer,
      colorScheme.onTertiaryContainer,
      colorScheme.onSurfaceVariant,
    ];
    final colorIndex = hash % tintOptions.length;
    final bgColor = tintOptions[colorIndex];
    final fgColor = onTintOptions[colorIndex];

    final initial = title.trim().isNotEmpty
        ? title.trim().characters.first.toUpperCase()
        : '?';

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            initial,
            style: theme.textTheme.titleMedium?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showTitleInFallback && height >= 100) ...[
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: fgColor.withValues(alpha: 0.8),
                fontSize: 9,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
