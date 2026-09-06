import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Ultra-sleek custom slider featuring:
/// - Rich multi-stop gradient active track (#10B981 to #059669)
/// - Rounded translucent inactive track
/// - Custom glowing white circular thumb
/// - Floating live tooltip badge attached above the thumb
class CustomGradientSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? prefix;
  final String? suffix;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  const CustomGradientSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    required this.max,
    this.divisions,
    this.prefix,
    this.suffix,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  @override
  State<CustomGradientSlider> createState() => _CustomGradientSliderState();
}

class _CustomGradientSliderState extends State<CustomGradientSlider> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedValue = widget.value.clamp(widget.min, widget.max);
    final ratio = (widget.max > widget.min)
        ? (clampedValue - widget.min) / (widget.max - widget.min)
        : 0.0;

    final displayLabel =
        '${widget.prefix ?? ''}${clampedValue.toStringAsFixed(0)}${widget.suffix ?? ''}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const trackHeight = 8.0;
        const thumbRadius = 12.0;
        final usableWidth = totalWidth - (thumbRadius * 2);
        final thumbOffset = thumbRadius + (usableWidth * ratio);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            setState(() => _isDragging = true);
            HapticFeedback.lightImpact();
            widget.onChangeStart?.call(widget.value);
            _updateValueFromOffset(
              details.localPosition.dx,
              usableWidth,
              thumbRadius,
            );
          },
          onHorizontalDragUpdate: (details) {
            _updateValueFromOffset(
              details.localPosition.dx,
              usableWidth,
              thumbRadius,
            );
          },
          onHorizontalDragEnd: (details) {
            setState(() => _isDragging = false);
            widget.onChangeEnd?.call(widget.value);
          },
          onTapDown: (details) {
            setState(() => _isDragging = true);
            HapticFeedback.lightImpact();
            widget.onChangeStart?.call(widget.value);
            _updateValueFromOffset(
              details.localPosition.dx,
              usableWidth,
              thumbRadius,
            );
          },
          onTapUp: (details) {
            setState(() => _isDragging = false);
            widget.onChangeEnd?.call(widget.value);
          },
          onTapCancel: () {
            setState(() => _isDragging = false);
            widget.onChangeEnd?.call(widget.value);
          },
          child: Container(
            height: 64,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Container(
                    height: trackHeight,
                    width: totalWidth,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceHigh
                          : AppColors.gray200,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: trackHeight,
                        width: thumbOffset,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryTeal,
                              AppColors.primaryEmerald,
                              AppColors.primaryMint,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryEmerald.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: (thumbOffset - 36).clamp(0.0, totalWidth - 72),
                  top: _isDragging ? -4 : 4,
                  child: AnimatedScale(
                    scale: _isDragging ? 1.05 : 0.95,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: _isDragging ? 1.0 : 0.85,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryTeal,
                              AppColors.primaryEmerald,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusFull,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryEmerald.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          displayLabel,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: thumbOffset - thumbRadius,
                  top: (64 - (thumbRadius * 2)) / 2,
                  child: AnimatedScale(
                    scale: _isDragging ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: thumbRadius * 2,
                      height: thumbRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryEmerald,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryEmerald.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateValueFromOffset(
    double localX,
    double usableWidth,
    double thumbRadius,
  ) {
    if (usableWidth <= 0) return;
    final progress = ((localX - thumbRadius) / usableWidth).clamp(0.0, 1.0);
    double newValue = widget.min + progress * (widget.max - widget.min);

    if (widget.divisions != null && widget.divisions! > 0) {
      final step = (widget.max - widget.min) / widget.divisions!;
      newValue = (newValue / step).round() * step;
    }

    if ((newValue - widget.value).abs() > 0.001) {
      HapticFeedback.selectionClick();
      widget.onChanged(newValue);
    }
  }
}
