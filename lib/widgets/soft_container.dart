import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SoftContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool isPressed;
  final bool hasGlow;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const SoftContainer({
    super.key,
    required this.child,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.backgroundColor,
    this.isPressed = false,
    this.hasGlow = false,
    this.width = double.infinity,
    this.height = double.infinity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? AppColors.cardBackground;

    Widget container = Container(
      width: width == double.infinity ? null : width,
      height: height == double.infinity ? null : height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    return container;
  }
}
