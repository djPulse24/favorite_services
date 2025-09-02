// lib/features/services/presentation/widgets/service_list_item.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/service.dart';
import 'animated_favorite_button.dart';
import 'animated_service_image.dart';
import 'animated_price_display.dart';
import 'service_category_badge.dart';

class ServiceListItem extends StatefulWidget {
  final Service service;
  final VoidCallback onFavoriteToggle;
  final int index;

  const ServiceListItem({
    Key? key,
    required this.service,
    required this.onFavoriteToggle,
    this.index = 0,
  }) : super(key: key);

  @override
  State<ServiceListItem> createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<ServiceListItem>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
        begin: AppConstants.scaleNormal,
        end: AppConstants.scalePressed
    ).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );

    _hoverAnimation = Tween<double>(
        begin: AppConstants.scaleNormal,
        end: AppConstants.scaleHovered
    ).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onCardTap() {
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _hoverAnimation.value,
          child: Container(
            margin: AppConstants.paddingSymmetric16_6,
            child: Material(
              elevation: _isHovered ? AppConstants.elevationMedium : AppConstants.elevationLow,
              shadowColor: AppColors.shadowBlack10,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
              child: AnimatedContainer(
                duration: AppConstants.fastAnimation,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.backgroundWhite,
                      _isHovered ? AppColors.hoverGrey50 : AppColors.backgroundWhite,
                    ],
                  ),
                  border: Border.all(
                    color: _isHovered
                        ? Theme.of(context).primaryColor.withOpacity(AppConstants.opacityMedium)
                        : AppColors.borderGrey,
                    width: 1,
                  ),
                ),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() => _isHovered = true);
                    _hoverController.forward();
                  },
                  onExit: (_) {
                    setState(() => _isHovered = false);
                    _hoverController.reverse();
                  },
                  child: GestureDetector(
                    onTap: _onCardTap,
                    child: Padding(
                      padding: AppConstants.paddingAll16,
                      child: Row(
                        children: [
                          AnimatedServiceImage(
                            service: widget.service,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildServiceDetails(),
                          ),
                          const SizedBox(width: 12),
                          AnimatedFavoriteButton(
                            isFavorite: widget.service.isFavorite,
                            onPressed: widget.onFavoriteToggle,
                          ),
                        ],
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

  Widget _buildServiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.service.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeXLarge,
            color: AppColors.textBlack87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        Text(
          widget.service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.greyText600,
            fontSize: AppConstants.fontSizeMedium,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedPriceDisplay(
              price: widget.service.price,
              index: widget.index,
            ),
            ServiceCategoryBadge(
              category: widget.service.category,
            ),
          ],
        ),
      ],
    );
  }
}