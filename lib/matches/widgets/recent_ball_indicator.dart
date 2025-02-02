import 'package:flutter/material.dart';
import 'package:tracket/utils/colors.dart';

class _BallInfo {
  final String value;
  final Color color;

  _BallInfo(this.value, this.color);
}

class RecentBallsIndicator extends StatelessWidget {
  const RecentBallsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final recentBalls = [
      _BallInfo('4', greenColor),
      _BallInfo('W', Colors.red),
      _BallInfo('6', greenColor),
      _BallInfo('2', Colors.grey[300]!),
      _BallInfo('0', Colors.grey[300]!),
      _BallInfo('-', Colors.grey[300]!),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: recentBalls.map((ball) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            backgroundColor: ball.color,
            radius: 16,
            child: Text(
              ball.value,
              style: TextStyle(
                color: ball.color == Colors.grey[300]
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
