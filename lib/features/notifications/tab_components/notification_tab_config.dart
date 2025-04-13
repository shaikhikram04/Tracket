import 'package:flutter/material.dart';

class NotificationTabConfig {
  const NotificationTabConfig({
    required this.text,
    this.icon,
    this.badge,
  });

  final String text;
  final IconData? icon;
  final int? badge;
}