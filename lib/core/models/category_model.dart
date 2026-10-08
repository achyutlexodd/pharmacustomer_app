import 'package:flutter/material.dart';

class HealthCategory {
  final String title;
  final String subtitle;
  final String itemCount;
  final IconData icon;
  final Color color;

  const HealthCategory({
    required this.title,
    required this.subtitle,
    required this.itemCount,
    required this.icon,
    required this.color,
  });
}
