import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const AnimatedFavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _heartAnimation = Tween<double>(
        begin: AppConstants.scaleNormal,
        end: AppConstants.scaleBounce
    ).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onPressed() {
    _heartController.forward().then((_) {
      _heartController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heartAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _heartAnimation.value,
          child: GestureDetector(
            onTap: _onPressed,
            child: AnimatedContainer(
              duration: AppConstants.fastAnimation,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isFavorite
                    ? AppColors.favoriteRed.withOpacity(AppConstants.opacityLow)
                    : AppColors.textGrey.withOpacity(AppConstants.opacityLow),
                boxShadow: widget.isFavorite
                    ? [
                  BoxShadow(
                    color: AppColors.shadowRed20,
                    blurRadius: AppConstants.elevationMedium,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: AnimatedSwitcher(
                duration: AppConstants.fastAnimation,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  widget.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  key: ValueKey(widget.isFavorite),
                  color: widget.isFavorite
                      ? AppColors.favoriteRed
                      : AppColors.greyText600,
                  size: AppConstants.iconSmall,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
