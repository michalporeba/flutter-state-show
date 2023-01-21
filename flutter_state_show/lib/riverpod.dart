import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'defaults.dart';
import 'immutable_state.dart';

class StateCubit extends Cubit<TheState> {
  StateCubit(): super(const TheState.initial());

  void setSide(String attribute, double size)
    => emit(
        (attribute == 'width')
            ? state.copyWith(width: size)
            : state.copyWith(height: size)
    );

  void setColor(Color color) => emit(state.copyWith(color: color));
}


class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StateCubit(),
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
    return BlocBuilder<StateCubit, TheState>(
      builder: (context, model) {
        return OutlinedButton(
            onPressed: () => context.read<StateCubit>().setColor(color),
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
    return BlocBuilder<StateCubit, TheState>(
      builder: (context, state) {
        return Slider(
            value: state.getSide(attribute),
            onChanged: (value) { context.read<StateCubit>().setSide(attribute, value);}
        );
      }
    );
  }
}


class TheSquare extends StatelessWidget {
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateCubit, TheState>(
        builder: (context, model) {
          return SizedBox(
              width: 50 + model.width * 200,
              height: 50 + model.height * 200,
              child: DecoratedBox(decoration: BoxDecoration(color: model.color))
          );
        }
    );
  }
}