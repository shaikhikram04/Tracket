import 'package:flutter/material.dart';
import 'package:tracket/utils/constants/colors.dart';

class _BallInfo {
  final String value;
  final Color color;

  _BallInfo(this.value, this.color);

  factory _BallInfo.fromRun(final run) {
    Color color = Colors.grey[300]!;
    if (run == 'W') {
      color = Colors.red;
    } else if (run == '6' || run == '4') {
      color = primaryColor;
    }
    return _BallInfo(run ?? '-', color);
  }
}

class RecentBallsIndicator extends StatelessWidget {
  const RecentBallsIndicator({super.key, required this.currentOverIndicator});

  final List currentOverIndicator;

  @override
  Widget build(BuildContext context) {
    final recentBalls =
        currentOverIndicator.map((run) => _BallInfo.fromRun(run)).toList();

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
