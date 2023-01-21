# flutter-state-show

A simple application consisting of two sliders, a few buttons and a controlled by them square 
to show how different state management methods in flutter compare to each other. 

The application has the common starting point and layout, all defined in the `main.dart` 
regardless of the state implementation. To change the state implementation all is required 
is to change the imports. 

All the specific implementations follow the same file layout to make it easy to compare. 

These are the current implementions:

* [direct statefull](./flutter_state_show/lib/statefull_direct.dart) - widgets modifying each others state directly (an anti example).
* [scoped state - poco](./flutter_state_show/lib/scoped_poco.dart) - a simple exmaple of scoped state, but with a very simple POCO state object. 
* [scoped state - better model](./flutter_state_show/lib/scoped_state) - a better example of scoped state. 
* [redux](./flutter_state_show/lib/redux.dart) - state management the redux way. 
* [BLoC - cubit](./flutter_state_show/lib/cubit.dart) - the simpler of two BLoC options. 
* [BLoC - proper](./flutter_state_show/lib/bloc.dart) - the more complex and powerful of the BLoC state management approaches. 
* [Riverpod 2.0](./flutter_state_show/lib/riverpod.dart) - the improved provider.

---
&nbsp;
&nbsp;
# Implementation Details and Comparison

All of the layout code, and most of the setup code, is shared between the solutions and kept in the `main.dart` file. 
The idea here is to keep things that change separately from those that don't, 
so the differences between the approaches can be easily compared. 

## The Starting Point

### The entry point
```dart
class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return home;
  }
}
```

### Colour button
```dart
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
        onPressed: () => print(
            'changing colour to ' + color.value.toString()
        ),
        child: Text(label, style: buttonStyle(color))
    );
  }
}
```

### Slider
```dart
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
        onChanged: (value) { print(
            'changing $attribute to $value'
        );}
    );
  }
}
```

### The square
```dart
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
```

---
&nbsp;
&nbsp;
## Stateful and Direct

### Entry point
```dart
class SampleStateApp extends StatelessWidget {
  final Widget home;
  const SampleStateApp({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return home;
  }
}
```

### Colour button
```dart
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
        onPressed: () => theState.setColor(color),
        child: Text(label, style: buttonStyle(color))
    );
  }
}
```

### Slider
```dart
class _MySliderState extends State<MySlider> {
  double value = 0.5;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: value,
        onChanged: (v) {
          setState(() => value = v);
          if (widget.attribute == 'width') {
            theState.setWidth(50 + value * 200);
          } else {
            theState.setHeight(50 + value * 200);
          }
        }
    );
  }
}
```

### The square
```dart
_TheSquareState theState = _TheSquareState();

class TheSquare extends StatefulWidget {

  const TheSquare({Key? key}) : super(key: key);

  @override
  State<TheSquare> createState() => theState;
}

class _TheSquareState extends State<TheSquare> {
  double width = 150;
  double height = 150;
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width:width,
        height:height,
        child: DecoratedBox(decoration: BoxDecoration(color: color))
    );
  }

  void setWidth(double value) => setState(() => width = value);
  void setHeight(double value) => setState(() => height = value);
  void setColor(Color value) => setState(() => color = value);
}
```

---
&nbsp;
&nbsp;
## Scoped State

### State
```dart
class TheState extends Model {
  double _width = 0.5;
  double _height = 0.5;
  Color _color = Colors.grey;

  double get width => _width;
  double get height => _height;
  Color get color => _color;

  set width(double value) {
    _width = value;
    notifyListeners();
  }

  set height(double value) {
    _height = value;
    notifyListeners();
  }

  set color(Color value) {
    _color = value;
    notifyListeners();
  }
}
```

### Entry point
```dart
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
```

### Colour button
```dart
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
```

### Slider
```dart
class MySlider extends StatelessWidget {
  final String attribute;
  const MySlider({required this.attribute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TheState>(
      builder: (context, child, state) {
        return Slider(
            value: attribute == 'width' ? state.width : state.height,
            onChanged: (value) {
              if (attribute == 'width') {
                state.width = value;
              } else {
                state.height = value;
              }
            }
        );
      }
    );
  }
}
```

### The square
```dart
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
```

---
&nbsp;
&nbsp;
## Redux

### State
```dart
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
```

### State management
```dart
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
    initialState: const TheState.initial()
);
```

### Entry point
```dart
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
```

