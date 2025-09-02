import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AnimatedPriceDisplay extends StatelessWidget {
  final double price;
  final int index;

  const AnimatedPriceDisplay({
    Key? key,
    required this.price,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: price),
      builder: (context, value, child) {
        return AnimatedDefaultTextStyle(
          duration: AppConstants.mediumAnimation,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeXLarge,
          ),
          child: Text('₹${value.toStringAsFixed(2)}'),
        );
      },
    );
  }
}