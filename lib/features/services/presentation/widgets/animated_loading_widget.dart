import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedLoadingWidget extends StatelessWidget {
  final String message;
  final Color? color;

  const AnimatedLoadingWidget({
    Key? key,
    required this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(
                begin: AppConstants.opacityTransparent,
                end: AppConstants.opacityOpaque
            ),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          TweenAnimationBuilder<double>(
            duration: AppConstants.verySlowAnimation,
            tween: Tween(
                begin: AppConstants.opacityTransparent,
                end: AppConstants.opacityOpaque
            ),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