### Colour button
```dart
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
```

### Slider
```dart
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
```

### The square
```dart
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
```

---
&nbsp;
&nbsp;
## BLoC

### State
```dart
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
```

### State management
```dart
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
```

### Entry point
```dart
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
```

### Colour button
```dart
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
```

### Slider
```dart
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
```

### The square
```dart
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
```

&nbsp;
&nbsp;
# Side by side, bit by bit comparison

---
&nbsp;
&nbsp;
## The State Comparison

### Scoped State
```dart
class TheState extends Model {
  double _width = 0.5;
  double _height = 0.5;
  Color _color = Colors.grey;

  double get width => _width;
  double get height => _height;
  Color get color => _color;

  set width(double value) {
    _width = value;
    notifyListeners();
  }

  set height(double value) {
    _height = value;
    notifyListeners();
  }

  set color(Color value) {
    _color = value;
    notifyListeners();
  }
}
```

### Redux, BLoC and Real BLoC

```dart
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
```

---
&nbsp;
&nbsp;
## The State Management Comparison

### Scoped State
*Move on, there is nothing to see here*

### Redux
```dart
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
    initialState: const TheState.initial()
);
```

### BLoC
```dart
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
```

### Real BLoC
```dart
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
```


---
&nbsp;
&nbsp;
## The Starting Point Comparison
What is inside the 
```dart
void main() {
  runApp(...);
}
```

### Scoped State
```dart
ScopedModel<TheState>(
    model: TheState(),
    child: Home()
);
```

### Redux
```dart
StoreProvider<TheState>(
    store: store,
    child: Home()
);
```

### BLoC
```dart
BlocProvider(
    create: (_) => StateBloc(),
    child: home
);
```

### Real BLoC
```dart
BlocProvider(
    create: (_) => StateCubit(),
    child: Home()
);
```


---
&nbsp;
&nbsp;
## The Slider Comparison
What is returned from `Widget build(BuildContext context)` to build the slider. 
### Scoped State
```dart
return ScopedModelDescendant<TheState>(
    builder: (context, child, state) {
        return Slider(
            value: attribute == 'width' ? state.width : state.height,
            onChanged: (value) {
                if (attribute == 'width') {
                    state.width = value;
                } else {
                    state.height = value;
                }
            }
        );
    }
);
```

### Redux
```dart
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
```

### BLoC
```dart
return BlocBuilder<StateCubit, TheState>(
    builder: (context, state) {
        return Slider(
            value: state.getSide(attribute),
            onChanged: (value) { 
                context.read<StateCubit>()
                    .setSide(attribute, value);
            }
        );
    }
);
```

### Real BLoC
```dart
return BlocBuilder<StateBloc, TheState>(
    builder: (context, state) {
        return Slider(
            value: state.getSide(attribute),
            onChanged: (value) { 
                context.read<StateBloc>()
                    .add(SetSide(attribute, value));
            }
        );
    }
);
```


---
&nbsp;
&nbsp;
## The Square Comparison
Let's look at what is returned from `Widget build(BuildContext context)` to create the square. 

### Scoped State
```dart
return ScopedModelDescendant<TheState>(
    builder: (context, child, state) {
        return SizedBox(
            width: 50 + state.width * 200,
            height: 50 + state.height * 200,
            child: DecoratedBox(
                decoration: BoxDecoration(color: state.color)
            )
        );
    }
);
```

### Redux
```dart
return StoreBuilder<TheState>(
    builder: (context, store) {
        return SizedBox(
            width: 50 + store.state.getSide('width') * 200,
            height: 50 + store.state.getSide('height') * 200,
            child: DecoratedBox(
                decoration: BoxDecoration(color: store.state.color)
            )
        );
    }
);
```

### BLoC
```dart
return BlocBuilder<StateCubit, TheState>(
    builder: (context, model) {
        return SizedBox(
            width: 50 + model.width * 200,
            height: 50 + model.height * 200,
            child: DecoratedBox(
                decoration: BoxDecoration(color: model.color)
            )
        ) ;
    }
);
```

### Real BLoC
```dart
return BlocBuilder<StateBloc, TheState>(
    builder: (context, model) {
        return SizedBox(
            width: 50 + model.width * 200,
            height: 50 + model.height * 200,
            child: DecoratedBox(
                decoration: BoxDecoration(color: model.color)
            )
        );
    }
);
```
