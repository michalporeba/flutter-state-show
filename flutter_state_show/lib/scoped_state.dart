import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'defaults.dart';


class TheState extends Model {
  double _width = 0.5;
  double _height = 0.5;
  Color _color = Colors.grey;

  double get width => _width;
  double get height => _height;
  Color get color => _color;

  double getSize(String dimension) {
    return dimension == 'width' ? _width : _height;
  }

  void setSize(String dimension, double value) {
    if (dimension == 'width') {
      _width = value;
    } else {
      _height = value;
    }
    notifyListeners();
  }

  set color(Color value) {
    _color = value;
    notifyListeners();
  }
}


class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TheState>(
        model: TheState(),
        child: home
    );
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
    return ScopedModelDescendant<TheState>(
        builder: (context, child, state) {
          return OutlinedButton(
              onPressed: () => state.color = color,
              child: Text(label, style: buttonStyle(color))
          );
        }
    );
  }
}


class MySlider extends StatelessWidget {
  final String attribute;
  const MySlider({required this.attribute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TheState>(
      builder: (context, child, state) {
        return Slider(
            value: state.getSize(attribute),
            onChanged: (value) { state.setSize(attribute, value); }
        );
      }
    );
  }
}


class TheSquare extends StatelessWidget {
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TheState>(
        builder: (context, child, state) {
          return SizedBox(
              width: 50 + state.width * 200,
              height: 50 + state.height * 200,
              child: DecoratedBox(decoration: BoxDecoration(color: state.color))
          );
        }
    );
  }
}