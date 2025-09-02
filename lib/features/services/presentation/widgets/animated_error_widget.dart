// lib/features/services/presentation/widgets/animated_error_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onGetHelp;
  final String? title;
  final IconData? customIcon;

  const AnimatedErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
    this.onGetHelp,
    this.title,
    this.customIcon,
  }) : super(key: key);

  @override
  State<AnimatedErrorWidget> createState() => _AnimatedErrorWidgetState();
}

class _AnimatedErrorWidgetState extends State<AnimatedErrorWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _buttonController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: AppConstants.shakeDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: AppConstants.pulseDuration,
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );

    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
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

    _iconScaleAnimation = Tween<double>(
      begin: AppConstants.opacityTransparent,
      end: AppConstants.scaleNormal,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.8, curve: Curves.bounceOut),
    ));

    _shakeAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _pulseAnimation = Tween<double>(
      begin: AppConstants.scaleNormal,
      end: AppConstants.scaleEnlarged,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: AppConstants.scaleNormal,
      end: AppConstants.scaleEnlarged,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() {
    _mainController.forward();

    Future.delayed(AppConstants.verySlowAnimation, () {
      if (mounted) {
        _shakeController.forward().then((_) {
          _shakeController.reverse();
        });
      }
    });

    Future.delayed(AppConstants.extraSlowAnimation, () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _shakeController,
        _pulseController,
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
                child: SingleChildScrollView(
                  padding: AppConstants.paddingAll32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedIcon(),
                      const SizedBox(height: 32),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildMessage(),
                      const SizedBox(height: 40),
                      _buildActionButtons(),
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

  Widget _buildAnimatedIcon() {
    return Transform.translate(
      offset: Offset(_shakeAnimation.value, 0),
      child: Transform.scale(
        scale: _iconScaleAnimation.value * _pulseAnimation.value,
        child: Container(
          padding: AppConstants.paddingAll32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.errorGradient[0].withOpacity(AppConstants.opacityAlmostOpaque),
                AppColors.errorGradient[1].withOpacity(AppConstants.opacityHigh),
                AppColors.errorGradient[2].withOpacity(AppConstants.opacityMedium),
              ],
            ),
            boxShadow: AppShadows.errorShadow,
          ),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(
                begin: AppConstants.opacityTransparent,
                end: AppConstants.opacityOpaque
            ),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.2,
                child: Icon(
                  widget.customIcon ?? Icons.error_outline,
                  size: AppConstants.iconLarge,
                  color: AppColors.errorRed,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TweenAnimationBuilder<double>(
      duration: AppConstants.slowAnimation,
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
              widget.title ?? AppConstants.errorTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage() {
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
            child: Container(
              padding: AppConstants.paddingSymmetric16_6,
              decoration: BoxDecoration(
                color: AppColors.greyBackground50,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
                border: Border.all(
                  color: AppColors.greyBorder200,
                  width: 1,
                ),
              ),
              child: Text(
                widget.message,
                style: TextStyle(
                  color: AppColors.greyText700,
                  fontSize: AppConstants.fontSizeLarge,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(
          begin: AppConstants.opacityTransparent,
          end: AppConstants.opacityOpaque
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                _buildRetryButton(),
                if (widget.onGetHelp != null) ...[
                  const SizedBox(height: 16),
                  _buildHelpButton(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    return MouseRegion(
      onEnter: (_) => _buttonController.forward(),
      onExit: (_) => _buttonController.reverse(),
      child: Transform.scale(
        scale: _buttonScaleAnimation.value,
        child: AnimatedContainer(
          duration: AppConstants.mediumAnimation,
          width: double.maxFinite,
          constraints: AppConstants.maxWidth300,
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
              });

              _shakeController.forward().then((_) {
                _shakeController.reverse();
              });

              widget.onRetry();
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
              duration: const Duration(milliseconds: 1500),
              tween: Tween(
                  begin: AppConstants.opacityTransparent,
                  end: AppConstants.opacityOpaque
              ),
              builder: (context, iconValue, child) {
                return Transform.rotate(
                  angle: iconValue * 2 * 3.14159,
                  child: const Icon(
                    Icons.refresh,
                    color: AppColors.textWhite,
                    size: AppConstants.iconTiny,
                  ),
                );
              },
            ),
            label: const Text(
              AppConstants.tryAgain,
              style: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                fontSize: AppConstants.fontSizeLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButton() {
    return AnimatedContainer(
      duration: AppConstants.mediumAnimation,
      width: double.maxFinite,
      constraints: AppConstants.maxWidth300,
      child: OutlinedButton.icon(
        onPressed: widget.onGetHelp,
        style: OutlinedButton.styleFrom(
          padding: AppConstants.paddingSymmetric32_16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius25),
          ),
          side: BorderSide(
            color: AppColors.greyBorder400,
            width: 2,
          ),
        ),
        icon: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 2000),
          tween: Tween(
              begin: AppConstants.opacityTransparent,
              end: AppConstants.opacityOpaque
          ),
          builder: (context, iconValue, child) {
            return Transform.scale(
              scale: 0.8 + (iconValue * 0.2),
              child: Icon(
                Icons.help_outline,
                color: AppColors.greyText600,
                size: AppConstants.iconTiny,
              ),
            );
          },
        ),
        label: Text(
          AppConstants.getHelp,
          style: TextStyle(
            color: AppColors.greyText700,
            fontWeight: FontWeight.w600,
            fontSize: AppConstants.fontSizeLarge,
          ),
        ),
      ),
    );
  }
}