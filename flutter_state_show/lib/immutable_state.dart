import 'package:flutter/material.dart';

class TheState {
  final double width;
  final double height;
  final Color color;

  const TheState({
    required this.width,
    required this.height,
    required this.color
  });

  const TheState.initial(): width = 0.5, height= 0.5, color = Colors.grey;

  TheState copyWith({
    double? width,
    double? height,
    Color? color,
  }) => TheState(
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color
  );

  double getSide(String attribute)
  => (attribute == 'width')
      ? width
      : height;
}