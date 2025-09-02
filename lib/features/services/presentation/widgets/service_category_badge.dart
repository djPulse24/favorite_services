import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ServiceCategoryBadge extends StatelessWidget {
  final String category;

  const ServiceCategoryBadge({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.mediumAnimation,
      padding: AppConstants.paddingSymmetric12_6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(AppConstants.opacityLow),
            Theme.of(context).primaryColor.withOpacity(AppConstants.opacityMedium),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(AppConstants.opacityMedium),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}