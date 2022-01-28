import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'defaults.dart';

class TheState {
  final double width;
  final double height;
  final Color color;

  const TheState({
    required this.width,
    required this.height,
    required this.color
  });

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

abstract class StateAction {
  const StateAction();
  TheState modify(TheState state);
}

class SetSide extends StateAction {
  final String attribute;
  final double size;
  const SetSide(this.attribute, this.size);

  @override
  TheState modify(TheState state) {
    return attribute == 'width'
        ? state.copyWith(width: size)
        : state.copyWith(height: size);
  }
}

class SetColor extends StateAction {
  final Color color;
  const SetColor(this.color);
  @override
  TheState modify(TheState state) => state.copyWith(color: color);
}

TheState myReducer(TheState state, dynamic action)
  => action.modify(state);

final store = Store<TheState>(
    myReducer,
    initialState: TheState(width: 0.5, height: 0.5, color: Colors.grey)
);


class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<TheState>(
      store: store,
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
    return StoreBuilder<TheState>(
      builder: (context, store) {
        return OutlinedButton(
            onPressed: () => store.dispatch(SetColor(color)),
            child: Text(label, style: buttonStyle(color))
        );
      }
    );
  }
}


class MySlider extends StatelessWidget {
  final String attribute;
  const MySlider({
    required this.attribute,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<TheState>(
      builder: (context, store) {
        return Slider(
            value: store.state.getSide(attribute),
            onChanged: (value) {
              store.dispatch(SetSide(attribute, value));
            }
        );
      }
    );
  }
}


class TheSquare extends StatelessWidget {
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<TheState>(
        builder: (context, store) {
          return SizedBox(
              width: 50 + store.state.getSide('width') * 200,
              height: 50 + store.state.getSide('height') * 200,
              child: DecoratedBox(decoration: BoxDecoration(color: store.state.color))
          );
        });
  }
}