import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'defaults.dart';
import 'immutable_state.dart';


final stateProvider = NotifierProvider<StateNotifier, TheState>(StateNotifier.new);

class StateNotifier extends Notifier<TheState> {
  @override
  TheState build() => const TheState.initial();

  void setSide(String attribute, double size)
  => state =
      (attribute == 'width')
          ? state.copyWith(width: size)
          : state.copyWith(height: size);

  void setColor(Color color) => state = state.copyWith(color: color);
}

class SampleStateApp extends ConsumerWidget {
  final Widget home;

  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: home
    );
  }
}


class ColorButton extends ConsumerWidget {
  final Color color;
  final String label;

  const ColorButton({
    required this.color,
    required this.label,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
        onPressed: () => ref.read(stateProvider.notifier).setColor(color),
        child: Text(label, style: buttonStyle(color))
    );
  }
}


class MySlider extends ConsumerWidget {
  final String attribute;
  const MySlider({
    required this.attribute,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    return Slider(
        value: state.getSide(attribute),
        onChanged: (value) { ref.read(stateProvider.notifier).setSide(attribute, value);}
    );
  }
}


class TheSquare extends ConsumerWidget {
  const TheSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    return SizedBox(
        width: 50 + state.width * 200,
        height: 50 + state.height * 200,
        child: DecoratedBox(decoration: BoxDecoration(color: state.color))
    );
  }
}