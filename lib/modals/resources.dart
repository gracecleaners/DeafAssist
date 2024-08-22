import 'package:flutter/material.dart';

class ResourceIndex {
  String name;
  VoidCallback onTap;
  Icon icon;

  ResourceIndex({
    required this.name,
    required this.onTap,
    required this.icon,
  });
}
