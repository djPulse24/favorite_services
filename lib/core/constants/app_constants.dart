// lib/core/constants/app_constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  // Strings
  static const String servicesTitle = 'Services';
  static const String allServicesTab = 'All Services';
  static const String favoritesTab = 'Favorites';
  static const String refreshTooltip = 'Refresh Services';
  static const String loadingServices = 'Loading services...';
  static const String loadingFavorites = 'Loading favorites...';
  static const String servicesAvailable = 'services available';
  static const String favoriteService = 'favorite service';
  static const String favoriteServices = 'favorite services';
  static const String noFavoriteServices = 'No favorite services yet';
  static const String noServicesAvailable = 'No services available';
  static const String errorTitle = 'Oops! Something went wrong';
  static const String tryAgain = 'Try Again';
  static const String getHelp = 'Get Help';
  static const String exploreServices = 'Explore Services';
  static const String tapHeartInstruction = 'Tap the ❤️ icon on any service to add it to your favorites';
  static const String tapHeartInstructionSimple = 'Tap the heart icon to add favorites';

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);
  static const Duration extraSlowAnimation = Duration(milliseconds: 1200);
  static const Duration refreshDuration = Duration(milliseconds: 800);
  static const Duration fadeDuration = Duration(milliseconds: 600);
  static const Duration heartBeatDuration = Duration(milliseconds: 1000);
  static const Duration shakeDuration = Duration(milliseconds: 500);
  static const Duration pulseDuration = Duration(milliseconds: 1500);

  // Sizes
  static const double serviceImageSize = 70.0;
  static const double iconLarge = 80.0;
  static const double iconMedium = 32.0;
  static const double iconSmall = 24.0;
  static const double iconTiny = 20.0;
  static const double iconXTiny = 18.0;

  // Padding and Margins
  static const EdgeInsets paddingAll16 = EdgeInsets.all(16.0);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(32.0);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets paddingSymmetric16_6 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0);
  static const EdgeInsets paddingSymmetric12_6 = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const EdgeInsets paddingSymmetric32_16 = EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);

  // Border Radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius25 = 25.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;

  // Elevation
  static const double elevationLow = 3.0;
  static const double elevationMedium = 8.0;
  static const double elevationHigh = 15.0;
  static const double elevationVeryHigh = 25.0;
  static const double elevationExtreme = 40.0;

  // Animation Values
  static const double scaleNormal = 1.0;
  static const double scalePressed = 0.95;
  static const double scaleHovered = 1.02;
  static const double scaleEnlarged = 1.05;
  static const double scaleHeartBeat = 1.1;
  static const double scaleBounce = 1.3;

  // Opacity Values
  static const double opacityTransparent = 0.0;
  static const double opacityLow = 0.1;
  static const double opacityMedium = 0.3;
  static const double opacityHigh = 0.6;
  static const double opacityAlmostOpaque = 0.8;
  static const double opacityOpaque = 1.0;

  // Constraints
  static const BoxConstraints maxWidth300 = BoxConstraints(maxWidth: 300);
}

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6A11CB);
  static const Color primaryBlue = Color(0xFF2575FC);
  static const Color primaryDeepPurple = Colors.deepPurple;

  // Background Colors
  static const Color backgroundGrey = Colors.grey;
  static const Color backgroundTransparent = Colors.transparent;
  static const Color backgroundWhite = Colors.white;

  // Text Colors
  static const Color textWhite = Colors.white;
  static const Color textBlack87 = Colors.black87;
  static const Color textGrey = Colors.grey;

  // Gradient Colors
  static final List<Color> purpleBlueGradient = [primaryPurple, primaryBlue];
  static final List<Color> whiteGradient = [Colors.white, Colors.white];
  static final List<Color> redPinkGradient = [Colors.red[50]!, Colors.pink[50]!];
  static final List<Color> bluePurpleGradient = [Colors.blue[50]!, Colors.purple[50]!];
  static final List<Color> redGradient = [Colors.red[100]!, Colors.pink[100]!, Colors.red[50]!];
  static final List<Color> errorGradient = [Colors.red[100]!, Colors.orange[100]!, Colors.red[50]!];
  static final List<Color> greyGradient = [Colors.grey[100]!, Colors.grey[200]!];
  static final List<Color> greyLightGradient = [Colors.grey[300]!, Colors.grey[400]!];

  // Shadow Colors
  static final Color shadowBlack12 = Colors.black.withOpacity(0.12);
  static final Color shadowBlack10 = Colors.black.withOpacity(0.1);
  static final Color shadowRed20 = Colors.red.withOpacity(0.2);
  static final Color shadowRed10 = Colors.red.withOpacity(0.1);
  static final Color shadowPink10 = Colors.pink.withOpacity(0.1);
  static final Color shadowOrange10 = Colors.orange.withOpacity(0.1);
  static final Color shadowGrey30 = Colors.grey.withOpacity(0.3);

  // State Colors
  static final Color favoriteRed = Colors.red[600]!;
  static final Color favoriteRedLight = Colors.red[400]!;
  static final Color errorRed = Colors.red[500]!;
  static final Color greyText700 = Colors.grey[700]!;
  static final Color greyText600 = Colors.grey[600]!;
  static final Color greyText500 = Colors.grey[500]!;
  static final Color greyBorder200 = Colors.grey[200]!;
  static final Color greyBorder400 = Colors.grey[400]!;
  static final Color greyBackground50 = Colors.grey[50]!;

  // Hover Colors
  static final Color hoverGrey50 = Colors.grey[50]!;

  // Border Colors
  static final Color borderGrey = Colors.grey.withOpacity(0.1);
}

class AppShadows {
  static final List<BoxShadow> cardShadowLow = [
    BoxShadow(
      color: AppColors.shadowBlack10,
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];

  static final List<BoxShadow> cardShadowMedium = [
    BoxShadow(
      color: AppColors.shadowBlack12,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> favoriteShadow = [
    BoxShadow(
      color: AppColors.shadowRed20,
      blurRadius: AppConstants.elevationVeryHigh,
      spreadRadius: 8,
    ),
    BoxShadow(
      color: AppColors.shadowRed10,
      blurRadius: AppConstants.elevationExtreme,
      spreadRadius: 15,
    ),
  ];

  static final List<BoxShadow> errorShadow = [
    BoxShadow(
      color: AppColors.shadowRed20,
      blurRadius: AppConstants.elevationVeryHigh,
      spreadRadius: 8,
    ),
    BoxShadow(
      color: AppColors.shadowOrange10,
      blurRadius: AppConstants.elevationExtreme,
      spreadRadius: 15,
    ),
  ];

  static final List<BoxShadow> greyShadow = [
    BoxShadow(
      color: AppColors.shadowGrey30,
      blurRadius: 15,
      spreadRadius: 2,
    ),
  ];
}