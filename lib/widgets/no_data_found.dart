import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
    required this.title,
    required this.message,
    this.isPointingButton = false,
    this.rotation = 0,
    this.isRequest = false,
  });

  final String title;
  final String message;
  final bool isPointingButton;
  final int rotation;
  final bool isRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRequest ? Icons.notifications_off_outlined : Icons.group_off,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (isPointingButton)
            ZoomIn(
              child: RotatedBox(
                quarterTurns: rotation,
                child: Icon(
                  Icons.arrow_outward,
                  size: 50,
                  color: Colors.green.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
