import 'package:flutter/material.dart';

class Category {
  String thumbnail;
  String name;
  VoidCallback onTap;

  Category({
    required this.name,
    required this.thumbnail,
    required this.onTap,
  });
}

