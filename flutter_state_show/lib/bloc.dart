import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'defaults.dart';
import 'immutable_state.dart';

abstract class DemoEvent {
  const DemoEvent();
  TheState modify(TheState state);
}

class SetSide extends DemoEvent {
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

class SetColor extends DemoEvent {
  final Color color;
  const SetColor(this.color);

  @override modify(TheState state) {
    return state.copyWith(color: color);
  }
}

class StateBloc extends Bloc<DemoEvent, TheState> {
  StateBloc(): super(const TheState.initial()) {
    on<DemoEvent>((event, emit) => emit(event.modify(state)));
  }
}

class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StateBloc(),
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
    return BlocBuilder<StateBloc, TheState>(
      builder: (context, model) {
        return OutlinedButton(
            onPressed: () => context.read<StateBloc>().add(SetColor(color)),
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
    return BlocBuilder<StateBloc, TheState>(
      builder: (context, state) {
        return Slider(
            value: state.getSide(attribute),
            onChanged: (value) { context.read<StateBloc>().add(SetSide(attribute, value));}
        );
      }
    );
  }
}


class TheSquare extends StatelessWidget {
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateBloc, TheState>(
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