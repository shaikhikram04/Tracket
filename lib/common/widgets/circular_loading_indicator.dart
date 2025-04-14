import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/sizes.dart';

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({
    super.key,
    this.strokeWidth = TSizes.loadingStrokeWidthLg,
    this.color,
    this.dimension,
    this.valueColor,
  });

  final double strokeWidth;
  final Color? color;
  final double? dimension;
  final Animation<Color?>? valueColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox.square(
          dimension: dimension,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color,
            valueColor: valueColor,
          ),
        ),
      ),
    );
  }
}
