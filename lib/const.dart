import 'dart:math';
import 'package:flutter/material.dart';

Color generateRandomLightColor() {
  final Random random = Random();
  int red = random.nextInt(156) + 100;
  int green = random.nextInt(156) + 100;
  int blue = random.nextInt(156) + 100;
  return Color.fromRGBO(red, green, blue, 1);
}

Color generateRandomDarkColor() {
  final Random random = Random();
  int red = random.nextInt(100);
  int green = random.nextInt(100);
  int blue = random.nextInt(100);
  return Color.fromRGBO(red, green, blue, 1);
}

Color getCategoryColor(String categoryName) {
  // Predefined color palette
  final List<Color> colorPalette = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  // Generate an index based on the category name
  final int index = categoryName.hashCode.abs() % colorPalette.length;

  // Return the color from the palette
  return colorPalette[index];
}