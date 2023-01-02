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
        onPressed: () => _squareState.setColor(color),
        child: Text(label, style: buttonStyle(color))
    );
  }
}


class MySlider extends StatefulWidget {
  final String attribute;

  const MySlider({
    required this.attribute,
    Key? key
  }) : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double value = 0.5;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: value,
        onChanged: (value) {
          print('changing ${widget.attribute} to $value');
          setState(() {
            this.value = value;
            _squareState.setSize(widget.attribute, value);
          });
        }
    );
  }
}


_TheSquareState _squareState = _TheSquareState();

class TheSquare extends StatefulWidget {

  const TheSquare({Key? key}) : super(key: key);

  @override
  State<TheSquare> createState() => _squareState;
}

class _TheSquareState extends State<TheSquare> {
  double width = 150;
  double height = 150;
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(decoration: BoxDecoration(color: color))
    );
  }

  void setColor(Color color) {
    setState(() {
      this.color = color;
    });
  }

  void setSize(String attribute, double size) {
    setState(() {
      if (attribute == 'height') {
        height = 50 + 200 * size;
      } else {
        width = 50 + 200 * size;
      }
    });
  }
}