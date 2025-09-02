import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/service.dart';

class AnimatedServiceImage extends StatelessWidget {
  final Service service;

  const AnimatedServiceImage({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'service_image_${service.id}',
      child: AnimatedContainer(
        duration: AppConstants.mediumAnimation,
        width: AppConstants.serviceImageSize,
        height: AppConstants.serviceImageSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          boxShadow: AppShadows.cardShadowLow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
          child: Image.network(
            service.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.greyLightGradient,
                  ),
                ),
                child: Icon(
                  Icons.business,
                  color: AppColors.greyText600,
                  size: AppConstants.iconMedium,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.greyBorder200,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius12),
                ),
                child: Center(
                  child: SizedBox(
                    width: AppConstants.iconSmall,
                    height: AppConstants.iconSmall,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}