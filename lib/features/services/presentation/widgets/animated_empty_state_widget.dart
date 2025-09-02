import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedEmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool showSubtitle;

  const AnimatedEmptyStateWidget({
    Key? key,
    required this.icon,
    required this.message,
    this.showSubtitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: AppConstants.verySlowAnimation,
      tween: Tween(
          begin: AppConstants.opacityTransparent,
          end: AppConstants.opacityOpaque
      ),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: AppConstants.slowAnimation,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: AppColors.greyGradient,
                      ),
                      boxShadow: AppShadows.greyShadow,
                    ),
                    child: Icon(
                      icon,
                      size: 64,
                      color: AppColors.greyText500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeXXLarge,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showSubtitle)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        AppConstants.tapHeartInstructionSimple,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppColors.greyText600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}