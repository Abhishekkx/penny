import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Lightweight, high-performance milestone progress bar.
class MilestoneProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final List<MilestoneBadge> milestones;
  final Gradient? progressGradient;

  const MilestoneProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
    this.milestones = const [
      MilestoneBadge(position: 0.5, emoji: '🎯', label: '50%'),
      MilestoneBadge(position: 1.0, emoji: '🚀', label: 'Goal'),
    ],
    this.progressGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height,
              width: totalWidth,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceHigh : AppColors.gray200,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: clampedProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:
                          progressGradient ??
                          const LinearGradient(
                            colors: [
                              AppColors.primaryTeal,
                              AppColors.primaryEmerald,
                              AppColors.primaryMint,
                            ],
                          ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.35,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            SizedBox(
              height: 24,
              width: totalWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: milestones.map((m) {
                  final isReached = clampedProgress >= m.position;
                  final leftPos = (totalWidth * m.position - 12).clamp(
                    0.0,
                    totalWidth - 24,
                  );

                  return Positioned(
                    left: leftPos,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isReached
                            ? (isDark ? AppColors.darkSurface : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusFull,
                        ),
                        border: isReached
                            ? Border.all(
                                color: AppColors.primaryEmerald.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              )
                            : null,
                        boxShadow: isReached
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryEmerald.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        m.emoji,
                        style: TextStyle(
                          fontSize: 12,
                          color: isReached
                              ? null
                              : Colors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MilestoneBadge {
  final double position; // 0.0 to 1.0
  final String emoji;
  final String label;

  const MilestoneBadge({
    required this.position,
    required this.emoji,
    required this.label,
  });
}
