// lib/features/services/presentation/widgets/animated_empty_favorites_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedEmptyFavoritesWidget extends StatefulWidget {
  final VoidCallback onExplorePressed;

  const AnimatedEmptyFavoritesWidget({
    Key? key,
    required this.onExplorePressed,
  }) : super(key: key);

  @override
  State<AnimatedEmptyFavoritesWidget> createState() => _AnimatedEmptyFavoritesWidgetState();
}

class _AnimatedEmptyFavoritesWidgetState extends State<AnimatedEmptyFavoritesWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _heartController;
  late AnimationController _buttonController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartBeatAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: AppConstants.extraSlowAnimation,
      vsync: this,
    );

    _heartController = AnimationController(
      duration: AppConstants.heartBeatDuration,
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: AppConstants.opacityTransparent,
      end: AppConstants.scaleNormal,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: AppConstants.opacityTransparent,
      end: AppConstants.opacityOpaque,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    ));

    _heartBeatAnimation = Tween<double>(
      begin: AppConstants.scaleNormal,
      end: AppConstants.scaleHeartBeat,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: AppConstants.scaleNormal,
      end: AppConstants.scaleEnlarged,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _mainController.forward();

    Future.delayed(AppConstants.verySlowAnimation, () {
      if (mounted) {
        _heartController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _heartController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _heartController,
        _buttonController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Center(
                child: Padding(
                  padding: AppConstants.paddingAll32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedHeartIcon(),
                      const SizedBox(height: 32),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 32),
                      _buildExploreButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHeartIcon() {
    return Transform.scale(
      scale: _heartBeatAnimation.value,
      child: AnimatedContainer(
        duration: AppConstants.slowAnimation,
        padding: AppConstants.paddingAll32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.redGradient[0].withOpacity(AppConstants.opacityAlmostOpaque),
              AppColors.redGradient[1].withOpacity(AppConstants.opacityHigh),
              AppColors.redGradient[2].withOpacity(AppConstants.opacityMedium),
            ],
          ),
          boxShadow: AppShadows.favoriteShadow,
        ),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(
              begin: AppConstants.opacityTransparent,
              end: AppConstants.opacityOpaque
          ),
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value * 0.1,
              child: Icon(
                Icons.favorite_border,
                size: AppConstants.iconLarge,
                color: AppColors.favoriteRedLight,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TweenAnimationBuilder<double>(
      duration: AppConstants.verySlowAnimation,
      tween: Tween(
          begin: AppConstants.opacityTransparent,
          end: AppConstants.opacityOpaque
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              AppConstants.noFavoriteServices,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.greyText700,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(
          begin: AppConstants.opacityTransparent,
          end: AppConstants.opacityOpaque
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.greyText600,
                  fontSize: AppConstants.fontSizeLarge,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Tap the '),
                  WidgetSpan(
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.favoriteRedLight,
                      size: AppConstants.iconXTiny,
                    ),
                  ),
                  const TextSpan(
                    text: ' icon on any service to add it to your favorites',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreButton() {
    return TweenAnimationBuilder<double>(
      duration: AppConstants.extraSlowAnimation,
      tween: Tween(
          begin: AppConstants.opacityTransparent,
          end: AppConstants.opacityOpaque
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Transform.scale(
              scale: _buttonScaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => _buttonController.forward(),
                onExit: (_) => _buttonController.reverse(),
                child: AnimatedContainer(
                  duration: AppConstants.mediumAnimation,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius25),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(AppConstants.opacityAlmostOpaque),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(AppConstants.opacityMedium),
                        blurRadius: AppConstants.elevationHigh,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _buttonController.forward().then((_) {
                        _buttonController.reverse();
                        widget.onExplorePressed();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundTransparent,
                      shadowColor: AppColors.backgroundTransparent,
                      padding: AppConstants.paddingSymmetric32_16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius25),
                      ),
                    ),
                    icon: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 2000),
                      tween: Tween(
                          begin: AppConstants.opacityTransparent,
                          end: AppConstants.opacityOpaque
                      ),
                      builder: (context, iconValue, child) {
                        return Transform.rotate(
                          angle: iconValue * 2 * 3.14159,
                          child: const Icon(
                            Icons.explore,
                            color: AppColors.textWhite,
                          ),
                        );
                      },
                    ),
                    label: const Text(
                      AppConstants.exploreServices,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: AppConstants.fontSizeLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}