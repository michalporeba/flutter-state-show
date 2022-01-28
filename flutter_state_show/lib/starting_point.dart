import 'package:flutter/material.dart';
import 'defaults.dart';


class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return home;
  }
}


class ColorButton extends StatelessWidget {
  final Color color;
  final String label;

  const ColorButton({
    required this.color,
    required this.label,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => print('changing colour to ' + color.value.toString()),
        child: Text(label, style: buttonStyle(color))
    );
  }
}


class MySlider extends StatelessWidget {
  final String attribute;
  final double value = 0.5;
  const MySlider({
    required this.attribute,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: value,
        onChanged: (value) { print('changing $attribute to $value');}
    );
  }
}


class TheSquare extends StatelessWidget {
  final double width = 150;
  final double height = 150;
  final Color color = Colors.grey;
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width:width,
        height:height,
        child: DecoratedBox(decoration: BoxDecoration(color: color))
    );
  }
}