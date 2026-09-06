import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Soft mesh/radial gradient background wrapper that adapts to Light & Dark theme.
class MeshBackground extends StatelessWidget {
  final Widget child;
  final bool showAccentGlow;

  const MeshBackground({
    super.key,
    required this.child,
    this.showAccentGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [AppColors.darkBgStart, AppColors.darkBgEnd]
                    : const [AppColors.lightBgStart, AppColors.lightBgEnd],
              ),
            ),
          ),
        ),

        if (showAccentGlow)
          Positioned(
            top: -120,
            left: -60,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark
                          ? AppColors.primaryEmerald.withValues(alpha: 0.10)
                          : AppColors.primaryEmerald.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

        if (showAccentGlow)
          Positioned(
            top: 250,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isDark
                          ? AppColors.accentIndigo.withValues(alpha: 0.06)
                          : AppColors.primaryMint.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned.fill(child: child),
      ],
    );
  }
}
